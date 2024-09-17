FROM ubuntu:24.04

ENV TZ=Europe/Kiev DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C

RUN apt-get update && apt-get install -y curl libnss3-tools software-properties-common sudo wget && apt-get clean

COPY php-modules.sh /
RUN /php-modules.sh

COPY composer.sh /
RUN /composer.sh

COPY symfony-cli.sh /
RUN /symfony-cli.sh

ARG DOCKER_GROUP_ID

RUN groupadd -f -g $DOCKER_GROUP_ID docker

COPY docker.sh /
RUN /docker.sh

ARG USERID
ARG USERNAME

RUN adduser --uid $USERID --disabled-password --gecos "" $USERNAME
RUN adduser $USERNAME docker

RUN groupadd -f adm && echo '%adm ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/adm
RUN adduser $USERNAME adm

USER $USERNAME

WORKDIR /home/$USERNAME

COPY boot.sh /

ENTRYPOINT ["/boot.sh"]
