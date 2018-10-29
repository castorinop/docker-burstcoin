FROM java:8

# zip version
ENV VERSION "2.2.4"
RUN wget https://github.com/PoC-Consortium/burstcoin/releases/download/${VERSION}/burstcoin-${VERSION}.zip \
	&& unzip -a burstcoin-${VERSION}.zip -d  /usr/src/burstcoin \
	&& rm -f burstcoin-${VERSION}.zip

#RUN git clone https://github.com/PoC-Consortium/burstcoin -b ${VERSION} --depth 1 	
#RUN cd burstcoin && yes | ./burst.sh compile


#FROM java:8
 
#RUN mkdir /usr/src/burstcoin
#COPY --from=builder /burstcoin /usr/src/burstcoin
WORKDIR /usr/src/burstcoin

VOLUME /usr/src/burstcoin/conf /usr/src/burstcoin/burst_db

EXPOSE 8125 8123


COPY conf/*properties /usr/src/burstcoin/conf/
COPY run.sh /usr/src/burstcoin/
RUN chmod +x burst.sh run.sh
CMD ./run.sh
