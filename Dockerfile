FROM openjdk:8

MAINTAINER Evoniners <dev@evonove.it>

ENV ZK_VERSION 3.4.9
ENV ZK_PATH zookeeper/zookeeper-${ZK_VERSION}/zookeeper-${ZK_VERSION}.tar.gz
ENV ZK_HOME /opt/zookeeper

# download the jq package to parse the json on the command line
RUN apt-get update && apt-get install -y \
    jq \
 && rm -rf /var/lib/apt/lists/*

# download zookeeper and unpack it into /opt
# the first line parse the json and returns the preferred apache mirror
RUN APACHE_MIRROR=$(curl -s 'https://www.apache.org/dyn/closer.cgi?as_json=1' | jq --raw-output '.preferred') \
    && curl -SL ${APACHE_MIRROR}${ZK_PATH} | tar -zxC /opt/ \
    && mv /opt/zookeeper-${ZK_VERSION} ${ZK_HOME}

COPY ./zoo.cfg ${ZK_HOME}/conf/

EXPOSE 2181 2888 3888

WORKDIR ${ZK_HOME}

ENTRYPOINT ["bin/zkServer.sh"]
CMD ["start-foreground"]
