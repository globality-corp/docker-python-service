#!/bin/bash -e

# Container entrypoint to simplify running the production and dev servers.

if [ "$1" = "uwsgi" ]; then
    exec uwsgi --shared-socket :80 --http-socket =0 \
               --uid nobody --gid nogroup \
               --master --processes ${UWSGI_NUM_PROCESSES:-4} \
               --need-app --module ${NAME}.wsgi:app
elif [ "$1" = "dev" ]; then
    exec python manage.py runserver --host 0.0.0.0 --port 80
else
    exec $@
fi
