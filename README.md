# ProcessMaker Community Edition

**ProcessMaker-CE** the latest version, docker image based on **Nginx**, **PHP-FPM**

---

## Building

For building this image, run this command:

```bash
docker build --build-arg http_proxy={YOUR PROXY SERVER} --build-arg https_proxy={YOUR PROXY SERVER} -t {IMAGE NAME} .
```

---

## Usage

You can run this image using `docker run` command:

```bash
docker run --rm -it -p 8081:80 emaco/processmaker
```

Or you can run by `docker-compose`:

```yml
version: "3.5"
services:
  database:
    image: mysql:5.6
    command: --default-authentication-plugin=mysql_native_password --lower_case_table_names=1 --character-set-server=utf8 --collation-server=utf8_general_ci
    volumes:
      - database:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: root
    restart: always
  processmaker:
    image: emaco/processmaker:3.5.7
    ports:
      - 8081:80
    volumes:
      - processmaker:/srv/processmaker/shared/sites/workflow
    restart: always
    depends_on:
      - database
volumes:
  database:
  processmaker:
```

---

## References

https://github.com/ckoliber/processmaker3

https://github.com/jaelsonrc/docker-processmaker-3.5.4
