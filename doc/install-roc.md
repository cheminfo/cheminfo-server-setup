# ROC installation instructions

How to install and configure a rest-on-couch server with built-in view manager.
This tutorial is made for CentOS 7.

## Step 1: Install CouchDB

### Download and build CouchDB

```bash
yum --assumeyes install autoconf autoconf-archive automake curl-devel erlang erlang-asn1 erlang-erts erlang-eunit erlang-os_mon erlang-xmerl gcc-c++ help2man libicu-devel libtool perl-Test-Harness
yum install js-devel
mkdir -p /usr/local/src/
cd /usr/local/src
curl -s  http://mirror.switch.ch/mirror/apache/dist/couchdb/source/1.6.1/apache-couchdb-1.6.1.tar.gz | tar -zx
cd apache-couchdb-1.6.1
./configure --with-erlang=/usr/lib64/erlang/usr/include --prefix=/
make
make install
```

### Create CouchDB user and start the server

```bash
useradd --comment "CouchDB Administrator" --home-dir /var/lib/couchdb --user-group --system --shell /bin/bash couchdb
chown -R couchdb:couchdb /etc/couchdb /var/lib/couchdb /var/log/couchdb /var/run/couchdb
mv /etc/rc.d/couchdb /etc/init.d/couchdb
chkconfig --add couchdb
systemctl enable couchdb
systemctl start couchdb
```

### Setup CouchDB administrator account

```bash
curl -X PUT http://localhost:5984/_config/admins/admin -d '"password"'
```

## Step 2: Install Node.js

### Create the "nodejs" account

```bash
useradd nodejs --comment "Node.js Administrator" --home-dir /usr/local/node --user-group
chmod 755 /usr/local/node
```

### Download and install latest Node.js version

```bash
mkdir -p /usr/local/node
cd /usr/local/node
NODE_LATEST=$(curl -s https://nodejs.org/dist/index.tab | cut -f 1 | sed -n 2p)
curl -s https://nodejs.org/dist/${NODE_LATEST}/node-${NODE_LATEST}-linux-x64.tar.xz | tar --xz --extract
ln -fs node-${NODE_LATEST}-linux-x64 latest
chown -R nodejs /usr/local/node
```

### Add Node.js bin directory to the PATH for nodejs

```bash
echo 'PATH=${PATH}:/usr/local/node/latest/bin' >> /usr/local/node/.bashrc
```

## Step 3: Install PM2

```bash
mkdir -p /usr/local/pm2
chown nodejs /usr/local/pm2
su nodejs -l -c "npm install -g pm2@latest"
```

## Step 4: Install rest-on-couch

### Download ROC and install dependencies

```bash
su nodejs -l
cd /usr/local/node
git clone https://github.com/cheminfo/rest-on-couch.git
cd rest-on-couch
npm install
```

### Create rest-on-couch home directory

```bash
mkdir -p /usr/local/rest-on-couch
chown nodejs /usr/local/rest-on-couch
```

### Create PM2 config

Create a file in `/usr/local/pm2/rest-on-couch.json` with the following content:

```json
{
  "name"        : "rest-on-couch",
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
curl -X PUT http://admin:password@localhost:5984/visualizer/
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
  
  // Default database rights
  // Any logged in user can create documents. Only owners can read and write their own documents
  rights: {
    read: [],
    write: [],
    create: ['anyuser']
  }
};
```

## Step 5: install and/or configure Apache

### Disable SELinux

Temporarily: `setenforce 0`
Permanently: edit `/etc/selinux/config` and set `SELINUX=permissive`

### Install Apache

```bash
yum install httpd
```

### Add proxy pass to Apache configuration

```
ProxyPass /rest-on-couch/ http://127.0.0.1:3005/
```

### Enable Apache

```bash
systemctl start httpd.service
systemctl enable httpd.service
```

### Add home page

Copy both files from https://github.com/cheminfo/cheminfo-server-setup/tree/master/doc/home somewhere on your website

## Step 6: Configure LDAP search

### Install ldapjs in ROC home dir

```bash
su nodejs -l
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
    res.on('searchEntry', function(entry) {
        console.log(entry.object.mail);
    });
});
```
