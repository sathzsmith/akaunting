#!/bin/bash
set -e

if [[ ! -d ${AKAUNTING_BUILD_DIR}/Akaunting_${AKAUNTING_VERSION}-Stable ]]; then
  echo "Downloading Akaunting ${AKAUNTING_VERSION}..."
  wget "https://github.com/akaunting/akaunting/releases/download/${AKAUNTING_VERSION}/Akaunting_${AKAUNTING_VERSION}-Stable.zip" -O ${AKAUNTING_BUILD_DIR}/Akaunting_${AKAUNTING_VERSION}-Stable.zip
  echo "Extracting Akaunting ${AKAUNTING_VERSION}..."
  mkdir -p ${AKAUNTING_INSTALL_DIR}
  cd ${AKAUNTING_INSTALL_DIR}
  unzip ${AKAUNTING_BUILD_DIR}/Akaunting_${AKAUNTING_VERSION}-Stable.zip
  rm -rf ${AKAUNTING_BUILD_DIR}/Akaunting_${AKAUNTING_VERSION}-Stable.zip
fi

echo "Extracting Akaunting ${AKAUNTING_VERSION}..."
mkdir -p ${AKAUNTING_INSTALL_DIR}
cd ${AKAUNTING_INSTALL_DIR}
shopt -s dotglob nullglob #to move even hidden files.
mv ${AKAUNTING_BUILD_DIR}/Akaunting_${AKAUNTING_VERSION}-Stable/* ./
rm -rf ${AKAUNTING_BUILD_DIR}/Akaunting_${AKAUNTING_VERSION}-Stable


mkdir -p /run/php/

# remove default nginx virtualhost
rm -rf /etc/nginx/sites-enabled/default

# set directory permissions
find ${AKAUNTING_INSTALL_DIR}/ -type f -print0 | xargs -0 chmod 0640
find ${AKAUNTING_INSTALL_DIR}/ -type d -print0 | xargs -0 chmod 0750

chown -R root:${AKAUNTING_USER} ${AKAUNTING_INSTALL_DIR}/
chown ${AKAUNTING_USER} ${AKAUNTING_INSTALL_DIR}/

chown -R ${AKAUNTING_USER}: ${AKAUNTING_INSTALL_DIR}/storage/
chown -R ${AKAUNTING_USER}: ${AKAUNTING_INSTALL_DIR}/bootstrap/cache/

chown root:${AKAUNTING_USER} ${AKAUNTING_INSTALL_DIR}/.env.example
chmod 0660 ${AKAUNTING_INSTALL_DIR}/.env.example

chown root:${AKAUNTING_USER} ${AKAUNTING_INSTALL_DIR}/.htaccess
chmod 0644 ${AKAUNTING_INSTALL_DIR}/.htaccess

touch ${AKAUNTING_INSTALL_DIR}/.user.ini
chown root:${AKAUNTING_USER} ${AKAUNTING_INSTALL_DIR}/.user.ini
chmod 0644 ${AKAUNTING_INSTALL_DIR}/.user.ini
