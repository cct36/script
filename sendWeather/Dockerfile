FROM alpine:latest

RUN apk add --no-cache bash curl jq

COPY sendWeather.sh /sendWeather.sh

RUN chmod +x /sendWeather.sh

CMD ["/sendWeather.sh"]

