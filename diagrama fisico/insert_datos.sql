-- Especialidades (5)
INSERT INTO especialidad (nombre) VALUES
('Medicina General'), ('Pediatria'), ('Cardiologia'), ('Dermatologia'), ('Traumatologia');
 
-- Tipos de medico (3)
INSERT INTO tipo_medico (nombre) VALUES ('Titular'), ('Interino'), ('Sustituto');
 
-- Tipos de empleado (4)
INSERT INTO tipo_empleado (nombre) VALUES
('ATS'), ('Auxiliar de enfermeria'), ('Celador'), ('Administrativo');
 
-- Medicos (10)
INSERT INTO medico (nombre, apellido, edad, experiencia, especialidad_id, tipo_medico_id) VALUES
('pepe1',   'perez', 45, 20, 1, 1),
('pepe2',   'gomez', 38, 12, 2, 1),
('juana1',  'perez', 52, 26, 3, 1),
('juana2',  'gomez', 41, 15, 4, 1),
('carlos1', 'perez', 36,  9, 5, 2),
('carlos2', 'gomez', 34,  7, 1, 2),
('maria1',  'perez', 29,  4, 1, 3),
('maria2',  'gomez', 31,  5, 2, 3),
('luis1',   'perez', 33,  6, 3, 3),
('luis2',   'gomez', 30,  3, 5, 3);
 
-- Empleados (8)
INSERT INTO empleado (tipo_empleado_id, nombre, apellido, edad, experiencia) VALUES
(1, 'ana1',   'diaz',   32,  8),
(1, 'ana2',   'torres', 40, 15),
(2, 'pedro1', 'diaz',   28,  5),
(2, 'pedro2', 'torres', 35, 10),
(3, 'rosa1',  'diaz',   47, 20),
(3, 'rosa2',  'torres', 50, 25),
(4, 'sara1',  'diaz',   27,  3),
(4, 'sara2',  'torres', 44, 18);
 
-- Pacientes (20)
INSERT INTO paciente (nombre, apellido, edad, fecha_ingreso, medico_asignado_id) VALUES
('juan1',   'lopez', 34, '2024-01-15', 1),
('juan2',   'lopez', 28, '2024-02-20', 1),
('juan3',   'ruiz',  45, '2024-03-05', 1),
('lucia1',  'ruiz',  61, '2024-04-11', 1),
('lucia2',  'lopez', 52, '2024-05-23', 1),
('lucia3',  'ruiz',  19, '2024-06-30', 1),
('mateo1',  'lopez', 70, '2024-07-08', 1),
('mateo2',  'ruiz',   8, '2024-08-14', 2),
('mateo3',  'lopez',  5, '2024-09-01', 2),
('sofia1',  'ruiz',  12, '2024-10-09', 2),
('sofia2',  'lopez',  3, '2024-11-17', 2),
('sofia3',  'ruiz',   9, '2025-01-06', 2),
('dani1',   'lopez',  7, '2025-02-13', 2),
('dani2',   'ruiz',  58, '2025-03-19', 3),
('dani3',   'lopez', 66, '2025-04-25', 3),
('ivan1',   'ruiz',  39, '2025-05-30', 4),
('ivan2',   'lopez', 47, '2025-06-12', 4),
('ivan3',   'ruiz',  31, '2025-07-21', 5),
('laura1',  'lopez', 55, '2025-08-05', 6),
('laura2',  'ruiz',  26, '2025-09-10', 7);
 
-- Horarios de consulta (26)
INSERT INTO horario_consulta (medico_id, dia_semana, hora_inicio, hora_fin) VALUES
(1,  'Lunes',     '08:00', '12:00'),
(1,  'Miércoles', '08:00', '12:00'),
(1,  'Viernes',   '14:00', '18:00'),
(2,  'Lunes',     '14:00', '18:00'),
(2,  'Martes',    '08:00', '13:00'),
(2,  'Jueves',    '08:00', '12:00'),
(3,  'Martes',    '08:00', '12:00'),
(3,  'Miércoles', '14:00', '19:00'),
(3,  'Jueves',    '08:00', '12:00'),
(3,  'Viernes',   '08:00', '12:00'),
(4,  'Lunes',     '09:00', '13:00'),
(4,  'Jueves',    '14:00', '18:00'),
(5,  'Martes',    '07:00', '13:00'),
(5,  'Viernes',   '07:00', '13:00'),
(6,  'Lunes',     '08:00', '12:00'),
(6,  'Miércoles', '08:00', '12:00'),
(6,  'Viernes',   '08:00', '12:00'),
(7,  'Lunes',     '08:00', '14:00'),
(7,  'Martes',    '08:00', '12:00'),
(8,  'Miércoles', '14:00', '20:00'),
(8,  'Jueves',    '14:00', '18:00'),
(9,  'Lunes',     '14:00', '18:00'),
(9,  'Viernes',   '08:00', '12:00'),
(10, 'Martes',    '14:00', '18:00'),
(10, 'Jueves',    '08:00', '12:00'),
(10, 'Viernes',   '14:00', '18:00');
 
-- Sustituciones (10)
INSERT INTO sustitucion (medico_sustituto_id, medico_sustituido_id, fecha_inicio, fecha_fin) VALUES
(7,  1, '2026-01-10', '2026-01-24'),
(8,  2, '2026-02-03', '2026-02-17'),
(9,  3, '2026-03-01', '2026-03-15'),
(10, 4, '2026-03-20', '2026-04-03'),
(7,  5, '2026-05-04', '2026-05-18'),
(8,  6, '2026-06-01', '2026-06-15'),
(7,  3, '2026-09-07', NULL),
(9,  1, '2026-08-03', '2026-08-17'),
(8,  4, '2026-09-01', NULL),
(10, 2, '2026-09-08', NULL);
 
-- Citas (20)
INSERT INTO cita (paciente_id, medico_id, empleado_id, fecha_cita, hora_cita) VALUES
(1,  1, 1, '2026-09-04', '14:00:00'),
(2,  1, 2, '2026-09-04', '15:00:00'),
(3,  1, 1, '2026-09-07', '08:00:00'),
(4,  1, 3, '2026-09-07', '09:00:00'),
(5,  1, 1, '2026-09-09', '08:30:00'),
(8,  2, 4, '2026-09-07', '14:30:00'),
(9,  2, 4, '2026-09-08', '08:30:00'),
(10, 2, 5, '2026-09-10', '09:00:00'),
(11, 2, 3, '2026-09-14', '15:00:00'),
(14, 3, 2, '2026-09-08', '08:00:00'),
(15, 3, 2, '2026-09-09', '15:00:00'),
(16, 4, 8, '2026-09-14', '09:30:00'),
(17, 4, 7, '2026-09-17', '14:30:00'),
(18, 5, 6, '2026-09-15', '07:30:00'),
(19, 6, 7, '2026-09-16', '08:00:00'),
(20, 7, 8, '2026-09-14', '08:30:00'),
(6,  1, 1, '2026-09-11', '14:00:00'),
(7,  1, 1, '2026-09-14', '08:00:00'),
(12, 2, 5, '2026-09-15', '09:15:00'),
(13, 2, 4, '2026-09-17', '08:45:00');
 
-- Vacaciones de empleados (8)
INSERT INTO vacaciones_empleado (empleado_id, estado, fecha_inicio, fecha_fin, lugar) VALUES
(1, 'disfrutada',  '2026-01-05', '2026-01-19', 'Cartagena'),
(2, 'disfrutada',  '2026-02-02', '2026-02-13', 'Medellin'),
(3, 'disfrutada',  '2026-03-16', '2026-03-22', 'San Gil'),
(4, 'planificada', '2026-10-05', '2026-10-16', 'Santa Marta'),
(5, 'disfrutada',  '2026-04-06', '2026-04-20', 'Barichara'),
(6, 'planificada', '2026-12-14', '2026-12-31', 'Cali'),
(7, 'disfrutada',  '2026-06-15', '2026-06-24', 'Bogota'),
(1, 'planificada', '2026-12-21', '2026-12-30', 'Armenia');
 
-- Vacaciones de medicos (8)
INSERT INTO vacaciones_medico (medico_id, estado, fecha_inicio, fecha_fin, lugar) VALUES
(1, 'disfrutada',  '2026-01-10', '2026-01-24', 'Cartagena'),
(2, 'disfrutada',  '2026-02-03', '2026-02-17', 'Leticia'),
(3, 'disfrutada',  '2026-03-01', '2026-03-15', 'Cali'),
(4, 'disfrutada',  '2026-03-20', '2026-04-03', 'San Andres'),
(5, 'disfrutada',  '2026-05-04', '2026-05-18', 'Santa Marta'),
(6, 'disfrutada',  '2026-06-01', '2026-06-15', 'Medellin'),
(1, 'planificada', '2026-12-15', '2026-12-30', 'Bogota'),
(3, 'planificada', '2026-10-19', '2026-11-02', 'Cali');