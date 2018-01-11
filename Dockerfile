FROM rightscale/ops_ruby23x_build
WORKDIR /srv

EXPOSE 8080

ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["web"]

ENV APP_NAME=policies_mailer \
    HOME=/srv \
    RACK_ENV=production

# Install dependencies first in order to make use of layer caching
# (see the mtime tweak in bin/docker.sh)
#
# Piggyback a little debug-enabling helper onto the install since this is our only RUN line.
COPY Gemfile* $HOME/
RUN bundle install && touch .byebug_hist .ruby-uuid && chown www-data.www-data .byebug_hist .ruby-uuid

# Order source dirs by increasing probability of change
# to promote use of layer cache during image builds.
COPY .cmd config.ru Rakefile $HOME/
COPY config $HOME/config
COPY design $HOME/design
COPY app $HOME/app

# This enables us to set the git commit reference SHA in the docker image
ARG gitref=unknown
LABEL git.ref=${gitref}
