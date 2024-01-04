FROM node:18-alpine AS builder
WORKDIR /code/

# The NPM Packages
COPY package.json package-lock.json /code/
RUN npm install --production

# The actual code
COPY public/ public/
COPY src/ src/
COPY tsconfig.json tsconfig.json
RUN npm run build

# Serving with nginx
FROM nginx:1.25.3
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /code/build /usr/share/nginx/html
RUN chown 1011:1011 -R /usr/share/nginx/html/
RUN chmod a+r -R /usr/share/nginx/html/
RUN chown 1011:1011 -R /var/cache/nginx
RUN chown 1011:1011 -R /etc/nginx