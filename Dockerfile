FROM node:lts-alpine AS builder
ENV NODE_ENV=production
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

# Bundle static assets with nginx
FROM nginx:alpine as production
ENV NODE_ENV=production
# Copy built assets from builder
COPY --from=builder /usr/src/app/build /usr/share/nginx/html
# Add your nginx.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Copy blockuseragents file
COPY blockuseragents.rules /etc/nginx/blockuseragents.rules
# Expose port
EXPOSE 80
# Start nginx
CMD ["nginx", "-g", "daemon off;"]