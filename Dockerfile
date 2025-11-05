# Imagen base de PHP con servidor Apache
FROM php:8.2-apache

# Copiamos el código fuente al directorio raíz de Apache
COPY . /var/www/html/

# Exponemos el puerto 80
EXPOSE 80
