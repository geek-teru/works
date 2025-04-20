# ベースイメージとして軽量のUbuntuを使用
FROM node:20-bullseye

WORKDIR /app

RUN npm install -g @stoplight/prism-cli


CMD ["prism", "mock", "openapi.yaml"]