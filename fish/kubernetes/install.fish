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

function oxker -d "oxker: install it if you want it"
    echo (set_color blue)"oxker:"(set_color brblack)" command not installed"(set_color normal)
    echo (set_color brblack)"  A simple tui to view & control docker containers"(set_color normal)
    echo

    function read_confirm
        set -l response
        trap "echo -e '\nAborted by user.'; return 1" INT
    
        while true
            read -P "$argv[1] (y/N): " -l response
    
            switch $response
                case "y" "Y"
                    trap - INT
                    return 0
                case "n" "N" ""
                    trap - INT
                    return 1
            end
        end
    end

    if command -qa cargo
        echo (set_color blue)"[i]> Install with:"(set_color normal)
        echo (set_color blue)"-------------"(set_color normal)
        
        echo "cargo install oxker"
        
        echo (set_color blue)"-------------"(set_color normal)
        echo

        if read_confirm "Do you want it installed for you?"
            command cargo install oxker

            functions --erase oxker &> /dev/null
            funcsave oxker &> /dev/null

            prevd
        end
    end

    return 1
end

funcsave oxker &> /dev/null

if ! command -qs oxker
	exit 0
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
