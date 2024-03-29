FROM node:20
ENV NODE_ENV production
RUN yarn global add elm

RUN mkdir /app
WORKDIR /app

COPY elm.json .
COPY src src
RUN elm make src/Main.elm --optimize --output=out/app.js
RUN elm make src/Main2.elm --optimize --output=out/app2.js
COPY index.html out
COPY index2.html out
COPY canihonk.mp3 out

FROM nginx:1.15.12-alpine

COPY --from=0 /app/out /usr/share/nginx/html
