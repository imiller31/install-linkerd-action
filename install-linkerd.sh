set -e

curl -sL run.linkerd.io/install | sh 
export PATH=$PATH:/home/runner/.linkerd2/bin
linkerd version
export LINKERD_PRECHECK=$(linkerd check --pre -o short 2>&1)

if grep -q "linkerd upgrade" <<< "$LINKERD_PRECHECK"; then
    linkerd upgrade | kubectl apply --prune -l linkerd.io/control-plane-ns=linkerd -f -
    linkerd upgrade | kubectl apply --prune -l linkerd.io/control-plane-ns=linkerd \
  --prune-whitelist=rbac.authorization.k8s.io/v1/clusterrole \
  --prune-whitelist=rbac.authorization.k8s.io/v1/clusterrolebinding \
  --prune-whitelist=apiregistration.k8s.io/v1/apiservice -f -
else
    linkerd install config | kubectl apply -f -
    linkerd check config
    linkerd install control-plane | kubectl apply -f -
fi

if $INSTALL_VIZ 
then 
    linkerd viz install | kubectl --kubeconfig $KUBECONFIG apply -f - 
fi

linkerd check