if command -qa kubens
    if command -qa kubefwd
        function knf -d "Set Teamspace and port forward service"
            command kubens $argv
            sudo kubefwd services
        end
    end
end
