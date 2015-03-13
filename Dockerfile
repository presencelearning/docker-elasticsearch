FROM fgaudin/base:3
MAINTAINER Francois Gaudin <francois@presencelearning.com>

RUN groupadd elasticsearch -g 109200 && useradd elasticsearch -u 109200 -d /opt/elasticsearch -s /usr/sbin/nologin -g 109200

RUN \
  apt-get -y install software-properties-common && \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y balance oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer && \
  wget -O elasticsearch.tar.gz https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.3.tar.gz && \
  mkdir -p /opt/elasticsearch && tar xzf elasticsearch.tar.gz -C /opt/elasticsearch --strip-components=1 && \
  rm elasticsearch.tar.gz && mkdir /opt/elasticsearch/data && chown -R elasticsearch /opt/elasticsearch

COPY logging.yml /opt/elasticsearch/config/
COPY consul_template/conf.d /opt/consul_template/conf.d
COPY consul_template/templates /opt/consul_template/templates
COPY supervisord.conf /etc/supervisor/conf.d/elasticsearch.conf

USER elasticsearch

ENV PATH /opt/elasticsearch/bin:$PATH
VOLUME /opt/elasticsearch/data

USER root

EXPOSE 9200 9300
