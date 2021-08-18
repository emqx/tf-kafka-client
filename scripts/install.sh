#!/usr/bin/env bash

# install java
sudo apt-get -y update
sudo apt-get -y install openjdk-11-jre-headless

# download and install kafka
sudo wget https://archive.apache.org/dist/kafka/2.6.0/kafka_2.12-2.6.0.tgz
sudo tar -zxvf ~/kafka_2.12-2.6.0.tgz

# create a topic
sudo sh ~/kafka_2.12-2.6.0/bin/kafka-console-consumer.sh --bootstrap-server ${kafka_ip} --topic ${kafka_topic} --from-beginning

