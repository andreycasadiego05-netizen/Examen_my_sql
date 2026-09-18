-- ---------- Catálogos ----------
CREATE TABLE especialidad (
    especialidad_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(60) NOT NULL UNIQUE
);
 
CREATE TABLE tipo_medico (
    tipo_medico_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre         VARCHAR(30) NOT NULL UNIQUE      -- Titular, Interino, Sustituto
);
 
CREATE TABLE tipo_empleado (
    tipo_empleado_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre           VARCHAR(40) NOT NULL UNIQUE    -- ATS, Auxiliar de enfermería, Celador, Administrativo
);
 
-- ---------- Personas ----------
CREATE TABLE medico (
    medico_id       INT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(50) NOT NULL,
    apellido        VARCHAR(50) NOT NULL,
    edad            TINYINT UNSIGNED NOT NULL,
    experiencia     TINYINT UNSIGNED NOT NULL,      -- años de experiencia
    especialidad_id INT NOT NULL,
    tipo_medico_id  INT NOT NULL,
    CONSTRAINT fk_medico_especialidad FOREIGN KEY (especialidad_id)
        REFERENCES especialidad (especialidad_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_medico_tipo FOREIGN KEY (tipo_medico_id)
        REFERENCES tipo_medico (tipo_medico_id) ON UPDATE CASCADE ON DELETE RESTRICT
);
 
CREATE TABLE empleado (
    empleado_id      INT AUTO_INCREMENT PRIMARY KEY,
    tipo_empleado_id INT NOT NULL,
    nombre           VARCHAR(50) NOT NULL,
    apellido         VARCHAR(50) NOT NULL,
    edad             TINYINT UNSIGNED NOT NULL,
    experiencia      TINYINT UNSIGNED NOT NULL,
    CONSTRAINT fk_empleado_tipo FOREIGN KEY (tipo_empleado_id)
        REFERENCES tipo_empleado (tipo_empleado_id) ON UPDATE CASCADE ON DELETE RESTRICT
);
 
CREATE TABLE paciente (
    paciente_id         INT AUTO_INCREMENT PRIMARY KEY,
    nombre              VARCHAR(50) NOT NULL,
    apellido            VARCHAR(50) NOT NULL,
    edad                TINYINT UNSIGNED NOT NULL,
    fecha_ingreso       DATE NOT NULL,
    medico_asignado_id  INT NULL,                   -- médico asignado al paciente
    CONSTRAINT fk_paciente_medico FOREIGN KEY (medico_asignado_id)
        REFERENCES medico (medico_id) ON UPDATE CASCADE ON DELETE SET NULL
);
 
-- ---------- Horarios de consulta (uno por médico y día) ----------
CREATE TABLE horario_consulta (
    horario_id  INT AUTO_INCREMENT PRIMARY KEY,
    medico_id   INT NOT NULL,
    dia_semana  ENUM('Lunes','Martes','Miércoles','Jueves','Viernes','Sábado') NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin    TIME NOT NULL,
    CONSTRAINT fk_horario_medico FOREIGN KEY (medico_id)
        REFERENCES medico (medico_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT chk_horario CHECK (hora_fin > hora_inicio)
);
 
-- ---------- Sustituciones ----------
-- fecha_fin NULL = sustitución todavía vigente
CREATE TABLE sustitucion (
    sustitucion_id      INT AUTO_INCREMENT PRIMARY KEY,
    medico_sustituto_id INT NOT NULL,
    medico_sustituido_id INT NOT NULL,
    fecha_inicio        DATE NOT NULL,
    fecha_fin           DATE NULL,
    CONSTRAINT fk_sust_sustituto FOREIGN KEY (medico_sustituto_id)
        REFERENCES medico (medico_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_sust_sustituido FOREIGN KEY (medico_sustituido_id)
        REFERENCES medico (medico_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_sust_medicos CHECK (medico_sustituto_id <> medico_sustituido_id),
    CONSTRAINT chk_sust_fechas CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
);
 
-- ---------- Citas ----------
CREATE TABLE cita (
    cita_id     INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    medico_id   INT NOT NULL,
    empleado_id INT NOT NULL,
    fecha_cita  DATE NOT NULL,
    hora_cita   TIME NOT NULL,
    CONSTRAINT fk_cita_paciente FOREIGN KEY (paciente_id)
        REFERENCES paciente (paciente_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_cita_medico FOREIGN KEY (medico_id)
        REFERENCES medico (medico_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_cita_empleado FOREIGN KEY (empleado_id)
        REFERENCES empleado (empleado_id) ON UPDATE CASCADE ON DELETE RESTRICT
);
 
-- ---------- Vacaciones ----------
CREATE TABLE vacaciones_empleado (
    vacaciones_empleado_id INT AUTO_INCREMENT PRIMARY KEY,
    empleado_id  INT NOT NULL,
    estado       ENUM('planificada','disfrutada') NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin    DATE NOT NULL,
    lugar        VARCHAR(80) NULL,
    dias         INT GENERATED ALWAYS AS (DATEDIFF(fecha_fin, fecha_inicio) + 1) STORED,
    CONSTRAINT fk_vacemp_empleado FOREIGN KEY (empleado_id)
        REFERENCES empleado (empleado_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT chk_vacemp_fechas CHECK (fecha_fin >= fecha_inicio)
);
 
CREATE TABLE vacaciones_medico (
    vacaciones_medico_id INT AUTO_INCREMENT PRIMARY KEY,
    medico_id    INT NOT NULL,
    estado       ENUM('planificada','disfrutada') NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin    DATE NOT NULL,
    lugar        VARCHAR(80) NULL,
    dias         INT GENERATED ALWAYS AS (DATEDIFF(fecha_fin, fecha_inicio) + 1) STORED,
    CONSTRAINT fk_vacmed_medico FOREIGN KEY (medico_id)
        REFERENCES medico (medico_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT chk_vacmed_fechas CHECK (fecha_fin >= fecha_inicio)
);