FROM elasticsearch:1.7
WORKDIR /usr/share/elasticsearch
RUN bin/plugin -i elasticsearch/elasticsearch-cloud-aws/2.7.1
COPY docker-entrypoint.sh /docker-entrypoint.sh
