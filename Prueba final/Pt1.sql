-- Creación de la tabla Peliculas
CREATE TABLE Peliculas (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(255),
    anno INTEGER
);

-- Creación de la tabla Tags
CREATE TABLE Tags (
    id INTEGER PRIMARY KEY,
    tag VARCHAR(32)
);

-- Creación de la tabla de relación entre Peliculas y Tags
CREATE TABLE Peliculas_Tags (
    pelicula_id INTEGER,
    tag_id INTEGER,
    PRIMARY KEY (pelicula_id, tag_id),
    FOREIGN KEY (pelicula_id) REFERENCES Peliculas(id),
    FOREIGN KEY (tag_id) REFERENCES Tags(id)
);

--ejercicio 2
-- Insertar 5 películas de Studio Ghibli en español
INSERT INTO Peliculas (id, nombre, anno) VALUES
(1, 'Mi Vecino Totoro', 1988),
(2, 'El Viaje de Chihiro', 2001),
(3, 'La Princesa Mononoke', 1997),
(4, 'El Castillo Ambulante', 2004),
(5, 'Nicky, la Aprendiz de Bruja', 1989);

-- Insertar 5 tags
INSERT INTO Tags (id, tag) VALUES
(1, 'Fantasía'),
(2, 'Aventura'),
(3, 'Familiar'),
(4, 'Magia'),
(5, 'Animación');

-- Asociar tags a la primera película (Mi Vecino Totoro)
INSERT INTO Peliculas_Tags (pelicula_id, tag_id) VALUES
(1, 1),
(1, 3),
(1, 5);

-- Asociar tags a la segunda película (El Viaje de Chihiro)
INSERT INTO Peliculas_Tags (pelicula_id, tag_id) VALUES
(2, 1),
(2, 4);

-- Asociar otros tags a otras películas como ejemplo
INSERT INTO Peliculas_Tags (pelicula_id, tag_id) VALUES
(3, 2),
(3, 4),
(4, 1),
(4, 2),
(5, 3),
(5, 5);

SELECT p.nombre AS Pelicula, 
COUNT(pt.tag_id) AS Cantidad_Tags
FROM Peliculas p
LEFT JOIN Peliculas_Tags pt ON p.id = pt.pelicula_id
GROUP BY p.id, p.nombre;

