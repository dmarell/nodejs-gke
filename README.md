# nodejs-gke
Simple nodejs app to deploy on kubernetes.

# Secrets
env-secrets-dev.json example:
```
{
  "dbHost": "127.0.0.1",
  "dbName": "mydb_prod",
  "dbUser": "mydbuser_prod",
  "dbPass": "mypassprod"
}
```
# Deploy
- Increment/edit image version in image tag in k8s.yaml
- Run deploy script with the incremented version:
    ```
    % bash build-and-deploy.sh dev 1 
    ```
Example command sequence (alias k=kubectl):
Deploy and check logs:
```
bash build-and-deploy.sh dev 1
k -n nodejs-gke-dev get pods
k -n nodejs-gke-dev logs gke-autopilot-demo-7f4f84b8c5-smffc
```
Deploy again and check logs:
```
bash build-and-deploy.sh dev 2
k -n nodejs-gke-dev get pods
k -n nodejs-gke-dev logs gke-autopilot-demo-7c9568c4f8-rmvgs
```
Check service and ingress:
```
k -n nodejs-gke-dev get services
k -n nodejs-gke-dev get ingress   (check IP, takes a few minutes)
curl 34.34.34.134
k -n nodejs-gke-dev describe ingress gke-autopilot-demo-ingress
k -n nodejs-gke-dev describe service gke-autopilot-demo-service
```
