# Copy the configuration file from the current directory and paste
# it inside the container to use it as Nginx's default config.
cp ${HOME}/${DEPLOY_FOLDER_NAME}/nginx.conf /etc/nginx/nginx.conf

# setup NGINX config
mkdir -p /spool/nginx /run/pid && \
    chmod -R 777 /var/log/nginx /var/cache/nginx /etc/nginx /var/run /run /run/pid /spool/nginx && \
    chgrp -R 0 /var/log/nginx /var/cache/nginx /etc/nginx /var/run /run /run/pid /spool/nginx && \
    chmod -R g+rwX /var/log/nginx /var/cache/nginx /etc/nginx /var/run /run /run/pid /spool/nginx && \

# Copy the base uWSGI ini file to enable default dynamic uwsgi process number
cp ${HOME}/${DEPLOY_FOLDER_NAME}/uwsgi.ini /etc/uwsgi/apps-available/uwsgi.ini
ln -s /etc/uwsgi/apps-available/uwsgi.ini /etc/uwsgi/apps-enabled/uwsgi.ini

cp ${HOME}/${DEPLOY_FOLDER_NAME}/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
touch /var/log/supervisor/supervisord.log

# setup entrypoint
cp ${HOME}/${DEPLOY_FOLDER_NAME}/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# access to /dev/stdout
# https://github.com/moby/moby/issues/31243#issuecomment-406879017
ln -s /usr/local/bin/docker-entrypoint.sh / && \
    chmod 777 /usr/local/bin/docker-entrypoint.sh && \
    chgrp -R 0 /usr/local/bin/docker-entrypoint.sh && \
    chown -R nginx:root /usr/local/bin/docker-entrypoint.sh

## https://docs.openshift.com/container-platform/3.3/creating_images/guidelines.html
chgrp -R 0 /var/log /var/cache /run/pid /spool/nginx /var/run /run /tmp /etc/uwsgi /etc/nginx && \
    chmod -R g+rwX /var/log /var/cache /run/pid /spool/nginx /var/run /run /tmp /etc/uwsgi /etc/nginx && \
    chown -R nginx:nginx ${HOME} && \
    chmod -R 777 ${HOME} /etc/passwd
