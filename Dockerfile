

FROM  ortussolutions/commandbox:latest as backend
WORKDIR $APP_DIR
COPY backend/box.json ./
COPY backend/server.json ./
RUN box install \
    && cp /app/lib/sqlite-jdbc/sqlite-jdbc-3.44.0.0.jar ${COMMANDBOX_HOME}/lib \
    && box server start saveSettings=false dryrun=true startScript=bash profile=development --console \
    && mv ./server-start.sh /usr/local/bin/startup.sh \
    &&  chmod +x /usr/local/bin/startup.sh

EXPOSE 8080
CMD /usr/local/bin/startup.sh

FROM mcr.microsoft.com/devcontainers/javascript-node:20 as ui
WORKDIR /app
COPY ui/package.json /app/package.json
COPY ui/package-lock.json /app/package-lock.json
RUN npm install

EXPOSE 8081

CMD ["npm", "run", "dev"]