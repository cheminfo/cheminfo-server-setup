<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Overview](#overview)
  - [Useful links](#useful-links)
- [ROC installation instructions](#roc-installation-instructions)
  - [Step 1: Install CouchDB](#step-1-install-couchdb)
    - [Download and build CouchDB](#download-and-build-couchdb)
    - [Create CouchDB user and start the server](#create-couchdb-user-and-start-the-server)
    - [Setup CouchDB administrator account](#setup-couchdb-administrator-account)
  - [Step 2: Install Node.js](#step-2-install-nodejs)
    - [Download and install latest Node.js version](#download-and-install-latest-nodejs-version)
    - [Add Node.js bin directory to the PATH](#add-nodejs-bin-directory-to-the-path)
  - [Step 3: Install PM2](#step-3-install-pm2)
  - [Step 4: Install rest-on-couch](#step-4-install-rest-on-couch)
    - [Download ROC and install dependencies](#download-roc-and-install-dependencies)
    - [Create rest-on-couch home directory](#create-rest-on-couch-home-directory)
    - [Create PM2 config](#create-pm2-config)
    - [Add rest-on-couch user](#add-rest-on-couch-user)
    - [Create rest-on-couch database(s)](#create-rest-on-couch-databases)
    - [Create rest-on-couch config](#create-rest-on-couch-config)
    - [Create rest-on-couch config for the visualizer database](#create-rest-on-couch-config-for-the-visualizer-database)
  - [Step 5: install and/or configure Apache](#step-5-install-andor-configure-apache)
    - [Disable SELinux](#disable-selinux)
    - [Open port 80](#open-port-80)
    - [Install Apache](#install-apache)
    - [Add rest-on-couch proxy pass to Apache configuration](#add-rest-on-couch-proxy-pass-to-apache-configuration)
    - [Enable Apache](#enable-apache)
    - [Add home page](#add-home-page)
  - [Step 6: Configure LDAP search](#step-6-configure-ldap-search)
    - [Install ldapjs in ROC home dir](#install-ldapjs-in-roc-home-dir)
    - [Example use](#example-use)
  - [Step 7: install and configure flavor-builder](#step-7-install-and-configure-flavor-builder)
    - [Create a filtered replication of the view database](#create-a-filtered-replication-of-the-view-database)
    - [Install flavor-builder](#install-flavor-builder)
    - [Create flavor-builder config directory](#create-flavor-builder-config-directory)
    - [Configure flavor-builder](#configure-flavor-builder)
    - [Add flavor-builder crontab](#add-flavor-builder-crontab)
  - [Step 8: Install and configure visualizer-on-tabs](#step-8-install-and-configure-visualizer-on-tabs)
    - [Clone visualizer-on-tabs](#clone-visualizer-on-tabs)
    - [Choose your configuration](#choose-your-configuration)
    - [Build the project on your default apache websites directory](#build-the-project-on-your-default-apache-websites-directory)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Overview
## Useful links
* [CouchDB](http://couchdb.apache.org/)
* [nodejs](https://nodejs.org/en/)
* [pm2](https://github.com/Unitech/pm2)
* [rest-on-couch](https://github.com/cheminfo/rest-on-couch/)

# ROC installation instructions
How to install and configure a rest-on-couch server with built-in view manager.
This tutorial is made for CentOS 7.

## Step 1: Install CouchDB

### Download and build CouchDB

<table>
<tr>
<th>System</th>
<th>Code</th>
</tr>
<tr>
<td>
CentOS 7 (64bit)
</td>
<td>
<pre lang="bash">
  yum --assumeyes install autoconf autoconf-archive automake curl-devel erlang erlang-asn1 erlang-erts erlang-eunit erlang-os_mon erlang-xmerl gcc-c++ help2man libicu-devel libtool perl-Test-Harness js-devel git crontabs httpd
  mkdir -p /usr/local/src/
  cd /usr/local/src
  curl -s  http://mirror.switch.ch/mirror/apache/dist/couchdb/source/1.6.1/apache-couchdb-1.6.1.tar.gz | tar -zx
  cd apache-couchdb-1.6.1
  ./configure --with-erlang=/usr/lib64/erlang/usr/include --prefix=/
  make
  make install
</pre>
</td>
</tr>
<tr>
<td>
CentOS 6 (32bit)
</td>
<td>
<pre lang="bash">
  yum --assumeyes install autoconf autoconf-archive automake curl-devel erlang erlang-asn1 erlang-erts erlang-eunit erlang-os_mon erlang-xmerl gcc-c++ help2man libicu-devel libtool perl-Test-Harness xz zip
  
  mkdir -p /usr/local/src/
  cd /usr/local/src/
  curl -s http://ftp.mozilla.org/pub/js/js185-1.0.0.tar.gz | tar -xz
  cd js-1.8.5/js/src
  ./configure
  make
  make install
  cp -an /usr/local/lib/libmozjs* /lib/ # Copy to /lib64/ instead on 64 bit system
  
  cd /usr/local/src
  curl -s  http://mirror.switch.ch/mirror/apache/dist/couchdb/source/1.6.1/apache-couchdb-1.6.1.tar.gz | tar -zx
  cd apache-couchdb-1.6.1
  ./configure --with-erlang=/usr/lib/erlang/usr/include --prefix=/
  make
  make install
</pre>
</td>
</tr>
</table>

### Create CouchDB user and start the server

<table>
<tr>
<th>System</th>
<th>Code</th>
</tr>
<tr>
<td>
CentOS 7 (64bit)
</td>
<td>
<pre lang="bash">
  useradd --comment "CouchDB Administrator" --home-dir /var/lib/couchdb --user-group --system --shell /bin/bash couchdb
  chown -R couchdb:couchdb /etc/couchdb /var/lib/couchdb /var/log/couchdb /var/run/couchdb
  mv /etc/rc.d/couchdb /etc/init.d/couchdb
  chkconfig --add couchdb
  systemctl enable couchdb
  systemctl start couchdb
</pre>
</td>
</tr>
<tr>
<td>
CentOS 6 (32bit)
</td>
<td>
<pre lang="bash">
  useradd --comment "CouchDB Administrator" --home-dir /var/lib/couchdb --user-group --system --shell /bin/bash couchdb
  chown -R couchdb:couchdb /etc/couchdb /var/lib/couchdb /var/log/couchdb /var/run/couchdb
  mv /etc/rc.d/couchdb /etc/init.d/couchdb
  chkconfig --add couchdb
  chkconfig couchdb on
  service couchdb start
</pre>
</td>
</tr>
</table>

### Setup CouchDB administrator account

```bash
curl -X PUT http://localhost:5984/_config/admins/admin -d '"password"'
```

## Step 2: Install Node.js

### Download and install latest Node.js version

<table>
<tr>
<th>System</th>
<th>Code</th>
</tr>
<tr>
<td>
CentOS 7 (64bit)
</td>
<td>
<pre lang="bash">
  mkdir -p /usr/local/node
  cd /usr/local/node
  NODE_LATEST=$(curl -s https://nodejs.org/dist/index.tab | cut -f 1 | sed -n 2p)
  curl -s https://nodejs.org/dist/${NODE_LATEST}/node-${NODE_LATEST}-linux-x64.tar.xz | tar --xz --extract
  ln -fs node-${NODE_LATEST}-linux-x64 latest
</pre>
</td>
</tr>
<tr>
<td>
CentOS 6 (32bit)
</td>
<td>
<pre lang="bash">
  mkdir -p /usr/local/node
  cd /usr/local/node
  NODE_LATEST=$(curl -s https://nodejs.org/dist/index.tab | cut -f 1 | sed -n 2p)
  curl -s https://nodejs.org/dist/${NODE_LATEST}/node-${NODE_LATEST}-linux-x86.tar.xz | tar --xz --extract
  ln -fs node-${NODE_LATEST}-linux-x86 latest
</pre>
</td>
</tr>
</table>

### Add Node.js bin directory to the PATH

```bash
echo 'PATH=${PATH}:/usr/local/node/latest/bin' >> /root/.bashrc
```
Now reload a session in your terminal (by relogging in) to update you environment

## Step 3: Install PM2

```bash
mkdir -p /usr/local/pm2
npm install -g pm2@latest
```

## Step 4: Install rest-on-couch

### Download ROC and install dependencies

```bash
cd /usr/local/node
git clone https://github.com/cheminfo/rest-on-couch.git
cd rest-on-couch
npm install
npm run compile
```

### Create rest-on-couch home directory

```bash
mkdir -p /usr/local/rest-on-couch
```

### Create PM2 config

Create a file in `/usr/local/pm2/roc.json` with the following content:

```json
{
  "name"        : "roc",
  "script"      : "bin/rest-on-couch-server.js",
  "cwd"         : "/usr/local/node/rest-on-couch",
  "env"         : { "DEBUG": "couch:error,couch:warn,couch:debug", "REST_ON_COUCH_HOME_DIR": "/usr/local/rest-on-couch" },
  "exec_mode"   : "cluster_mode",
  "instances"   : 4 
}
```

### Add rest-on-couch user

```bash
curl -X PUT http://admin:password@localhost:5984/_users/org.couchdb.user:rest-on-couch  -d '{"password": "123", "type": "user", "name": "rest-on-couch", "roles":[]}'
```

### Create rest-on-couch database(s)

```bash
# Create the database
curl -X PUT http://admin:password@localhost:5984/visualizer/
# Update database's security document. Makes the database editable only by the rest-on-couch couchdb user
curl -X PUT http://admin:password@localhost:5984/visualizer/_security -d '{"admins":{"names":["rest-on-couch"],"roles":[]},"members":{"names":["rest-on-couch"],"roles":[]}}'
```

Execute the same two lines with a different name instead of "visualizer" for any other database that has to be created.

### Create rest-on-couch config

Create a file in `/usr/local/rest-on-couch/config.js` with the following content:

```js
'use strict';

module.exports = {
  allowedOrigins: ["http://server1.example.com"],
  port: 3005,
  sessionDomain: "server1.example.com",

  // CouchDB credentials
  username: "rest-on-couch",
  password: "123",

  proxyPrefix: '/rest-on-couch/',
  publicAddress: 'https://server1.example.com',  
  auth: {
    ldap: {
      server: {
        url: 'ldaps://ldap.example.com',
        searchBase: 'c=ch',
        searchFilter: 'uid={{username}}'
      }
    }
  },
  
  //Uncomment to allow couchdb authentication
  //couchdb:{} 
  
  //Uncomment and configure to allow google authentication
  //google:{clientID:"242342424", clientSecret:"sad3fsfsfs"}
  // Default database rights
  // Any logged in user can create documents. Only owners can read and write their own documents
  rights: {
    read: [],
    write: [],
    create: ['anyuser']
  }
};
```

### Create rest-on-couch config for the visualizer database
Clone the rest-on-couch config for the visualizer to `/usr/local/rest-on-couch/visualizer`
```
cd /usr/local/rest-on-couch
git clone https://github.com/cheminfo/roc-visualizer-config.git visualizer
```

## Step 5: install and/or configure Apache

### Disable SELinux

Temporarily: `setenforce 0`
Permanently: edit `/etc/selinux/config` and set `SELINUX=permissive`

### Open port 80

<table>
<tr>
<th>System</th>
<th>Code</th>
</tr>
<tr>
<td>
CentOS 7 (64bit)
</td>
<td>
<pre lang="bash">
  firewall-cmd --permanent --zone=public --add-port=80/tcp
  firewall-cmd --reload
</pre>
</td>
</tr>
<tr>
<td>
CentOS 6 (32bit)
</td>
<td>
<pre lang="bash">
  iptables -I INPUT 1 -p tcp -mtcp --dport 80 -j ACCEPT
  iptables -I INPUT 1 -p tcp -mtcp --dport 443 -j ACCEPT
  service iptables save
  service iptables restart
</pre>
</td>
</tr>
</table>

### Create and configure a virtual host for your web pages

```
<VirtualHost *:80>
     DocumentRoot /var/www/html/
     ServerName test1.cheminfo.org
     ProxyPass /rest-on-couch/ http://127.0.0.1:3005/
     ProxyPass /couchdb/ http://127.0.0.1:5984/
</VirtualHost>
```

### Enable Apache

<table>
<tr>
<th>System</th>
<th>Code</th>
</tr>
<tr>
<td>
CentOS 7 (64bit)
</td>
<td>
<pre lang="bash">
  systemctl start httpd.service
  systemctl enable httpd.service
</pre>
</td>
</tr>
<tr>
<td>
CentOS 6 (32bit)
</td>
<td>
<pre lang="bash">
  chkconfig httpd on
  service httpd start
</pre>
</td>
</tr>
</table>

### Add home page

Copy both files from https://github.com/cheminfo/cheminfo-server-setup/tree/master/doc/home somewhere in your root apache directory

## Step 6: Configure LDAP search

### Install ldapjs in ROC home dir

```bash
cd /usr/local/rest-on-couch
npm install ldapjs
```

### Example use

```js
const LDAP = require('ldapjs');

var ldap = LDAP.createClient({
  url: 'ldap://ldap.epfl.ch'
});

ldap.search('c=ch', {
  scope: 'sub',
  filter: 'uid=patiny',
  attributes: ['mail']
}, function(err, res) {
  var mail;
  res.on('searchEntry', function(entry) {
    mail = entry.object.mail;
  });
  res.on('end', function() {
    if (mail) console.log(mail);
    else console.log('not found');
    ldap.unbind(); // Close connection to the server
  });
});
```
## Step 7: install and configure flavor-builder
The flavor-builder enables to generate a static website from a users's public views
The flavor-builder will work once the output directory in apache has been created (see Apache section)

### Create a filtered replication of the view database
```bash
# Trigger a continuous filtered replication of the visualizer database of views
curl -H 'Content-Type: application/json' -X POST http://admin:password@localhost:5984/_replicator -d '{"source":"http://admin:password@localhost:5984/visualizer","target":"http://admin:password@localhost:5984/visualizer-public", "continuous":true, "create_target": true, "filter": "app/copyPublic"}'
# Update security of the database, make it readable by anyone but writable only by rest-on-couch
curl -X PUT http://admin:password@localhost:5984/visualizer-public/_security -d '{"admins":{"names":["rest-on-couch"],"roles":[]},"members":{"names":[],"roles":[]}}'
```

### Install flavor-builder
```bash
cd /usr/local/node/
git clone https://github.com/cheminfo/flavor-builder.git
cd /usr/local/node/flavor-builder
npm install
```

### Create flavor-builder config directory

```bash
mkdir /usr/local/flavor-builder
```

### Configure flavor-builder
Copy and adapt the following configuration file to `/usr/local/flavor-builder/config.json`

```json
{
  "couchurl": "http://isicgesrv2.epfl.ch/couchdb/",
  "couchLocalUrl": "http://127.0.0.1:5984",
  "couchDatabase": "visualizer-public",
  "couchUsername": "rest-on-couch",
  "couchPassword": "123",
  "dir": "/var/www/html/flavor-builder",
  "home": "Home",
  "forceUpdate": false,
  "flavorUsername": "michael.zasso@epfl.ch",
  "editRedirect": "http://isicgesrv2.epfl.ch/visualizer/",
  "cdn": "http://www.lactame.com",
  "direct": "http://direct.lactame.com",
  "flavorLayouts": {
    "720p": "minimal-simple-menu",
    "eln": "visualizer-on-tabs"
  },
  "layouts": {
    "default": "simplemenu/endlayouts/simplemenu.html",
    "minimal-simple-menu": "simplemenu/endlayouts/simple.html"
  },
  "libFolder": "Q92ELCJKTIDXB",
  "selfContained": true,
  "visualizerOnTabs": {
    "_default": {
      "rocLogin": {
        "url": "http://isicgesrv2.epfl.ch/rest-on-couch/",
        "redirect": "http://isicgesrv2.epfl.ch/flavor-builder/",
        "auto": true
      },
      "rewriteRules": [
        {"reg": "^[^/]+$", "replace": "http://isicgesrv2.epfl.ch/couchdb/visualizer-public/$&/view.json"}
      ]

    }
  }
}
```

Adapt `couchPassword`, `flavorUsername`

### Add flavor-builder crontab

```bash
echo "* * * * * (cd /usr/local/node/flavor-builder/ /usr/local/node/latest/bin/node bin/build.js --config=/usr/local/flavor-builder/config.json  > /dev/null 2>&1)" | crontab -
```


## Step 8: Install and configure visualizer-on-tabs

### Clone visualizer-on-tabs

Clone the github project in your prefered location. In this example let's use /usr/local/node/

```bash
cd /usr/local/node/
git clone https://github.com/cheminfo/visualizer-on-tabs.git
cd visualizer-on-tabs
npm install
```

### Choose your configuration

If you want to override the default behavior of visualizer-on-tabs, you have to add a custom.json with your custom preferences in /usr/local/on-tabs-config/custom.json. Here there is an [example](https://github.com/cheminfo/cheminfo-server-setup/blob/master/doc/on-tabs/custom.json)

### Build the project on your default apache websites directory

```bash
node bin/build.js --outDir=/var/www/html/on-tabs/ --config=/usr/local/on-tabs-config/custom.json
```

Now you try it in: www.myserver.com/on-tabs/





