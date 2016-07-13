FROM redmine:3.2.3-passenger
RUN apt-get update && \
    apt-get install -y wget && \
    wget https://github.com/Yelp/dumb-init/releases/download/v1.1.1/dumb-init_1.1.1_amd64.deb && \
    dpkg -i dumb-init_1.1.1_amd64.deb && \
    rm dumb-init_1.1.1_amd64.deb && \
    rm -rf /var/lib/apt/lists/*
ENV TERM=xterm
ENTRYPOINT ["/usr/bin/dumb-init"]
CMD ["sh"]
