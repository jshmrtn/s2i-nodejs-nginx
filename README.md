# S2I: NodeJS / NGINX

**This project is under heavy development and not yet ready for production.**

## Releases / Versions

[Node.JS versions currently provided](https://hub.docker.com/r/jshmrtn/s2i-nodejs-nginx/tags/):

- 4
- 5
- 6
- 7
- lts (6)
- latest (7)

We will tag minor versions as well, but these will be replaced. If using this builder, you should always set major versions or lts/latest.

## Usage

OpenShift allows you to quickly start a build using the web console, or the CLI.

With the [`oc` command-line tool](https://github.com/openshift/origin/releases) you can bundle a static project (based on NodeJS, for example Webpack) into a centos7 image running only NGINX.:

    oc new-app jshmrtn/s2i-nodejs-nginx:RELEASE~REPO_URL

### Configuration

#### nginx.conf

You can add your custom `nginx.conf` to the container. While assembling, the builder looks for a nginx.conf file in your projects `.s2i/nginx/` directory. If there is a `nginx.conf` present at `.s2i/nginx/nginx.conf`, it will copy all contents of the `.s2i/nginx/` directory and put it into the target images `/opt/app-root/etc` directory. There the custom nginx.conf file will be used.

```bash
if [[ -f .s2i/nginx/nginx.conf ]]; then
  echo "---> Installing custom NGINX configuration..."
  cp -Rf .s2i/nginx/. /opt/app-root/etc/
else
  echo "---> Installing stock NGINX configuration..."
  cp -Rf /opt/app-root/etc/nginx.default.conf /opt/app-root/etc/nginx.conf
fi
```

#### nginx.conf includes

You can include files in your custom configuration. This is useful if you have many configuration files. If you provide the builder with a custom nginx.conf file in your projects `.s2i/nginx/` directory, all other files inside `.s2i/nginx/` will be copied along as well. So you could for example include a file with mime types in your custom nginx.conf. Add the file `.s2i/nginx/mime.types` to your project and include it like this:

```
include       /opt/app-root/etc/mime.types;
```



#### Basic Auth

The builder can add basic auth to the container for you. All you need to do is to set some environment variables.
**IMPORTANT: You need to set these on the build config!**

```bash
BASICAUTH_USERNAME
```

The username used for basic auth.

```bash
BASICAUTH_PASSWORD
```

The password used for basic auth.

```bash
BASICAUTH_TITLE
```

The title used for basic auth.

## Installation

There are several ways to make this base image and the full list of tagged nodejs releases available to users during OpenShift's web-based "Add to Project" workflow.

### For OpenShift Online Next Gen Developer Preview

Those without admin privileges can install the latest nodejs releases within their project context with:

**Local**

    oc create -f imagestream.json

**Remote**

    oc create -f https://raw.githubusercontent.com/jshmrtn/s2i-nodejs-nginx/master/imagestream.json

To ensure that each of the latest NodeJS release tags are available and displayed correctly in the web UI, try upgrading / reinstalling the imageStream:

**Local**

    oc delete is/nodejs-nginx ; oc create -f imagestream.json

**Remote**

    oc delete is/nodejs-nginx ; oc create -f https://raw.githubusercontent.com/jshmrtn/s2i-nodejs-nginx/master/imagestream.json

If you've (automatically) imported this image using the [`oc new-app` example command](#usage), then you may need to clear the auto-imported image stream reference and re-install it.

#### For Administrators

Administrators can make these S2I releases available globally (visible in all projects, by all users) by adding them to the `openshift` namespace:

**Local**

    oc create -n openshift -f imagestream.json

**Remote**

    oc create -n openshift -f https://raw.githubusercontent.com/jshmrtn/s2i-nodejs-nginx/master/imagestream.json
