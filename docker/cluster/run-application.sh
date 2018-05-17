#!/bin/bash
#
# Copyright © 2016-2018 The Thingsboard Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


dpkg -i /thingsboard.deb


if [ "$DATABASE_TYPE" == "cassandra" ]; then
    IFS=':' read -ra SPLITTED <<< "$CASSANDRA_URL"
    CASSANDRA_HOST=${SPLITTED[0]}
    CASSANDRA_PORT=${SPLITTED[1]}
    until nmap $CASSANDRA_HOST -p $CASSANDRA_PORT | grep "$CASSANDRA_PORT/tcp open\|filtered"
    do
      echo "Wait for cassandra db to start... cassandra_host:$CASSANDRA_HOST, cassandra port: $CASSANDRA_PORT"
      sleep 10
    done
fi

if [ "$DATABASE_TYPE" == "sql" ]; then
    if [ "$SPRING_DRIVER_CLASS_NAME" == "org.postgresql.Driver" ]; then
        until nmap $POSTGRES_HOST -p $POSTGRES_PORT | grep "$POSTGRES_PORT/tcp open"
        do
          echo "Waiting for postgres db to start..."
          sleep 10
        done
    fi
fi

/usr/share/thingsboard/bin/install/install.sh


cat /usr/share/thingsboard/conf/thingsboard.conf

echo "Starting 'Thingsboard' service..."
service thingsboard start

# Wait until log file is created
sleep 10
tail -f /var/log/thingsboard/thingsboard.log
