FROM php:8.3.11-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    zip unzip git curl libzip-dev libonig-dev libxml2-dev libicu-dev \
    && docker-php-ext-install pdo_mysql zip intl

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Add this after installing dependencies and enabling mod_rewrite
COPY apache.conf /etc/apache2/sites-available/000-default.conf


# Set working directory
WORKDIR /var/www/html

# Copy code
COPY . .

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install

# Permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Set Laravel environment
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# Set the entrypoint
CMD ["apache2-foreground"]
