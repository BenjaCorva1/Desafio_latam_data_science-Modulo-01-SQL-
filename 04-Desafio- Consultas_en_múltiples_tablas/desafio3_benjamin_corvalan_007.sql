
/*
1.Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo
pedido.
*/

CREATE DATABASE desafio3_benjamin_corvalan_007;

-- Creación de la tabla usuarios
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    rol VARCHAR(20) NOT NULL
);

-- insertar 5 usuarios
INSERT INTO usuarios (email, nombre, apellido, rol) VALUES ('admin@desafiolatam.com', 'Benjamin', 'Corvalan', 'administrador');
INSERT INTO usuarios (email, nombre, apellido, rol) VALUES ('supervisor1@tesla.com', 'Eladio', 'Musk', 'supervisor');
INSERT INTO usuarios (email, nombre, apellido, rol) VALUES ('supervisor2@apple.com', 'Stive', 'Work', 'supervisor');
INSERT INTO usuarios (email, nombre, apellido, rol) VALUES ('usuario3@nvidia.com', 'jerson', 'huang', 'usuario');
INSERT INTO usuarios (email, nombre, apellido, rol) VALUES ('usuario4@microsoft.com', 'bill', 'puertas', 'usuario');

-- Tabla post
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    destacado BOOLEAN NOT NULL DEFAULT FALSE,
    usuario_id BIGINT,
);

-- Inserción de 5 posts
INSERT INTO posts (titulo, contenido, fecha_actualizacion, destacado, usuario_id) VALUES ('Post 1', 'Contenido post prueba 1', CURRENT_TIMESTAMP, TRUE, 1);
INSERT INTO posts (titulo, contenido, fecha_actualizacion, destacado, usuario_id) VALUES ('Post 2', 'Contenido post prueba 2', CURRENT_TIMESTAMP, FALSE, 1);
INSERT INTO posts (titulo, contenido, fecha_actualizacion, destacado, usuario_id) VALUES ('Post 3', 'Contenido post prueba 3', CURRENT_TIMESTAMP, FALSE, 2);
INSERT INTO posts (titulo, contenido, fecha_actualizacion, destacado, usuario_id) VALUES ('Post 4', 'Contenido post prueba 4', CURRENT_TIMESTAMP, TRUE, 3);
INSERT INTO posts (titulo, contenido, fecha_actualizacion, destacado, usuario_id) VALUES ('Post 5', 'Contenido post prueba 5', CURRENT_TIMESTAMP, FALSE, NULL);

--Tabla comentarios
CREATE TABLE comentarios (
    id SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    usuario_id BIGINT,
    post_id BIGINT
);

--insertar comentarios
INSERT INTO comentarios (contenido, usuario_id, post_id) VALUES ('Comentario 1 para el post 1', 1, 1);
INSERT INTO comentarios (contenido, usuario_id, post_id) VALUES ('Comentario 2 para el post 1', 2, 1);
INSERT INTO comentarios (contenido, usuario_id, post_id) VALUES ('Comentario 3 para el post 1', 3, 1);
INSERT INTO comentarios (contenido, usuario_id, post_id) VALUES ('Comentario 4 para el post 2', 1, 2);
INSERT INTO comentarios (contenido, usuario_id, post_id) VALUES ('Comentario 5 para el post 2', 2, 2);

/*
Requerimientos:

2.Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas:
nombre y email del usuario junto al título y contenido del post.
*/

SELECT 
    usuarios.nombre,
    usuarios.email,
    posts.titulo,
    posts.contenido
FROM 
    usuarios
JOIN 
    posts ON usuarios.id = posts.usuario_id;

/*
3. Muestra el id, título y contenido de los posts de los administradores.
a. El administrador puede ser cualquier id.
*/

SELECT 
    posts.id,
    posts.titulo,
    posts.contenido
FROM 
    posts
JOIN 
    usuarios 
ON 
    posts.usuario_id = usuarios.id
WHERE 
    usuarios.rol = 'administrador';

/*
4.Cuenta la cantidad de posts de cada usuario.

a. La tabla resultante debe mostrar el id e email del usuario junto con la
cantidad de posts de cada usuario.
*/

SELECT 
    usuarios.id,
    usuarios.email,
    COUNT(posts.id) AS cantidad_posts
FROM 
    usuarios
LEFT JOIN 
    posts 
ON 
    usuarios.id = posts.usuario_id
GROUP BY 
    usuarios.id, usuarios.email;

/*
5.Muestra el email del usuario que ha creado más posts.

a. Aquí la tabla resultante tiene un único registro y muestra solo el email.
*/

SELECT
	USUARIOS.EMAIL as Mail_mayor_cantidad_post
FROM USUARIOS
	JOIN POSTS ON USUARIOS.ID = POSTS.USUARIO_ID
GROUP BY
	USUARIOS.ID,
	USUARIOS.EMAIL
ORDER BY
	COUNT(POSTS.USUARIO_ID) DESC LIMIT 1;

/*
6.Muestra la fecha del último post de cada usuario.
*/

SELECT 
    usuarios.id,
    usuarios.email,
    MAX(posts.fecha_creacion) AS fecha_ultimo_post
FROM usuarios
JOIN posts ON usuarios.id = posts.usuario_id
GROUP BY usuarios.id, usuarios.email;

/*
7.Muestra el título y contenido del post (artículo) con más comentarios.
*/
SELECT 
    posts.titulo,
    posts.contenido
FROM 
    posts
JOIN 
    comentarios 
ON 
    posts.id = comentarios.post_id
GROUP BY 
    posts.id
ORDER BY 
    COUNT(comentarios.id) DESC LIMIT 1;

/*
8.Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
de cada comentario asociado a los posts mostrados, junto con el email del usuario
que lo escribió. (En este caso traje todo para identificar los campos no llenos)
*/

SELECT 
    posts.titulo AS titulo_post,
    posts.contenido AS contenido_post,
    comentarios.contenido AS contenido_comentario,
    usuarios.email AS email_usuario
FROM 
    posts
LEFT JOIN 
    comentarios ON posts.id = comentarios.post_id
LEFT JOIN 
    usuarios ON comentarios.usuario_id = usuarios.id;

/*8. en el caso de que el ejercicio se refiera a traer solo la informacion que este insertada y relacionada (sin null)*/

SELECT 
    posts.titulo AS titulo_post,
    posts.contenido AS contenido_post,
    comentarios.contenido AS contenido_comentario,
    usuarios.email AS email_usuario
FROM posts
INNER JOIN 
    comentarios ON posts.id = comentarios.post_id
INNER JOIN 
    usuarios ON comentarios.usuario_id = usuarios.id;
/*
9. Muestra el contenido del último comentario de cada usuario
*/

SELECT 
    comentarios.usuario_id,
    usuarios.nombre,
    usuarios.email,
    comentarios.contenido AS contenido_ultimo_comentario
FROM 
    comentarios
JOIN 
    (SELECT 
         usuario_id, 
         MAX(fecha_creacion) AS ultima_fecha
     FROM 
         comentarios
     GROUP BY 
         usuario_id) subquery
ON 
    comentarios.usuario_id = subquery.usuario_id
AND 
    comentarios.fecha_creacion = subquery.ultima_fecha
JOIN 
    usuarios ON comentarios.usuario_id = usuarios.id
ORDER BY 
    comentarios.usuario_id ASC;

/*
10. Muestra los emails de los usuarios que no han escrito ningún comentario
*/

SELECT 
    usuarios.nombre,
    usuarios.email,
	count(comentarios.usuario_id) as cantidad
FROM 
    usuarios
LEFT JOIN 
    comentarios ON usuarios.id = comentarios.usuario_id
GROUP BY 
    usuarios.id, usuarios.nombre, usuarios.email
HAVING 
    COUNT(comentarios.id) = 0;