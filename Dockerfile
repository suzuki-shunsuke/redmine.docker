FROM redmine:3.3.1
ENV DUMB_INIT_VERSION=1.2.0 \
    TERM=xterm
RUN apt-get update && \
    apt-get install -y wget && \
    wget https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64.deb && \
    dpkg -i dumb-init_${DUMB_INIT_VERSION}_amd64.deb && \
    rm dumb-init_${DUMB_INIT_VERSION}_amd64.deb && \
    rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["/usr/bin/dumb-init"]
CMD ["/bin/bash"]
# CMD ["/bin/bash"]
ONBUILD COPY deb.list Gemfile /tmp/
ONBUILD RUN apt-get update plugin.list && \
    grep -v "^ *#" /tmp/deb.list | sed -e "s/ *\(.*\) *#.*/\1/" | xargs sudo apt-get install -y && \
    cd /tmp/ && \
    gosu redmine bundle install --path /usr/src/redmine/vendor/bundle && \
    cd /usr/src/redmine && \
    gosu redmine bundle exec rake db:create && \
    gosu redmine bundle exec rake db:migrate && \
    cd /usr/src/redmine/plugins && \
    grep -v "^ *#" /tmp/plugin.list | sed -e "s/ *\(.*\) *#.*/\1/" | gosu redmine xargs git clone && \
    cd /usr/src/redmine && \
    gosu redmine bundle install --without development test && \
    gosu redmine bundle exec rake redmine:plugins:migrate RAILS_ENV=production
ONBUILD USER redmine
