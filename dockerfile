# Gunakan image Nginx sebagai base
FROM nginx:latest

# Copy file website ke dalam folder default Nginx
COPY dist/ /usr/share/nginx/html

# Expose port 80 agar bisa diakses
EXPOSE 80

# Jalankan Nginx di foreground mode
CMD ["nginx", "-g", "daemon off;"]
