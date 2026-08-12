FROM alpine:latest

RUN apk add --no-cache bash curl jq

COPY sendIndex.sh /sendIndex.sh

RUN chmod +x /sendIndex.sh

CMD ["/sendIndex.sh"]

