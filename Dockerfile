FROM alpine:3.4

MAINTAINER com.tihon <com.tihon@mail.ru>

RUN apk update && \
 apk add --no-cache git grep build-base wget openssl perl && \
 apk add --no-cache erlang \
 erlang-tools \
 erlang-runtime-tools \
 erlang-sasl \
 erlang-crypto \
 erlang-ssl \
 erlang-public-key \
 erlang-asn1 \
 erlang-inets \
 erlang-syntax-tools \
 erlang-mnesia \
 erlang-dev \
 erlang-parsetools \
 erlang-eunit \
 erlang-snmp \
 erlang-hipe

EXPOSE 8080
WORKDIR /opt/app

COPY . .
RUN make
CMD ["/opt/app/_rel/seausers_release/bin/seausers_release", "foreground"]