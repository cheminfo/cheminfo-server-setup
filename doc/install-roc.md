# ROC installation instructions

How to install and configure a rest-on-couch server with built-in view manager.

## Step 1: Install Node.js

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
ln -fs /usr/local/node/latest/bin/node /usr/bin/node
ln -fs /usr/local/node/latest/bin/npm /usr/bin/npm
chown -R nodejs /usr/local/node
```

### Install PM2

```bash
su nodejs
npm install -g pm2@latest
```
