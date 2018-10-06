FROM wallabag/wallabag:2.3.3

COPY app/app.php /var/www/wallabag/web/app.php
COPY site-configs/* /var/www/wallabag/vendor/j0k3r/graby-site-config/

COPY _card_no_preview.html.twig /var/www/wallabag/src/Wallabag/CoreBundle/Resources/views/themes/material/Entry/_card_no_preview.html.twig
COPY entry.html.twig /var/www/wallabag/src/Wallabag/CoreBundle/Resources/views/themes/material/Entry/entry.html.twig
RUN set -ex \
 && cd /var/www/wallabag \
 && SYMFONY_ENV=prod composer install --no-dev -o --prefer-dist \
 && chown -R nobody:nobody /var/www/wallabag

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
CMD ["wallabag"]
