#!/bin/bash

mkdir bundle 2>/dev/null
curl -o bundle/sencha-cmd.run.zip https://cdn.sencha.com/cmd/5.1.3.61/SenchaCmd-5.1.3.61-linux-x64.run.zip
unzip -p bundle/sencha-cmd.run.zip > bundle/sencha-cmd.run
rm bundle/sencha-cmd.run.zip

chmod +x bundle/sencha-cmd.run
./bundle/sencha-cmd.run --mode unattended --prefix /opt
rm bundle/sencha-cmd.run
rmdir bundle
