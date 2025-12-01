# filepath: d:\Colab\cuet\cuet-cse-devops-From-Los-Santosh\gateway\Dockerfile
# Build Stage
FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Production Stage
FROM node:22-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY --from=builder /app/src ./src
EXPOSE 5921
CMD ["npm", "start"]