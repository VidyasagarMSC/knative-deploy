#!/bin/bash

kubectl delete --filename build.yaml

kubectl delete --filename serviceaccount.yaml

kubectl delete --filename secret.yaml

kubectl delete --filename kaniko.yaml