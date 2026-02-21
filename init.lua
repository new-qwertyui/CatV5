local Arguments = ... or {}
if not Arguments.Key then
    Arguments.Key = script_key or 'unknown key'
end

if shared.VapeDeveloper then
    return loadstring(readfile('catrewrite/loader.lua'), 'loader.lua')(...)
else
    if not isfolder('catrewrite') then
        makefolder('catrewrite')
    end

    local function downloadFile(path, func)
        if not isfile(path) then
            local suc, res = pcall(function()
                return game:HttpGet('https://raw.githubusercontent.com/new-qwertyui/CatV5/main/'..select(1, path:gsub('catrewrite/', '')), true)
            end)
            if not suc or res == '404: Not Found' then
                error(res)
            end
            if path:find('.lua') then
                res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
            end
            writefile(path, res)
        end
        return (func or readfile)(path)
    end

    return loadstring(downloadFile('catrewrite/loader.lua'), 'loader.lua')(...)
end
