# MediSistema

Base de datos en MySQL para gestionar la información de médicos, empleados y pacientes de un centro de salud: tipos de médico (titular, interino y sustituto), horarios de consulta, sustituciones, citas y vacaciones planificadas y disfrutadas.

## Estructura del repositorio

```
MediSistema/
├── diagramas/
│   ├── diagrama_conceptual.jpg
│   └── diagrama_logico.jpg
├── diagrama_fisico/
│   ├── 01_estructura.sql      # CREATE de la base de datos y las tablas
│   └── 02_datos.sql           # INSERT de los datos de prueba
├── consultas/
│   └── consultas.sql          # Las 20 consultas, diferenciadas por número
├── word_consultas/
│   └── consulta_01.docx ...   # Un Word por consulta, diferenciado por número de pregunta
└── README.md
```

| Carpeta | Contenido |
|---|---|
| `diagramas` | Diagrama conceptual y diagrama lógico. |
| `diagrama_fisico` | Script para crear las tablas y script para insertar los datos. |
| `consultas` | Script con todas las consultas, cada una identificada con su número. |
| `word_consultas` | Documentos Word con las consultas, uno por número de pregunta. |

## Modelo de datos

| Tabla | Descripción |
|---|---|
| `especialidad` | Catálogo de especialidades médicas. |
| `tipo_medico` | Titular, Interino o Sustituto. |
| `tipo_empleado` | ATS, Auxiliar de enfermería, Celador o Administrativo. |
| `medico` | Datos del médico, con su especialidad y su tipo. |
| `empleado` | Personal no médico, con su tipo. |
| `paciente` | Datos del paciente y el médico que tiene asignado. |
| `horario_consulta` | Horas de consulta de cada médico por día de la semana. |
| `sustitucion` | Períodos en los que un médico sustituto reemplaza a otro. Si `fecha_fin` es NULL, la sustitución sigue vigente. |
| `cita` | Relación entre paciente, médico y empleado, con fecha y hora. |
| `vacaciones_medico` | Vacaciones de cada médico, con estado `planificada` o `disfrutada`. |
| `vacaciones_empleado` | Vacaciones de cada empleado, con estado `planificada` o `disfrutada`. |

Relaciones principales:

- Un médico tiene una especialidad y un tipo; un empleado tiene un tipo.
- Un paciente tiene un médico asignado; un médico puede tener muchos pacientes.
- Un médico tiene varias franjas de horario, y varias vacaciones.
- Un empleado tiene varias vacaciones.
- Una cita relaciona un paciente, un médico y un empleado.
- Una sustitución relaciona dos médicos: el sustituto y el sustituido.

## Cómo ejecutar

Requiere MySQL 8.0.16 o superior. Ejecutar en este orden desde MySQL Workbench o la terminal:

```bash
mysql -u root -p < diagrama_fisico/01_estructura.sql
mysql -u root -p < diagrama_fisico/02_datos.sql
mysql -u root -p < consultas/consultas.sql
```

El primer script crea la base de datos `medisistema` y las tablas; el segundo inserta los datos de prueba.

# Consultas

1. **Número de pacientes atendidos por cada médico**

Cuenta los pacientes distintos que tienen al menos una cita con cada médico. Se usa `LEFT JOIN` para que aparezcan también los médicos sin citas.

```sql
SELECT m.medico_id,
       CONCAT(m.nombre, ' ', m.apellido) AS medico,
       COUNT(DISTINCT c.paciente_id)     AS pacientes_atendidos
FROM medico m
LEFT JOIN cita c ON c.medico_id = m.medico_id
GROUP BY m.medico_id, m.nombre, m.apellido
ORDER BY pacientes_atendidos DESC;
```

2. **Total de días de vacaciones planificadas y disfrutadas por cada empleado**

Suma la columna `dias` separando por `estado` con `CASE`. `COALESCE` deja en 0 los empleados que no tienen vacaciones de ese estado.

```sql
SELECT e.empleado_id,
       CONCAT(e.nombre, ' ', e.apellido) AS empleado,
       COALESCE(SUM(CASE WHEN v.estado = 'planificada' THEN v.dias END), 0) AS dias_planificados,
       COALESCE(SUM(CASE WHEN v.estado = 'disfrutada'  THEN v.dias END), 0) AS dias_disfrutados
FROM empleado e
LEFT JOIN vacaciones_empleado v ON v.empleado_id = e.empleado_id
GROUP BY e.empleado_id, e.nombre, e.apellido
ORDER BY e.empleado_id;
```

3. **Médicos con mayor cantidad de horas de consulta en la semana**

Suma la diferencia entre `hora_fin` y `hora_inicio` de todas las franjas de cada médico y ordena de mayor a menor.

```sql
SELECT m.medico_id,
       CONCAT(m.nombre, ' ', m.apellido) AS medico,
       ROUND(SUM(TIME_TO_SEC(TIMEDIFF(h.hora_fin, h.hora_inicio))) / 3600, 2) AS horas_semana
FROM medico m
JOIN horario_consulta h ON h.medico_id = m.medico_id
GROUP BY m.medico_id, m.nombre, m.apellido
ORDER BY horas_semana DESC;
```

4. **Número de sustituciones realizadas por cada médico sustituto**

Filtra los médicos de tipo Sustituto y cuenta las filas de `sustitucion` donde son el sustituto.

```sql
SELECT m.medico_id,
       CONCAT(m.nombre, ' ', m.apellido) AS medico_sustituto,
       COUNT(s.sustitucion_id)           AS total_sustituciones
FROM medico m
JOIN tipo_medico t ON t.tipo_medico_id = m.tipo_medico_id
LEFT JOIN sustitucion s ON s.medico_sustituto_id = m.medico_id
WHERE t.nombre = 'Sustituto'
GROUP BY m.medico_id, m.nombre, m.apellido
ORDER BY total_sustituciones DESC;
```

5. **Número de médicos que están actualmente en sustitución**

Una sustitución está vigente si ya empezó y no tiene `fecha_fin` o esta aún no llega. Se cuentan los médicos sustitutos distintos.

```sql
SELECT COUNT(DISTINCT s.medico_sustituto_id) AS medicos_en_sustitucion
FROM sustitucion s
WHERE s.fecha_inicio <= CURDATE()
  AND (s.fecha_fin IS NULL OR s.fecha_fin >= CURDATE());
```

6. **Horas totales de consulta por médico por día de la semana**

Agrupa por médico y por día. Como `dia_semana` es un ENUM, el orden sale de lunes a sábado.

```sql
SELECT m.medico_id,
       CONCAT(m.nombre, ' ', m.apellido) AS medico,
       h.dia_semana,
       ROUND(SUM(TIME_TO_SEC(TIMEDIFF(h.hora_fin, h.hora_inicio))) / 3600, 2) AS horas_dia
FROM medico m
JOIN horario_consulta h ON h.medico_id = m.medico_id
GROUP BY m.medico_id, m.nombre, m.apellido, h.dia_semana
ORDER BY m.medico_id, h.dia_semana;
```

7. **Médico con mayor cantidad de pacientes asignados**

Cuenta los pacientes por `medico_asignado_id` y deja solo el médico cuyo total es igual al máximo. Si hay empate, salen todos los empatados.

```sql
SELECT m.medico_id,
       CONCAT(m.nombre, ' ', m.apellido) AS medico,
       COUNT(p.paciente_id)              AS pacientes_asignados
FROM medico m
JOIN paciente p ON p.medico_asignado_id = m.medico_id
GROUP BY m.medico_id, m.nombre, m.apellido
HAVING COUNT(p.paciente_id) = (
    SELECT MAX(t.total)
    FROM (SELECT COUNT(*) AS total
          FROM paciente
          WHERE medico_asignado_id IS NOT NULL
          GROUP BY medico_asignado_id) AS t
);
```

8. **Empleados con más de 10 días de vacaciones disfrutadas**

```sql
```

9. **Médicos que actualmente están realizando una sustitución**

```sql
```

10. **Promedio de horas de consulta por médico por día de la semana**

```sql
```

11. **Empleados con mayor número de pacientes atendidos por los médicos bajo su supervisión**

```sql
```

12. **Médicos con más de 5 pacientes y total de horas de consulta en la semana**

```sql
```

13. **Total de días de vacaciones planificadas y disfrutadas por cada tipo de empleado**

```sql
```

14. **Total de pacientes por cada tipo de médico**

```sql
```

15. **Total de horas de consulta por médico y día de la semana**

```sql
```

16. **Número de sustituciones por tipo de médico**

```sql
```

17. **Total de pacientes por médico y por especialidad**

```sql
```

18. **Empleados y médicos con más de 20 días de vacaciones planificadas**

```sql
```

19. **Médicos con el mayor número de pacientes actualmente en sustitución**

```sql
```

20. **Total de horas de consulta por especialidad y día de la semana**

```sql
```
