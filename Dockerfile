FROM debian:9

MAINTAINER 'Kavibritto Chalaman'

# Set default env variables
ENV TINI_VERSION=v0.18.0

# Working Dir
WORKDIR /root/
EXPOSE 3306

# Create persistent volumes
#VOLUME /usr/local/mariadb/columnstore/etc
#VOLUME /usr/local/mariadb/columnstore/data1
#VOLUME /usr/local/mariadb/columnstore/mysql/db
VOLUME ["/usr/local/mariadb/columnstore/etc", "/usr/local/mariadb/columnstore/data1", "/usr/local/mariadb/columnstore/mysql/db"]

# Installing Build Tools
RUN apt-get update \ 
    && apt-get -y install apt-transport-https wget expect perl openssl file sudo runit rsyslog curl nano gnupg2 procps bc \
    && apt-get -y install libdbi-perl libboost-all-dev libreadline-dev \
    && apt-get -y install rsync libsnappy1v5 net-tools libdbd-mysql-perl
#Copy Repo list
COPY config/mariab-columnstore-tools.list /etc/apt/sources.list.d/mariab-columnstore-tools.list

#Key verification
RUN wget -qO - https://downloads.mariadb.com/MariaDB/mariadb-columnstore/MariaDB-ColumnStore.gpg.key | sudo apt-key add - \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 28C12247

#Updating repo and installing mariadb column store
RUN apt-get update \
    && apt-get -y install mariadb-columnstore* maxscale maxscale-cdc-connector \
    && rm -rf /var/lib/apt/lists/*
	
#xml copy
COPY config/xml/* /usr/local/mariadb/columnstore/etc/

# Copy utility scripts
COPY scripts/columnstore-restart \
     scripts/columnstore-init \
     scripts/columnstore-bootstrap /bin/

# Make utility scripts executable
#RUN chmod +x /bin/columnstore-bootstrap \
#   /bin/columnstore-init \
#    /bin/columnstore-restart
#Creating Symlinks
# Compatiblity for 1.2.5 and below
RUN mkdir /etc/columnstore && \
    ln -s /usr/local/mariadb/columnstore/bin/postConfigure /bin/postConfigure && \
    ln -s /usr/local/mariadb/columnstore/bin/columnstore /bin/columnstore && \
    ln -s /usr/local/mariadb/columnstore/bin/mcsadmin /bin/mcsadmin && \
    ln -s /usr/local/mariadb/columnstore/mysql/bin/mysql /bin/mysql && \
    ln -s /usr/local/mariadb/columnstore/etc/Columnstore.xml /etc/columnstore/Columnstore.xml

# Add Tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

# Copy config files to image
COPY config/rsyslog.conf \
     config/monitrc \
     config/monit.d/ /etc/
	
# Set permissions for monit config
RUN chmod 0600 /etc/monitrc
# Copy entrypoint to image
COPY scripts/docker-entrypoint.sh /usr/local/bin/
# Set execute permission
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
# Startup scripts
ENTRYPOINT ["/usr/bin/tini","--","docker-entrypoint.sh"]
CMD /bin/columnstore-bootstrap && /usr/bin/monit -I
