FROM node:18
RUN mkdir -p /hello-world
WORKDIR /hello-world
COPY ./package*.json ./
RUN npm install -g npm@latest
COPY . ./
EXPOSE 3000
CMD "npm" "start"

