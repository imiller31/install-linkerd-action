curl -sL run.linkerd.io/install | sh 
export PATH=$PATH:/home/runner/.linkerd2/bin
linkerd version
export LINKERD_PRECHECK = linkerd check --pre -o short

if [[$LINKERD_PRECHECK == *"linkerd upgrade"*]]; then
    linkerd upgrade | kubectl apply -f -
    linkerd upgrade | kubectl apply --prune -l linkerd.io/control-plane-ns=linkerd \
  --prune-whitelist=rbac.authorization.k8s.io/v1/clusterrole \
  --prune-whitelist=rbac.authorization.k8s.io/v1/clusterrolebinding \
  --prune-whitelist=apiregistration.k8s.io/v1/apiservice -f -
else
    linkerd install | kubectl apply -f -
fi

if $INSTALL_VIZ 
then 
    linkerd viz install | kubectl --kubeconfig $KUBECONFIG apply -f - 
fi
export LINKERD_POSTCHECK = linkerd check -o short
if [[$LINKERD_POSTCHECK != *"Status check results are √"*]]; then
    exit 1;
fi