FROM mhart/alpine-node

RUN adduser -S fxa

COPY bin /app/bin
COPY config /app/config
COPY fxa-auth-db-server /app/fxa-auth-db-server
COPY lib /app/lib
ADD AUTHORS /app/AUTHORS
ADD CONTRIBUTING.md /app/CONTRIBUTING.md
ADD LICENSE /app/LICENSE
ADD README.md /app/README.md
ADD index.js /app/index.js
ADD package.json /app/package.json

WORKDIR /app

EXPOSE 8000

RUN ["npm", "install", "--production"]

# The current node.js environment
ENV NODE_ENV prod

# The IP address the server should bind to
ENV HOST 127.0.0.1

#  The port the server should bind to
ENV PORT 8000

ENV LOG_LEVEL info

#  The name of the row in the dbMetadata table which stores the patch level
ENV SCHEMA_PATCH_KEY schema-patch-level

#  Enables (true) or disables (false) pruning
ENV ENABLE_PRUNING false

#  Approximate time between prunes (in ms)
ENV PRUNE_EVERY 30 minutes

#  The user to connect to for MySql
ENV MYSQL_USER root

#  The password to connect to for MySql
ENV MYSQL_PASSWORD=

#  The database to connect to for MySql
ENV MYSQL_DATABASE fxa

#  The host to connect to for MySql
ENV MYSQL_HOST 127.0.0.1

#  The port to connect to for MySql
ENV MYSQL_PORT 3306

#  The maximum number of connections to create at once.
ENV MYSQL_CONNECTION_LIMIT 10

#  Determines the pools action when no connections are available and the limit has been reached.
ENV MYSQL_WAIT_FOR_CONNECTIONS true

#  Determines the maximum size of the pools waiting-for-connections queue.
ENV MYSQL_QUEUE_LIMIT 100

#  The user to connect to for MySql
ENV MYSQL_SLAVE_USER root

#  The password to connect to for MySql
ENV MYSQL_SLAVE_PASSWORD=

#  The database to connect to for MySql
ENV MYSQL_SLAVE_DATABASE fxa

#  The host to connect to for MySql
ENV MYSQL_SLAVE_HOST 127.0.0.1

#  The port to connect to for MySql
ENV MYSQL_SLAVE_PORT 3306

#  The maximum number of connections to create at once.
ENV MYSQL_SLAVE_CONNECTION_LIMIT 10

#  Determines the pools action when no connections are available and the limit has been reached.
ENV MYSQL_SLAVE_WAIT_FOR_CONNECTIONS true

#  Determines the maximum size of the pools waiting-for-connections queue.
ENV MYSQL_SLAVE_QUEUE_LIMIT 100

#  Url at which to publish account lifecycle events (empty to disable publishing).
ENV NOTIFICATIONS_PUBLISH_URL=

#  Interval to sleep between polling for unpublished events in seconds
ENV NOTIFICATIONS_POLL_INTERVAL 10

#  Secret key to use for signing JWTs a PEM-encoded file.
ENV NOTIFICATIONS_JWT_SECRET_KEY_FILE priv.pem

#  Issuer field to use for JWTs.
ENV NOTIFICATIONS_JWT_ISS localhost

#  Key-ID field to use for JWTs.
ENV NOTIFICATIONS_JWT_KID test

#  JWK url field to use for JWTs.
ENV NOTIFICATIONS_JWT_JKU localhost

CMD ["npm", "start", "--production"]
