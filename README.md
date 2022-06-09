# argoworkflow-dex
Dex Integration for Argo workflow without argocd dex
# Microsoft Connector
## Create a Microsoft AzureAD OIDC Client before anything. Following documentation to create one. 
- https://docs.microsoft.com/en-us/power-apps/maker/portals/configure/configure-openid-settings 
- Save your `Application (client) ID` , `Directory (tenant) ID` and value for `client secret`. We will need it for our kubernates seceret and configmaps 

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
- Verify you yamls first
    ```bash
    helm template demo . -f values.yaml -s templates/dex.yaml -n argo 
    helm template demo . -n argo 
    ```