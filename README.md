# S2I: NodeJS / NGINX

**This project is under heavy development and not yet ready.**

## Releases / Versions

[Node.JS versions currently provided](https://hub.docker.com/r/jshmrtn/s2i-nodejs-nginx/tags/):

- 7.2
- 7.3

## Usage

OpenShift allows you to quickly start a build using the web console, or the CLI.

With the [`oc` command-line tool](https://github.com/openshift/origin/releases) you can bundle a static project (based on NodeJS, for example Webpack) into a centos7 image running only NGINX.:

    oc new-app jshmrtn/s2i-nodejs-nginx:RELEASE~REPO_URL

## Installation

There are several ways to make this base image and the full list of tagged nodejs releases available to users during OpenShift's web-based "Add to Project" workflow.

### For OpenShift Online Next Gen Developer Preview

Those without admin privileges can install the latest nodejs releases within their project context with:

    oc create -f https://raw.githubusercontent.com/jshmrtn/s2i-nodejs-nginx/master/imagestream.json

To ensure that each of the latest NodeJS release tags are available and displayed correctly in the web UI, try upgrading / reinstalling the imageStream:

    oc delete is/centos7-s2i-nodejs-nginx ; oc create -f https://raw.githubusercontent.com/jshmrtn/s2i-nodejs-nginx/master/imagestream.json

If you've (automatically) imported this image using the [`oc new-app` example command](#usage), then you may need to clear the auto-imported image stream reference and re-install it.

#### For Administrators

Administrators can make these S2I releases available globally (visible in all projects, by all users) by adding them to the `openshift` namespace:

    oc create -n openshift -f https://raw.githubusercontent.com/jshmrtn/s2i-nodejs-nginx/master/imagestream.json