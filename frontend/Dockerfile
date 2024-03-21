FROM node:18.15.0-bullseye

ARG WORKDIR

WORKDIR /${WORKDIR}

RUN apt update \
    && yarn install

COPY . ./
COPY package.json /frontend/package.json
COPY yarn.lock /frontend/yarn.lock

CMD ["yarn", "dev", "--host"]
