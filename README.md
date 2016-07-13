# redmine.docker

Docker Hub Repository: https://hub.docker.com/r/suzukishunsuke/redmine/

* FROM redmine:3.2.3-passenger
* dumb-init 1.1.1
* ENTRYPOINT: /usr/bin/dumb-init
* CMD sh
* ENV
  * TERM=xterm

```
$ docker run -d -p 3000:80 --name redmine --link mysql:mysql suzukishunsuke/redmine
```
