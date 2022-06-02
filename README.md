# argoworkflow-dex
Dex Integration for Argo workflow without argocd dex
# Genrate Self-signed cert. 
    Microsoft OIDC provider will not work without secure connection for any IP.
    - Generate CA cert as we will be our own CA
    ```
    openssl genrsa -des3 -out myCA.key 2048
    openssl req -x509 -new -nodes -key myCA.key -sha256 -days 10 -out myCA.pem
    ```
    - 