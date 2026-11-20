
FROM ghcr.io/home-assistant/aarch64-base:3.21

RUN apk add --no-cache gpsd gpsd-clients

COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 2947/tcp

CMD ["/run.sh"]
