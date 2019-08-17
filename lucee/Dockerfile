# Build Extension from Source
FROM kmindi/openjdk-ant-docker as redis-extension-builder

RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/markussackmann/extension-redis-single.git \
  && cd extension-redis-single \
  && ant modern \
  && cp /extension-redis-single/dist/modern/extension-redissingle*.lex \
    /tmp/extension-redis-single.lex

################################################################################
FROM lucee/lucee52:latest

WORKDIR /

RUN ls -al /tmp/

ENV DEPLOY_DIR=/opt/lucee/server/lucee-server/deploy


COPY warmup_extension.sh ./tmp/

RUN chmod a+x ./tmp/warmup_*.sh


COPY --from=redis-extension-builder /tmp/extension-redis-single.lex "${DEPLOY_DIR}/"
RUN echo "~=%# install redis extension #%=~" \
 && ./tmp/warmup_extension.sh server '43AC6017-4EF7-4F14-89AB253C347E6A8F'
 
EXPOSE 8888