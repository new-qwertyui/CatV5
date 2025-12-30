--> thanks sel

if not hooksignal or not restoresignal then
    local SignalHooks = {}

    function hooksignal(signal, callback)
        if typeof(signal) ~= 'RBXScriptSignal' then error('Expected RBXScriptSignal, got ' .. typeof(signal)) end

        local cons = getconnections(signal)
        if not cons or #cons == 0 then warn('connections no exist you can no hook.') return end

        local ogConn = cons[1]
        local ogFunc = ogConn.Function
        if not ogFunc then return end

        ogConn:Disconnect()

        local hookedConn
        hookedConn = signal:Connect(function(...)
            return callback(ogFunc, ...)
        end)

        SignalHooks[signal] = {
            hookedConnection = hookedConn,
            originalFunction = ogFunc,
        }

        return hookedConn
    end

    getgenv().hooksignal = hooksignal

    function restoresignal(signal)
        local data = SignalHooks[signal]
        if not data then warn('Signal not hooked gng') return end

        if data.hookedConnection.Connected then
            data.hookedConnection:Disconnect()
        end

        signal:Connect(data.originalFunction)
        SignalHooks[signal] = nil
    end

    getgenv().restoresignal = restoresignal
end