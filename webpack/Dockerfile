FROM node:4.2.2

RUN npm install -g webpack
RUN npm install webpack-dev-server -g

COPY . /mnt/webpack
WORKDIR /mnt/webpack
RUN npm install
VOLUME /mnt/webpack/dist

EXPOSE 8666
