#!/bin/bash

kubectl apply -f roles/product-owner-role.yaml
kubectl apply -f roles/developer-role.yaml

kubectl apply -f bindings/product-owner-binding.yaml
kubectl apply -f bindings/developer-binding.yaml

echo "Роли и биндинги применены"