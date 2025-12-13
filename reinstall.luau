local cloneref = cloneref or function(ref: Instance): Instance
    return ref    
end

local StarterGui: StarterGui = cloneref(game:GetService('StarterGui'))

if not getgenv().catvapedev then
    if isfolder('catrewrite') then
        for _, v: string in listfiles('catrewrite') do
            if not v:find('profiles') then
                if isfolder(v) then
                    delfolder(v)
                elseif isfile(v) then
                    delfile(v)
                end
            end
        end

        if isfolder('catrewrite/profiles') and isfile('catrewrite/profiles/commit.txt') then
            delfile('catrewrite/profiles/commit.txt')
        end
    end
end

StarterGui:SetCore('SendNotification', {
    Title = 'Cat Vape',
    Text = 'Successfully reinstalled catvape',
    Duration = 12
})