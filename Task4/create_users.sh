#!/bin/bash

mkdir -p users && cd users

#!/bin/bash

mkdir -p users && cd users

USERS=(
  "productowner:product-owners"
  "developer:developers"
)

# Указываем путь к вашему Docker Desktop CA
CA_PEM="$HOME/.docker/ca.pem"
CA_KEY="$HOME/.docker/ca-key.pem"
CLUSTER="docker-desktop"

for user_data in "${USERS[@]}"; do
  user=$(echo "$user_data" | cut -d':' -f1)
  group=$(echo "$user_data" | cut -d':' -f2)

  openssl genrsa -out "$user.key" 2048
  openssl req -new -key "$user.key" -out "$user.csr" -subj "/CN=$user/O=$group"
  openssl x509 -req -in "$user.csr" -CA "$CA_PEM" -CAkey "$CA_KEY" -CAcreateserial -out "$user.crt" -days 365

  # Добавить credentials
  kubectl config set-credentials "$user" --client-certificate="$user.crt" --client-key="$user.key"

  # Добавить context
  kubectl config set-context "$user-context" --cluster="$CLUSTER" --namespace=default --user="$user"
done

echo "Пользователи созданы: productowner, developer"