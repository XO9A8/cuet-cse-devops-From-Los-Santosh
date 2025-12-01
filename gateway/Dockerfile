# filepath: d:\Colab\cuet\cuet-cse-devops-From-Los-Santosh\gateway\Dockerfile
FROM node:22-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .
EXPOSE 5921
CMD ["npm", "start"]