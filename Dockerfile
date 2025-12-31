FROM alpine:3.22

ARG UID=10101
ARG GID=10101

RUN addgroup --gid ${GID} docker-tor; \
	adduser -u ${UID} -G docker-tor -h /var/lib/tor -s /sbin/nologin -D docker-tor

RUN apk add --no-cache \
		tor \
		nyx \
		lyrebird \
		snowflake \
		curl \
		gosu \
	&& rm -rf /var/cache/apk/*

RUN chown -R ${UID}:${GID} /var/lib/tor /var/log/tor /etc/tor \
	&& chmod -R 700 /var/lib/tor /var/log/tor /etc/tor

COPY --chown=${UID}:${GID} torrc.template /etc/tor/torrc
COPY --chown=${UID}:${GID} nyxrc.template /etc/tor/nyxrc
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY healthcheck.sh /usr/local/bin/healthcheck.sh

RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/healthcheck.sh

EXPOSE 9050

VOLUME /etc/tor
VOLUME /var/lib/tor
VOLUME /var/log/tor

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
	CMD /usr/local/bin/healthcheck.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["tor","-f","/etc/tor/torrc"]
