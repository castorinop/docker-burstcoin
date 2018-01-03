FROM java:8

RUN wget https://github.com/PoC-Consortium/burstcoin/releases/download/1.3.6cg/burstcoin-1.3.6cg.zip
RUN unzip -a burstcoin-1.3.6cg.zip -d /usr/src/burstcoin
WORKDIR /usr/src/burstcoin

VOLUME /usr/src/burstcoin/conf /usr/src/burstcoin/burst_db

EXPOSE 8125 8123


COPY conf/*properties /usr/src/burstcoin/conf/
COPY run.sh /usr/src/burstcoin/
RUN chmod +x burst.sh run.sh
CMD ./run.sh
