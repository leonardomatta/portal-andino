FROM datosgobar/portal-base:release-0.10.10
MAINTAINER Leandro Gomez<lgomez@devartis.com>

ARG PORTAL_VERSION
ENV CKAN_HOME /usr/lib/ckan/default
ENV CKAN_DIST_MEDIA /usr/lib/ckan/default/src/ckanext-gobar-theme/ckanext/gobar_theme/public/user_images
ENV CKAN_DEFAULT /etc/ckan/default

WORKDIR /portal

# portal-andino-theme
RUN $CKAN_HOME/bin/pip install -e git+https://github.com/datosgobar/portal-andino-theme.git@3f2dd5bf4a908965845eb9909f0db69237049616#egg=ckanext-gobar_theme && \
    $CKAN_HOME/bin/pip install -r $CKAN_HOME/src/ckanext-gobar-theme/requirements.txt && \
    /etc/ckan_init.d/build-combined-ckan-mo.sh $CKAN_HOME/src/ckanext-gobar-theme/ckanext/gobar_theme/i18n/es/LC_MESSAGES/ckan.po

# Series de tiempo Ar explorer
RUN $CKAN_HOME/bin/pip install -e git+https://github.com/datosgobar/ckanext-seriestiempoarexplorer.git@0.1.9#egg=ckanext-seriestiempoarexplorer

# DCAT dependencies (el plugin se instala desde el `requirements.txt` de portal-andino-theme)
RUN $CKAN_HOME/bin/pip install -r $CKAN_HOME/src/ckanext-dcat/requirements.txt

RUN mkdir -p $CKAN_DIST_MEDIA
RUN chown -R www-data:www-data $CKAN_DIST_MEDIA
RUN chmod u+rwx $CKAN_DIST_MEDIA
RUN echo "$PORTAL_VERSION" > /portal/version

RUN mkdir -p /var/lib/ckan/theme_config/templates
RUN cp $CKAN_HOME/src/ckanext-gobar-theme/ckanext/gobar_theme/templates/seccion-acerca.html /var/lib/ckan/theme_config/templates

VOLUME $CKAN_DIST_MEDIA $CKAN_DEFAULT
