FROM alpine:3.4

RUN mkdir -p /base/shared

RUN mkdir -p /base/local

WORKDIR /base

RUN echo "Hello World" > shared/shared-hello.txt

RUN echo "Hello World" > local/local-hello.txt

VOLUME /base/shared

COPY entrypoint.sh /entrypoint.sh

RUN chmod 700 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
