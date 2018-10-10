FROM centos/nginx-112-centos7:latest

# This image provides a Node.JS environment you can use to run your Node.JS
# applications.

EXPOSE 8080

USER root

# This image will be initialized with "npm run $NPM_RUN"
# See https://docs.npmjs.com/misc/scripts, and your repo's package.json
# file for possible values of NPM_RUN

ENV NPM_BUILD_COMMAND=start \
    NPM_CONFIG_LOGLEVEL=info \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH \
    NODE_VERSION=4 \
    GIT_VERSION=master \
    NPM_VERSION=5.12.0 \
    YARN_VERSION=1.7.0 \
    DEBUG_PORT=5858 \
    NODE_ENV=production \
    DEV_MODE=false

LABEL io.k8s.description="Plattform for building and running static sites with NodeJS and NGINX." \
      io.k8s.display-name="build-nodejs-nginx NodeJS v$NODE_VERSION" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,nodejs,nodejs$NODE_VERSION,nginx" \
      com.redhat.dev-mode="DEV_MODE:false" \
      com.redhat.deployments-dir="${APP_ROOT}/src" \
      com.redhat.dev-mode.port="DEBUG_PORT:5858"\
      io.origin.builder-version="$GIT_VERSION" \
      name="jshmrtn/s2i-nodejs-nginx" \
      maintainer="Jeremy Zahner <zahner@joshmartin.ch>" \
      version="$NODE_VERSION"

# Download and install a binary from nodejs.org
# Add the gpg keys listed at https://github.com/nodejs/node
RUN set -ex && \
  for key in \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    56730D5401028683275BD23C23EFEFE93C4CFFFE \
    77984A986EBC2AA786BC0F66B01FBB92821C587A \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    93C7E9E91B49E432C2F75674B0A78B0A6C481CF6 \
    114F43EE0176B71C7BC219DD50A3051F888C628D \
    7937DFD2AB06298B2293C3187D33FF9D0246406D \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done && \
  yum install -y epel-release && \
  INSTALL_PKGS="httpd-tools bzip2 nss_wrapper wget git" && \
  yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
  rpm -V $INSTALL_PKGS && \
  yum clean all -y && \
  curl -o node-v${NODE_VERSION}-linux-x64.tar.gz -sSL https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz && \
  curl -o SHASUMS256.txt.asc -sSL https://nodejs.org/dist/v${NODE_VERSION}/SHASUMS256.txt.asc && \
  gpg --batch -d SHASUMS256.txt.asc | grep " node-v${NODE_VERSION}-linux-x64.tar.gz\$" | sha256sum -c - && \
  tar -zxf node-v${NODE_VERSION}-linux-x64.tar.gz -C /usr/local --strip-components=1 && \
  npm install -g npm@${NPM_VERSION} && \
  wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo  && \
  yum install -y --setopt=tsflags=nodocs yarn-${YARN_VERSION} && \
  rpm -V yarn-${YARN_VERSION} && \
  yum clean all -y && \
  find /usr/local/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf; \
  rm -rf ~/node-v${NODE_VERSION}-linux-x64.tar.gz ~/SHASUMS256.txt.asc /tmp/node-v${NODE_VERSION} ~/.npm ~/.node-gyp ~/.gnupg /usr/share/man /tmp/* /usr/local/lib/node_modules/npm/man /usr/local/lib/node_modules/npm/doc /usr/local/lib/node_modules/npm/html

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Add s2i nginx custom files
ADD ./contrib/nginx.default.conf /opt/app-root/etc/nginx.default.conf

# Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:0 ${APP_ROOT} && chmod -R ug+rwx ${APP_ROOT}
USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
