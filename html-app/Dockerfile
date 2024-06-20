# Use an NGINX base image
FROM nginx:alpine

# Copy the HTML file to the NGINX web root
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
