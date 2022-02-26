FROM jenkins/jenkins
 
USER root

ENV JENKINS_USER admin
ENV JENKINS_PASS admin

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml

RUN git clone https://github.com/Canderson8495/jenkins_home_backup.git && rm -rf /var/jenkins_home/* && cp -rf /jenkins_home_backup/* /var/jenkins_home/


RUN apt-get update \
      && apt-get install -y sudo --force-yes \
      && rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /tmp
RUN curl -fsSL https://get.docker.com | sh

RUN sudo curl -L --fail https://github.com/docker/compose/releases/download/1.29.2/run.sh -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose



COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt


COPY casc.yaml /var/jenkins_home/casc.yaml
COPY --chown=jenkins:jenkins init.groovy.d/ /var/jenkins_home/init.groovy.d/
