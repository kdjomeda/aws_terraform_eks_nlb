 eksctl utils associate-iam-oidc-provider --region=eu-west-1 --cluster=gmfs-ire-prod-core-eks-act01 --profile joseph --approve

  eksctl create iamserviceaccount \
--cluster=gmfs-ire-prod-core-eks-act01 \
--namespace=kube-system \
--name=aws-load-balancer-controller \
--attach-policy-arn=arn:aws:iam::058264357478:policy/prod-core-core-eks-lbc \
--override-existing-serviceaccounts \
--approve \
--region eu-west-1 \
--profile joseph



 helm uninstall aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system

 helm list

helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=gmfs-ire-prod-core-eks-act01 --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller

kubectl edit deploy aws-load-balancer-controller -n kube-system