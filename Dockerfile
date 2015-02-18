FROM dockerfile/java:oracle-java8
MAINTAINER Francois Gaudin <francois@presencelearning.com>

RUN groupadd elasticsearch -g 109200 && useradd elasticsearch -u 109200 -d /opt/elasticsearch -s /usr/sbin/nologin -g 109200

RUN wget -O elasticsearch.tar.gz https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.3.tar.gz \
  && mkdir -p /opt/elasticsearch && tar xzf elasticsearch.tar.gz -C /opt/elasticsearch --strip-components=1 \
  && rm elasticsearch.tar.gz && chown -R elasticsearch /opt/elasticsearch

USER elasticsearch

ENV PATH /opt/elasticsearch/bin:$PATH
COPY config /opt/elasticsearch/config

VOLUME /otp/elasticsearch/data

EXPOSE 9200 9300

CMD ["/opt/elasticsearch/bin/elasticsearch"]
