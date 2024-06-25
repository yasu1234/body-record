FROM node:18.15.0-bullseye

RUN apt update

WORKDIR /frontend

COPY package.json /frontend/package.json
COPY yarn.lock /frontend/yarn.lock

RUN yarn install

COPY . .

CMD /bin/bash -c "yarn dev --host"
