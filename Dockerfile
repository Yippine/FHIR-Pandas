# FHIR-Pandas - A FHIR client UI for MediCore
# Upstream: https://github.com/cylab-tw/FHIR-Pandas (forked to Yippine/FHIR-Pandas)
# This is a pure AngularJS application without build steps
FROM nginx:alpine

# Set working directory
WORKDIR /usr/share/nginx/html

# Copy all application files (excluding .git, node_modules, etc. via .dockerignore)
COPY . .

# Copy Nginx configuration for CORS and reverse proxy
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
