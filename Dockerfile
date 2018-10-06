FROM wallabag/wallabag:2.3.4

COPY app/app.php /var/www/wallabag/web/app.php
COPY entry.html.twig /var/www/wallabag/src/Wallabag/CoreBundle/Resources/views/themes/material/Entry/entry.html.twig
COPY site-configs/* /var/www/wallabag/vendor/j0k3r/graby-site-config/

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
CMD ["wallabag"]
