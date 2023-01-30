if command -qa pass
    function passu -d "pass sync"
        pass git pull
            and pass git push
    end
end
