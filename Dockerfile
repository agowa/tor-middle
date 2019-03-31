FROM alpine:edge

ENV NICKNAME='NotProvided'
ENV CONTACT_INFO='NotProvided'
ENV OR_PORT='9001'
ENV DIR_PORT='9030'
ENV SOCKS_PORT='0'
#ENV SOCKS_PORT='9050'
ENV CONTROL_PORT='0'
#ENV CONTROL_PORT='9051'
ENV BANDWIDTH_RATE='20 MBits'
ENV BANDWIDTH_BURST='40 MBits'
ENV MAX_MEM='2 GB'
ENV ACCOUNTING_MAX='0'
ENV ACCOUNTING_START='month 1 00:00'

# Note: Tor is only in testing repo -> http://pkgs.alpinelinux.org/packages?package=emacs&repo=all&arch=x86_64
RUN apk update && apk add \
	tor \
	--update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
	&& rm -rf /var/cache/apk/*

RUN \
    echo "SocksPort $SOCKS_PORT" > /etc/tor/torrc && \
    echo "DataDirectory /etc/tor/data" >> /etc/tor/torrc && \
    echo "DisableDebuggerAttachment 0" >> /etc/tor/torrc && \
    echo "ControlPort $CONTROL_PORT" >> /etc/tor/torrc && \
    echo "Nickname $NICKNAME" >> /etc/tor/torrc && \
    echo "ContactInfo $CONTACT_INFO" >> /etc/tor/torrc && \
    echo "RelayBandwidthRate $BANDWIDTH_RATE" >> /etc/tor/torrc && \
    echo "RelayBandwidthBurst $BANDWIDTH_BURST" >> /etc/tor/torrc && \
    echo "MaxMemInQueues $MAX_MEM" >> /etc/tor/torrc && \
    echo "AccountingMax $ACCOUNTING_MAX" >> /etc/tor/torrc && \
    echo "AccountingStart $ACCOUNTING_START" >> /etc/tor/torrc && \
    echo "ORPort  $OR_PORT" >> /etc/tor/torrc && \
    echo "ExitRelay 0" >> /etc/tor/torrc && \
    echo "ExitPolicy reject *:*" >> /etc/tor/torrc && \
    echo "DirPort $DIR_PORT" >> /etc/tor/torrc && \
    echo "BridgeRelay 0" >> /etc/tor/torrc

RUN \
    mkdir /etc/tor/data && \
    chown -R tor /etc/tor/data && \
    chmod og-rwx /etc/tor/data

USER tor
EXPOSE 9001
EXPOSE 9030

ENTRYPOINT [ "tor","-f","/etc/tor/torrc" ]
