#!/usr/bin/env fish
if ! command -qs kubectl
	exit 0
end

if command -qa fisher
    fisher install evanlucas/fish-kubectl-completions
    # curl -sL https://raw.githubusercontent.com/evanlucas/fish-kubectl-completions/master/completions/kubectl.fish -o ~/.config/fish/completions/kubectl.fish
end

if command -qa kubectx
    abbr -a kx kubectx
end

if command -qa kubens
    abbr -a kn kubens
end

abbr -a k kubectl
abbr -a sk 'kubectl -n kube-system'
abbr -a kg 'kubectl get'
abbr -a kgp 'kubectl get po'
abbr -a kga 'kubectl get --all-namespaces'
abbr -a kd 'kubectl describe'
abbr -a kdp 'kubectl describe po'
abbr -a krm 'kubectl delete'
abbr -a ke 'kubectl edit'
abbr -a kex 'kubectl exec -it'
abbr -a knrunning 'kubectl get pods --field-selector=status.phase!=Running'
abbr -a kfails 'kubectl get po -owide --all-namespaces | grep "0/" | tee /dev/tty | wc -l'
abbr -a kimg "kubectl get deployment --output=jsonpath='{.spec.template.spec.containers[*].image}'"
abbr -a kvs "kubectl view-secret"
abbr -a kgno 'kubectl get no --sort-by=.metadata.creationTimestamp'
abbr -a kdrain 'kubectl drain --ignore-daemonsets --delete-local-data'
