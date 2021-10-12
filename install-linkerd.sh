curl -sL run.linkerd.io/install | sh 
export PATH=$PATH:/home/runner/.linkerd2/bin
linkerd version
linkerd check --pre
linkerd install | kubectl --kubeconfig $KUBECONFIG apply -f -
if [$INSTALL_VIZ}] 
then 
    linkerd viz install | kubectl --kubeconfig $KUBECONFIG apply -f - 
fi
linkerd check
