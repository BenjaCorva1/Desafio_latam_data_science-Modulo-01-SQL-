-- Crear tabla Usuarios
CREATE TABLE Usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255),
    edad INTEGER
);

-- Crear tabla Preguntas
CREATE TABLE Preguntas (
    id SERIAL PRIMARY KEY,
    pregunta VARCHAR(255),
    respuesta_correcta VARCHAR(255)
);

-- Crear tabla Respuestas
CREATE TABLE Respuestas (
    id SERIAL PRIMARY KEY,
    respuesta VARCHAR(255),
    usuario_id INTEGER,
    pregunta_id INTEGER,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id),
    FOREIGN KEY (pregunta_id) REFERENCES Preguntas(id)
);

-- Agregar 5 usuarios
INSERT INTO Usuarios (nombre, edad) VALUES
('Usuario 1', 10),
('Usuario 2', 20),
('Usuario 3', 30),
('Usuario 4', 40),
('Usuario 5', 50);

-- Agregar 5 preguntas
INSERT INTO Preguntas (pregunta, respuesta_correcta) VALUES
('Pregunta 1', 'Respuesta 1'),
('Pregunta 2', 'Respuesta 2'),
('Pregunta 3', 'Respuesta 3'),
('Pregunta 4', 'Respuesta 4'),
('Pregunta 5', 'Respuesta 5');

-- La primera pregunta está respondida correctamente dos veces por dos usuarios diferentes
INSERT INTO Respuestas (respuesta, usuario_id, pregunta_id) VALUES
('Respuesta 1', 1, 1),
('Respuesta 1', 2, 1);

-- La segunda pregunta está contestada correctamente solo por un usuario
INSERT INTO Respuestas (respuesta, usuario_id, pregunta_id) VALUES
('Respuesta 2', 2, 2);

-- Las otras tres preguntas tienen respuestas incorrectas
INSERT INTO Respuestas (respuesta, usuario_id, pregunta_id) VALUES
('Incorrecta 1', 3, 3),       -- Incorrecta
('Incorrecta 2', 4, 4),       -- Incorrecta
('Incorrecta 3', 5, 5);       -- Incorrecta

-- Respuesta 6:
SELECT
	u.nombre AS usuario,
    COUNT(r.respuesta = p.respuesta_correcta OR NULL) AS respuestas_correctas
FROM Usuarios u
LEFT JOIN Respuestas r ON u.id = r.usuario_id
LEFT JOIN Preguntas p ON r.pregunta_id = p.id
GROUP BY u.id, u.nombre
ORDER BY u.id;

-- Respuesta 7:

SELECT 
    p.pregunta AS Pregunta,
    COUNT(r.id) AS Usuarios_Correctos
FROM Preguntas p
LEFT JOIN Respuestas r ON p.id = r.pregunta_id AND r.respuesta = p.respuesta_correcta
GROUP BY p.id, p.pregunta
ORDER BY p.id;

-- Respuesta 8:

-- Modificar la tabla Respuestas para agregar la restricción ON DELETE CASCADE
ALTER TABLE Respuestas
ADD CONSTRAINT fk_usuario_respuesta
FOREIGN KEY (usuario_id) REFERENCES Usuarios(id)
ON DELETE CASCADE;

-- Borrar el primer usuario (ID = 1)
DELETE FROM Usuarios WHERE id = 1;

-- Respuesta 9:

ALTER TABLE Usuarios
ADD CONSTRAINT check_edad_mayor
CHECK (edad >= 18);

-- Respuesta 10:
-- Agregar el campo "email" a la tabla Usuarios
ALTER TABLE Usuarios
ADD COLUMN email VARCHAR(255) UNIQUE;