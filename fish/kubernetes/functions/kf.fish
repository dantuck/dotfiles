if command -qa kubefwd
    function kf -d "Port forward service"
        sudo kubefwd services
    end
end
