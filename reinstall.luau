local cloneref = cloneref or function(ref: any)
    return ref
end

if isfolder('catrewrite') then
    delfolder('catrewrite')
end

cloneref(game:GetService('StarterGui')):SetCore('SendNotification', {
    Title = 'Cat Vape',
    Text = 'Successfully reinstalled Cat Vape',
    Duration = 20
})

loadstring(game:HttpGet('https://raw.githubusercontent.com/new-qwertyui/CatV5/main/init.lua'), 'init.lua')({})