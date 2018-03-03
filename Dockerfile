# StrIKE for Docker
# Strongswan VPN on Alpine Linux with configuration for native VPN connectivity on popular platforms

FROM alpine

# The StrIKE repo URL
ENV STRIKE_REPO https://github.com/stuhol/StrIKE-Docker/archive/master.zip
ENV PKI_ROOT /tmp/pki/

RUN     echo "Installing required packages to download StrIKE" && \
        apk --update add ca-certificates \
            wget && \
        echo "Downloading and extracting StrIKE" && \
        cd /tmp && \
        wget -O strike.zip $STRIKE_REPO && \
        unzip strike.zip && \
        echo "Configuring, compiling, and installing Strongswan" && \
        cd /tmp/StrIKE-Docker-master/build && \
        sh ./build-strongswan.sh && \
        echo "Generating PKI" && \
        cd /tmp/StrIKE-Docker-master/pki && \
        sh ./gen-pki.sh

VOLUME /tmp/pki

CMD	ipsec start --nofork
	
EXPOSE  500/udp \
        4500/udp 

# How to run StrIKE
# cd StrIKE
# docker build -t strike .
# docker run --name strike -p 500:500 -p 4500:4500 --cap-add NET_ADMIN strike
# docker cp strike:tmp/pki/clients/client.p12 .
