# Base image
FROM php:8.0-apache

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    git \
    zip \
    unzip \
    libzip-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libonig-dev

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# Set the working directory
WORKDIR /var/www/html/docker-test

# Copy the Laravel files to the container
COPY . /var/www/html/docker-test

# Copy the Laravel configuration file
COPY docker-test/.env.example docker-test/.env

# Generate the application key and clear configuration cache
RUN php /var/www/html/docker-test/artisan key:generate
RUN php /var/www/html/docker-test/artisan config:cache

# Start the application
CMD ["php", "/var/www/html/docker-test/artisan", "serve", "--host=0.0.0.0", "--port=8000"]
