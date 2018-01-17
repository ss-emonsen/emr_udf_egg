#!/bin/bash

usage() { echo "Usage: $0 -s SUBNET_ID -k KEY_NAME" 1>&2; exit 1; }

while getopts ":s:k:" opt; do
  case $opt in
    s)
      SUBNET_ID=${OPTARG}
      ;;
    k)
      KEY_NAME=${OPTARG}
      ;;
    \?)
      echo "Invalid option: $OPTARG" >&2
      usage
      ;;
    :)
      echo "Invalid Option: -$OPTARG requires an argument" 1>&2
      usage
      ;;
  esac
done

if [ -z "${SUBNET_ID}" ] || [ -z "${KEY_NAME}" ]; then
    usage
fi

aws emr create-cluster \
          --release-label emr-5.3.1 \
          --instance-groups InstanceGroupType=MASTER,InstanceType=r4.xlarge,InstanceCount=1 InstanceGroupType=CORE,InstanceType=r4.xlarge,InstanceCount=1 \
          --no-auto-terminate \
          --use-default-roles \
          --configurations file://configurations.json \
          --name emr-egg-udf-repro-2 \
          --no-termination-protected \
          --visible-to-all-users \
          --no-enable-debugging \
          --ec2-attributes SubnetId=$SUBNET_ID,KeyName=$KEY_NAME \
          --applications '[{"Name": "Spark"}, {"Name": "Zeppelin"}, {"Name": "Ganglia"}]'
