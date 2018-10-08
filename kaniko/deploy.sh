#!/bin/bash

kubectl apply --filename kaniko.yaml

kubectl apply --filename secret.yaml

kubectl apply --filename serviceaccount.yaml

kubectl apply --filename build.yaml
