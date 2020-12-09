#
# To build this docker container run this in the root directory of repo:
#
# docker build --build-arg HELLO_STRING=$HELLO_STRING --tag hello_docker:latest .
#
# To run the docker container:
#
# docker run --rm -p 80:80 -it --name hello_docker hello_docker:latest
#

FROM nginx:alpine

ARG HELLO_STRING="not-set-in-secrects-manager"
ENV HELLO_STRING=${HELLO_STRING}

ARG NGINX_PORT=8000
ENV NGINX_PORT=${NGINX_PORT}

RUN echo "This is the hello string: $HELLO_STRING."

COPY . /usr/share/nginx/html

# copy script that just calls printenv
COPY ./00-printenv.sh /docker-entrypoint.d/

# copy config template (to use env variables)
COPY ./default.conf.template /etc/nginx/templates/

# Replace {{HELLO_STRING}} in html file with the value stored in env variable $HELLO_STRING
RUN sed -i 's/{{HELLO_STRING}}/'"$HELLO_STRING"'/g' /usr/share/nginx/html/index.html
