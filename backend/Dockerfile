# filepath: d:\Colab\cuet\cuet-cse-devops-From-Los-Santosh\backend\Dockerfile
# Build Stage
FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Production Stage
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY --from=builder /app/dist ./dist
EXPOSE 3847
CMD ["npm", "start"]