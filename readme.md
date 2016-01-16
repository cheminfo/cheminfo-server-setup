
Create an empty folder, go in this folder and run the following command:

```
wget "https://github.com/cheminfo/cheminfo-server-setup/archive/master.zip"
```

Then:
```
unzip master.zip
cd cheminfo-server-setup-master
```

Edit and configure ```config.txt```

Finally install the program:
```
./install.sh
```


## Debug

In order to have a global overview about what is running there is a script `check.sh`. Just go in this github folder and enter

```
./check.sh -q
```

If you have any mistakes please submit us the full report
```
./check.sh -d > report.txt
```



