FROM ubuntu:latest
MAINTAINER RedOracle

# Metadata params
ARG BUILD_DATE
ARG VERSION
ARG VCS_URL
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.version=$VERSION \
      org.label-schema.name='Kali Linux' \
      org.label-schema.description='Slucifer-kraken-bot docker image' \
      org.label-schema.usage='https://www.kali.org/news/official-kali-linux-docker-images/' \
      org.label-schema.url='https://www.kali.org/' \
      org.label-schema.vendor='RedOracle' \
      org.label-schema.schema-version='1.0' \
      org.label-schema.docker.cmd='docker run --rm redoracle/Slucifer-kraken-docker-bot' \
      org.label-schema.docker.cmd.devel='docker run --rm -ti redoracle/Slucifer-kraken-docker-bot' \
      org.label-schema.docker.debug='docker logs $CONTAINER' \
      io.github.offensive-security.docker.dockerfile="Dockerfile" \
      io.github.offensive-security.license="GPLv3" \
      MAINTAINER="RedOracle <info@redoracle.com>"
      
RUN mkdir /datak 
RUN touch /datak/kraken.key
VOLUME /datak


ENV DEBIAN_FRONTEND noninteractive
RUN set -x \
    && apt-get -yqq update \
    && apt-get -yqq dist-upgrade \
    && apt-get -yqq install python3 python3-venv wget python-pip virtualenvwrapper vim bc jq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p ~/.config  
RUN cd .config
RUN wget https://www.redoracle.com
RUN cp /datak/kraken.key ~/.config/clikraken
RUN pyvenv ~/.config/clikraken
RUN pip install clikraken
RUN pip install requests
RUN source ~/.config/clikraken/bin/activate
RUN clikraken generate_settings > ~/.config/clikraken/settings.ini


CMD ["bash"]

EXPOSE 80
