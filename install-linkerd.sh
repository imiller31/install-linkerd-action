curl -sL run.linkerd.io/install | sudo bash    
export PATH=$PATH:/home/runner/.linkerd2/bin
linkerd version
linkerd check --pre
linkerd install | kubectl --kubeconfig ${{ inputs.KUBECONFIG}} apply -f -
if [${INSTALL_VIZ}] 
then 
    linkerd viz install | kubectl --kubeconfig ${{ inputs.KUBECONFIG}} apply -f - 
fi
linkerd check
