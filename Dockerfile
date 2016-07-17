FROM ubuntu:15.10

RUN apt-get update
RUN apt-get -y install curl
RUN apt-get -y install mcedit
RUN apt-get -y install wget
RUN apt-get -y install nodejs
RUN apt-get -y install ssh
RUN apt-get -y install libcurl4-openssl-dev
RUN apt-get -y install git
RUN apt-get -y install cron

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable --ruby

RUN /bin/bash -l -c "source /usr/local/rvm/scripts/rvm"
RUN /bin/bash -l -c "gem install passenger"
RUN /bin/bash -l -c "passenger-install-nginx-module --auto-download --auto --prefix=/opt/nginx"
RUN /bin/bash -l -c "gem install bundler"

# nginx conf
ADD nginx.conf /opt/nginx/conf/nginx.conf

RUN wget -O init-deb.sh https://www.linode.com/docs/assets/660-init-deb.sh
RUN mv init-deb.sh /etc/init.d/nginx
RUN chmod +x /etc/init.d/nginx
RUN /usr/sbin/update-rc.d -f nginx defaults

# autorun nginx & sshd
RUN echo service nginx start >> /etc/bash.bashrc
RUN echo service ssh start >> /etc/bash.bashrc
RUN echo service cron start >> /etc/bash.bashrc

# create deploy user
RUN mkdir /www
# generate password
# password="your_password"
# pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
# echo $pass
RUN useradd -m -p pa2KgJOgdlwfU -s /bin/bash deploy
RUN chown  deploy:deploy /www/ -R

RUN echo source /usr/local/rvm/scripts/rvm >> ~/.bashrc
RUN echo source /usr/local/rvm/scripts/rvm >> /home/deploy/.bashrc

EXPOSE 80
EXPOSE 22
