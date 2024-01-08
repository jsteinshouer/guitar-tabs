ARG PROFILE=development

FROM  ortussolutions/commandbox:3.8.4 as backend
WORKDIR $APP_DIR

COPY backend /app
RUN box install \
    && cp /app/lib/sqlite-jdbc/sqlite-jdbc-3.44.0.0.jar ${COMMANDBOX_HOME}/lib \
    && box server start saveSettings=false dryrun=true startScript=bash profile=${PROFILE} --console \
    && mv ./server-start.sh /usr/local/bin/startup.sh \
    &&  chmod +x /usr/local/bin/startup.sh

EXPOSE 8080
CMD /usr/local/bin/startup.sh

FROM mcr.microsoft.com/devcontainers/javascript-node:20 as ui
WORKDIR /app

# Install dependencies first to leverage Docker cache
COPY ui/package.json ui/package-lock.json ./
 
# Using cache mount for npm install, so unchanged packages aren’t downloaded every time
RUN --mount=type=cache,target=/root/.npm \
    npm install

COPY ui /app
RUN npm run build

# Production build
FROM adoptopenjdk/openjdk11:debianslim-jre as prod

COPY --from=backend /app /app
COPY --from=backend /usr/local/lib/CommandBox/server/serverHome /usr/local/lib/CommandBox/server/serverHome

RUN mkdir -p /usr/local/lib/CommandBox/lib \
    && rm -Rf /app/tests \
    && rm -Rf /app/testbox \
    && rm /app/box.json \
    && rm /app/server.json

COPY --from=backend /usr/local/lib/CommandBox/lib/runwar-4.8.5.jar /usr/local/lib/CommandBox/lib/runwar-4.8.5.jar
COPY --from=backend /usr/local/lib/CommandBox/cfml/system/config/urlrewrite.xml /usr/local/lib/CommandBox/cfml/system/config/urlrewrite.xml
COPY --from=backend /usr/local/bin/startup.sh /usr/local/bin/startup.sh

COPY --from=ui-build /app/dist/assets /app/assets
COPY --from=ui-build /app/dist/index.html /app/views/main/index.cfm
CMD /usr/local/bin/startup.sh