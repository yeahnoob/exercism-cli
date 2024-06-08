FROM alpine:latest as builder

ENV EXERCISM_CLI_VERSION 3.4.0

WORKDIR /tmp

RUN apk add --no-cache ca-certificates

# https://github.com/exercism/cli/releases/download/v3.4.0/exercism-3.4.0-linux-x86_64.tar.gz
RUN wget "https://github.com/exercism/cli/releases/download/v$EXERCISM_CLI_VERSION/exercism-$EXERCISM_CLI_VERSION-linux-x86_64.tar.gz"
RUN mv exercism-$EXERCISM_CLI_VERSION-linux-x86_64.tar.gz exercism-linux-64bit.tar.gz

RUN tar -xf exercism-linux-64bit.tar.gz


FROM alpine:latest

RUN addgroup -g 1000 -S exercism && \
    adduser -u 1000 -S exercism -G exercism

RUN mkdir -p /home/exercism/.config/exercism

# Copy bin from builder
COPY --from=builder /tmp/exercism /bin/exercism

# Copy ca-certificates
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

USER exercism
WORKDIR /Exercism

ENTRYPOINT ["/bin/exercism"]

