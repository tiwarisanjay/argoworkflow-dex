# argoworkflow-dex
Dex Integration for Argo workflow without argocd dex
# Microsoft Connector
## Create a Microsoft AzureAD OIDC Client before anything. Following documentation to create one. 
- https://docs.microsoft.com/en-us/power-apps/maker/portals/configure/configure-openid-settings 
- Save your `Application (client) ID` , `Directory (tenant) ID` and value for `client secret`. We will need it for our kubernates seceret and configmaps 
- Set a callback url as `https://13.133.133.12:5556/dex/callback` in Redirect URIs section when you are setting up your Application. 
## Pre-requisites
- Lets run following command before our deployments 

    ```bash
    ./pre-req.sh 
    # Script is going to ask for following parameter. 
        # clientid [Must provide]
        # clientsecret [Must provide]
        # namespace, defauilt is argo [You can leave it blank]
        # load balancer ip for dex, [You can leave it blank]
    # Script will generate the self signed cert and will create  tls secret for dex and ca configmap for argo
    # Script wil also create secret for argo-workflow-sso 
    ```
- Create a `values.yaml` with followin yaml snippet, by updating the values for below. Rest of the values will be picked up from default values.yaml
    ```yaml
    dex:
    loadBalancerIP: # Dex Service Load balancer IP ex : 34.123.111.123
    config:
        clientid: # Its given when you are creating OIDC application in Azure
        tenantid:  # Its given when you are creating OIDC application in Azure
        clientSecret: # Its given when you are creating OIDC application in Azure
        issuer:  https://34.123.111.123:5556/dex # Dex URL ex : https://34.123.111.123:5556/dex
        staticClient:
        redirectUrl:    # Argo workflow redirect url ex : https://44.123.11.22:2746/oauth2/callback
    argo-workflows:
    server:
        loadBalancerIP: # Argo workflow server Load Blanacer IP ex : 44.123.11.22
        sso:
        issuer: # ex : https://34.123.111.123:5556/dex 
        clientId:
            name: argo-workflows-sso
            key: client-id
        clientSecret:
            name: argo-workflows-sso
            key: client-secret
        redirectUrl: # Argo workflow redirect url ex : https://44.123.11.22:2746/oauth2/callback
    ```
- Run following commands 
    ```bash
    helm repo add helm-chart-repo https://tiwarisanjay.github.io/helm-chart-repo/
    helm repo update 
    helm install dexdemo helm-chart-repo/awdex-microsoft -f values.yaml -n argo
    ``` 
- RBAC rules are still needs to be created and after login you will still see `Forbidden: not allowed` Please follow following documents for RBAC Rule. I will udpate the doucments once I will work on the same. 
    https://argoproj.github.io/argo-workflows/argo-server-sso/
