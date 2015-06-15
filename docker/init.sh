#!/bin/bash
set -e

RALPH_EXEC=/usr/local/bin/ralph
# wait for db init
sleep 15

$RALPH_EXEC migrate --noinput
$RALPH_EXEC createsuperuser --noinput --username ralph --email ralph@allegrogroup.com
python $RALPH_DIR/docker/createsuperuser.py
$RALPH_EXEC sitetreeload
$RALPH_EXEC sitetree_resync_apps

# js
cd $RALPH_DIR
npm install
ln -s /usr/bin/nodejs /usr/bin/node  # fix node.js on ubuntu
PATH=$PATH:$RALPH_DIR/node_modules/.bin; export PATH
gulp
cd -