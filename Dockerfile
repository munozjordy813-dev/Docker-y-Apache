FROM debian:latest

RUN apt-get update && apt-get install -y \
    apache2 \
    elinks \
    && rm -rf /var/lib/apt/lists/*

RUN echo "<h1>Pagina de Jordy Munoz</h1>" > /var/www/html/jordy_munoz.html

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]