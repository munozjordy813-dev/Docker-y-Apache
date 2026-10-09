# Guía Completa de la Práctica: Despliegue y Automatización de Apache con Docker

Este documento contiene la memoria detallada y paso a paso de todas las tareas realizadas durante la práctica, incluyendo la instalación manual, creación de imágenes personalizadas con Dockerfile, transferencia de archivos y despliegue de servicios mediante Docker Compose.

---

## 1. Documentar los pasos seguidos
El presente fichero `Pasos-realizados.md` recopila de forma estructurada en formato Markdown cada uno de los comandos, ficheros de configuración y comprobaciones efectuados a lo largo de la práctica.
****
---

## 2. Descargar imagen del hub de Docker de Debian
Se descargó la última versión de la imagen oficial de Debian desde el registro público de Docker Hub:
<img width="661" height="476" alt="image" src="https://github.com/user-attachments/assets/d81110d4-67e2-4ebd-93cb-824af65f4aac" />

```cmd
docker pull debian:latest
```
<img width="644" height="301" alt="image" src="https://github.com/user-attachments/assets/cea52ae8-909a-471d-bbaf-59efb869db0f" />


*(Opcionalmente también se descargó la etiqueta `trixie-backports`: `docker pull debian:trixie-backports`)*

### Verificación de imágenes guardadas:
```cmd
docker images
```
<img width="640" height="328" alt="image" src="https://github.com/user-attachments/assets/307c6b4a-32b1-462a-bb7f-a463d856dcab" />


---

## 3. Arrancar contenedor con nombre y puerto (-p), interactivo (-i), con terminal (-t) en modo detached (-d)
Se inició un contenedor en segundo plano (`-d`) de forma interactiva (`-i`) con una pseudoterminal (`-t`), asignándole el nombre `jordy_munoz` y mapeando el puerto `8082` del equipo anfitrión al puerto `80` interno del contenedor:

```cmd
docker run -dit --name jordy_munoz -p 8082:80 debian
```
<img width="661" height="293" alt="image" src="https://github.com/user-attachments/assets/2245f1ba-2f21-4be2-8eaf-a593a4c496b5" />

---

## 4. Ejecutar una shell Bash en el contenedor
Se accedió a la línea de comandos interactiva de Bash dentro del contenedor recién iniciado:

```cmd
docker exec -it jordy_munoz bash
```
<img width="595" height="194" alt="image" src="https://github.com/user-attachments/assets/c1df8b74-0758-4aca-83a6-2a313213cbed" />

---

## 5. Instalar el paquete de Apache2 y elinks dentro del contenedor
Una vez en la terminal interactiva del contenedor (`root@07d9b9e5cea7:/#`), se actualizaron las listas de repositorios e instalaron el servidor web Apache2 y el navegador para consola `elinks`:

```bash
apt update && apt install -y apache2 elinks
```
<img width="674" height="202" alt="image" src="https://github.com/user-attachments/assets/6d382aca-d025-4798-91c4-3caef6ba7413" />

---

## 6. Arrancar servicio Apache
Se inició el servicio del servidor web Apache2 dentro del contenedor y se comprobó que el servicio estuviera corriendo:

```bash
service apache2 start
service apache2 status
```
<img width="397" height="158" alt="image" src="https://github.com/user-attachments/assets/fed13e08-edae-4afb-8c2d-bc8f627e2b7a" />

---

## 7. Comprobar desde navegador que el servidor web responde
Se confirmó que el servidor web responde correctamente abriendo el navegador web en el sistema anfitrión e ingresando a:

* **URL de acceso:** `http://localhost:8082`
* **Resultado:** Se muestra la página oficial por defecto de bienvenida: *"Apache2 Debian Default Page - It works!"*.
<img width="736" height="955" alt="image" src="https://github.com/user-attachments/assets/1a69398c-530b-45ea-9ef3-2e79f9d958c1" />

---

## 8. Crear una página nueva HTML en `/var/www/html` llamada `tu_nombre.html`
Dentro de la consola del contenedor, se navegó hacia el directorio raíz de publicaciones web y se generó un documento HTML con el nombre del usuario:

```bash
cd /var/www/html
echo "<h1>Pagina de Jordy Munoz</h1>" > jordy_munoz.html
```
<img width="704" height="167" alt="image" src="https://github.com/user-attachments/assets/55dae4f7-ce6c-4eec-9463-82cf080fff73" />

---

## 9. Acceder desde navegador
Se verificó el acceso y correcto renderizado del documento HTML recién creado ingresando a la URL:

* **URL:** `http://localhost:8082/jordy_munoz.html`
<img width="307" height="116" alt="image" src="https://github.com/user-attachments/assets/13c078ce-d129-45c0-9704-6dc778d51a5c" />

---

## 10. Acceder desde el navegador de línea de comandos `elinks`
Desde la misma consola interactiva dentro del contenedor, se comprobó la lectura de la página web utilizando el navegador en consola:

```bash
elinks http://localhost/jordy_munoz.html
```

---

## 11. Hacer fichero llamado `Dockerfile` que automatice los pasos anteriores
En la carpeta local de trabajo del sistema host (`C:\Users\2asirb\practica-docker-AW`), se redactó el archivo `Dockerfile` para empaquetar de forma automática la instalación de Apache y la creación del sitio web:

```dockerfile
FROM debian:latest

RUN apt-get update && apt-get install -y \
    apache2 \
    elinks \
    && rm -rf /var/lib/apt/lists/*

RUN echo "<h1>Pagina de Jordy Munoz</h1>" > /var/www/html/jordy_munoz.html

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]
`<img width="676" height="325" alt="image" src="https://github.com/user-attachments/assets/49e5ed2b-2c74-4f9d-84b7-0fca53b32969" />
``
<img width="868" height="366" alt="image" src="https://github.com/user-attachments/assets/2c3d146f-c8a0-4407-9086-3031ef92db40" />

---

## 12. Crear la imagen a partir del Dockerfile
Se compiló la imagen personalizada asignándole la etiqueta `mi_apache_jordy`:

```cmd
docker build -t mi_apache_jordy .
```
<img width="676" height="325" alt="image" src="https://github.com/user-attachments/assets/0c657f5b-dc97-4887-8748-ebc36529675c" />
<img width="868" height="366" alt="image" src="https://github.com/user-attachments/assets/c109ff85-9aa0-4ce5-9f3b-38b365774a2b" />

---

## 13. Ejecutar el contenedor
Se puso en marcha un contenedor basado en la nueva imagen compilada, asignándole el puerto `8083`:

```cmd
docker run -d -p 8083:80 --name contenedor_automatizado mi_apache_jordy
```
<img width="1694" height="281" alt="image" src="https://github.com/user-attachments/assets/4f338f62-6536-4bcc-b4d5-3eb2ad0fa488" />

### Verificación desde el navegador y consola:
* **URL:** `http://localhost:8083/jordy_munoz.html`
* **Prueba con elinks:** `docker exec -it contenedor_automatizado elinks http://localhost/jordy_munoz.html`

---

## 14. Comando que copia un archivo local a un contenedor
Se comprobó la transferencia directa de archivos entre la máquina Windows y el contenedor activo con la sintaxis de `docker cp`:

1. **Creación del archivo local de prueba:**
   ```cmd
   echo "<h1>Prueba de copia a Docker</h1>" > mi_pagina.html
   ```

2. **Copia del archivo hacia el directorio web del contenedor:**
   ```cmd
   docker cp mi_pagina.html contenedor_automatizado:/var/www/html/
   ```

3. **Verificación en el navegador:**
   * **URL:** `http://localhost:8083/mi_pagina.html`

---

## 15. Crear fichero `docker-compose.yml` con mapeo de volumen local
Se configuró el archivo `docker-compose.yml` para desplegar el servicio mapeando directamente el directorio actual de la máquina host con la carpeta raíz web de Apache (`/var/www/html`):

### Fichero `docker-compose.yml`:
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
Se ingresó desde el navegador para confirmar que la aplicación sirve el archivo local vinculado:
* **URL:** `http://localhost:8084/jordy_munoz.html`
