FROM elasticsearch:1.7
WORKDIR /usr/share/elasticsearch
RUN bin/plugin -i elasticsearch/elasticsearch-cloud-aws/2.7.1
RUN bin/plugin -i mobz/elasticsearch-head

COPY docker-entrypoint.sh /docker-entrypoint.sh

VOLUME /usr/share/elasticsearch/data

EXPOSE 9200 9300
