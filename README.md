# Guía Completa de la Práctica: Despliegue y Automatización de Apache con Docker

Este documento contiene la memoria detallada y paso a paso de todas las tareas realizadas durante la práctica, incluyendo la instalación manual, creación de imágenes personalizadas con Dockerfile, transferencia de archivos y despliegue de servicios mediante Docker Compose.

---

## 1. Documentar los pasos seguidos
El presente fichero `Pasos-realizados.md` recopila de forma estructurada en formato Markdown cada uno de los comandos y comprobaciones efectuados a lo largo de la práctica.

---

## 2. Descargar la imagen oficial de Debian desde Docker Hub
Se descargó la última versión estable de Debian desde el registro público de Docker Hub:

```cmd
docker pull debian:latest
```

---

## 3. Arrancar el contenedor con puerto, modo interactivo, terminal y detached
Se creó e inició un contenedor en segundo plano (`-d`) interactivo (`-i`) con asignación de terminal pseudo-TTY (`-t`), asignándole el nombre `jordy_munoz` y mapeando el puerto local `8082` al puerto `80` interno del contenedor:

```cmd
docker run -dit --name jordy_munoz -p 8082:80 debian
```

---

## 4. Ejecutar una shell Bash en el contenedor
Se accedió a la consola de comandos interactiva Bash dentro del contenedor en ejecución:

```cmd
docker exec -it jordy_munoz bash
```

---

## 5. Instalar los paquetes de Apache2 y Elinks
Dentro de la shell del contenedor, se actualizaron los repositorios de paquetes e instalaron el servidor web Apache2 y el navegador en línea de comandos `elinks`:

```bash
apt update && apt install -y apache2 elinks
```

---

## 6. Arrancar el servicio Apache
Se inició el servidor web Apache dentro del contenedor y se comprobó su estado:

```bash
service apache2 start
service apache2 status
```

---

## 7. Comprobar desde el navegador que el servidor web responde
Se verificó la respuesta correcta del servidor web Apache abriendo el navegador en el equipo host:

* **URL de verificación:** `http://localhost:8082`

---

## 8. Crear una página nueva HTML personalizada
Se accedió al directorio raíz de documentos web `/var/www/html/` y se creó un archivo HTML con el nombre del usuario:

```bash
cd /var/www/html
echo "<h1>Pagina de Jordy Munoz</h1>" > jordy_munoz.html
```

---

## 9. Acceder a la página desde el navegador web
Se confirmó el acceso a la nueva página web ingresando la siguiente dirección en el navegador:

* **URL de acceso:** `http://localhost:8082/jordy_munoz.html`

---

## 10. Acceder desde el navegador de línea de comandos `elinks`
Desde dentro de la consola del contenedor, se accedió a la página mediante el navegador de texto `elinks`:

```bash
elinks http://localhost/jordy_munoz.html
```

---

## 11. Crear un fichero `Dockerfile` para automatizar los pasos anteriores
Se creó un archivo `Dockerfile` en el directorio de trabajo local que define las instrucciones para compilar una imagen con Apache2 y la página personalizada configuradas por defecto:

```dockerfile
FROM debian:latest

RUN apt-get update && apt-get install -y \
    apache2 \
    elinks \
    && rm -rf /var/lib/apt/lists/*

RUN echo "<h1>Pagina de Jordy Munoz</h1>" > /var/www/html/jordy_munoz.html

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]
```

---

## 12. Crear la imagen a partir del Dockerfile
Se construyó la nueva imagen personalizada asignándole el nombre y etiqueta `mi_apache_jordy`:

```cmd
docker build -t mi_apache_jordy .
```

---

## 13. Ejecutar el contenedor automatizado
Se inició un nuevo contenedor basado en la imagen construida, exponiéndolo en el puerto `8083` del equipo host:

```cmd
docker run -d -p 8083:80 --name contenedor_automatizado mi_apache_jordy
```

---

## 14. Comando que copia un archivo local a un contenedor
Se probó la transferencia de un archivo desde la máquina local (Windows) hacia la raíz web del contenedor mediante la herramienta `docker cp`:

1. **Creación del archivo local de prueba:**
   ```cmd
   echo "<h1>Prueba de copia a Docker</h1>" > mi_pagina.html
   ```

2. **Copia del archivo al contenedor:**
   ```cmd
   docker cp mi_pagina.html contenedor_automatizado:/var/www/html/
   ```

3. **Comprobación en el navegador:** `http://localhost:8083/mi_pagina.html`

---

## 15. Crear fichero `docker-compose.yml` con mapeo de volumen local
Se definió un archivo `docker-compose.yml` para desplegar el servicio de Apache vinculando el directorio raíz local con el directorio web del contenedor (`/var/www/html`):

### Contenido de `docker-compose.yml`:
```yaml
services:
  web:
    image: mi_apache_jordy:latest
    container_name: apache_con_volumen
    ports:
      - "8084:80"
    volumes:
      - .:/var/www/html
```

### Arranque del servicio con Docker Compose:
```cmd
docker compose up -d
```

### Comprobación final:
Se comprobó que los archivos locales se sirven en tiempo real accediendo desde el navegador a:
* **URL:** `http://localhost:8084/jordy_munoz.html`
