-- 1. Numero de pacientes atendidos por cada medico
SELECT m.medico_id,
       CONCAT(m.nombre, ' ', m.apellido) AS medico,
       COUNT(DISTINCT c.paciente_id)     AS pacientes_atendidos
FROM medico m
LEFT JOIN cita c ON c.medico_id = m.medico_id
GROUP BY m.medico_id, m.nombre, m.apellido
ORDER BY pacientes_atendidos DESC;
 
-- 2. Total de dias de vacaciones planificadas y disfrutadas por cada empleado
SELECT e.empleado_id,
       CONCAT(e.nombre, ' ', e.apellido) AS empleado,
       COALESCE(SUM(CASE WHEN v.estado = 'planificada' THEN v.dias END), 0) AS dias_planificados,
       COALESCE(SUM(CASE WHEN v.estado = 'disfrutada'  THEN v.dias END), 0) AS dias_disfrutados
FROM empleado e
LEFT JOIN vacaciones_empleado v ON v.empleado_id = e.empleado_id
GROUP BY e.empleado_id, e.nombre, e.apellido
ORDER BY e.empleado_id;
 
-- 3. Medicos con mayor cantidad de horas de consulta en la semana
SELECT m.medico_id,
       CONCAT(m.nombre, ' ', m.apellido) AS medico,
       ROUND(SUM(TIME_TO_SEC(TIMEDIFF(h.hora_fin, h.hora_inicio))) / 3600, 2) AS horas_semana
FROM medico m
JOIN horario_consulta h ON h.medico_id = m.medico_id
GROUP BY m.medico_id, m.nombre, m.apellido
ORDER BY horas_semana DESC;
 
-- 4. Numero de sustituciones realizadas por cada medico sustituto
SELECT m.medico_id,
       CONCAT(m.nombre, ' ', m.apellido) AS medico_sustituto,
       COUNT(s.sustitucion_id)           AS total_sustituciones
FROM medico m
JOIN tipo_medico t ON t.tipo_medico_id = m.tipo_medico_id
LEFT JOIN sustitucion s ON s.medico_sustituto_id = m.medico_id
WHERE t.nombre = 'Sustituto'
GROUP BY m.medico_id, m.nombre, m.apellido
ORDER BY total_sustituciones DESC;
 
-- 5. Numero de medicos que estan actualmente en sustitucion
SELECT COUNT(DISTINCT medico_sustituidoID) AS medicos_en_sustitucion
FROM sustitucion
WHERE CURDATE() BETWEEN fecha_inicio AND fecha_fin;

 
-- 6. Horas totales de consulta por medico por dia de la semana
SELECT m.medico_id,
       CONCAT(m.nombre, ' ', m.apellido) AS medico,
       h.dia_semana,
       ROUND(SUM(TIME_TO_SEC(TIMEDIFF(h.hora_fin, h.hora_inicio))) / 3600, 2) AS horas_dia
FROM medico m
JOIN horario_consulta h ON h.medico_id = m.medico_id
GROUP BY m.medico_id, m.nombre, m.apellido, h.dia_semana
ORDER BY m.medico_id, h.dia_semana;
 
-- 7. Medico con mayor cantidad de pacientes asignados
-- Si hay empate devuelve a todos los empatados
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