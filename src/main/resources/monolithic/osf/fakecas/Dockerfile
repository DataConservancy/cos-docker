FROM alpine:3.4

MAINTAINER Data Conservancy <dc-ird@googlegroups.com>
LABEL description = "Provides a runnning instance of fakecas on port 8080"

ARG FAKECAS_VERSION
ARG FAKECAS_ARCH

ENV FAKECAS_VERSION=${FAKECAS_VERSION:-0.8.0} \
    FAKECAS_ARCH=${FAKECAS_ARCH:-linux-386}

ENV FAKECAS_URL=https://github.com/CenterForOpenScience/fakecas/releases/download/${FAKECAS_VERSION}/fakecas-${FAKECAS_ARCH}

RUN \

  mkdir -p /opt/fakecas && \
    cd /opt/fakecas && \

  # Install curl
  apk --no-cache update && \
    apk --no-cache add \
      curl && \

  # Download the release to the current directory, and name it 'fakecas'
  echo "Downloading fakecas from ${FAKECAS_URL}" && \
  curl -SL -o fakecas ${FAKECAS_URL} && \
  chmod 700 ./fakecas && \

  # Cleanup
  apk --no-cache del curl

WORKDIR /opt/fakecas

ENTRYPOINT [ "./fakecas" ]

CMD [ "-dbaddress", "tokumx:27017", "-host", "0.0.0.0:8080" ]
