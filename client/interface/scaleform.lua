kxm.scaleform = {}

-- Load kxm.scaleform
kxm.scaleform.LoadMovie = function(name)
    local scaleform = RequestScaleformMovie(name)
    while not HasScaleformMovieLoaded(scaleform) do Wait(0); end
    return scaleform
end

kxm.scaleform.LoadInteractive = function(name)
    local scaleform = RequestScaleformMovieInteractive(name)
    while not HasScaleformMovieLoaded(scaleform) do Wait(0); end
    return scaleform
end

kxm.scaleform.UnloadMovie = function(scaleform)
    SetScaleformMovieAsNoLongerNeeded(scaleform)
end

-- Text & labels
kxm.scaleform.LoadAdditionalText = function(gxt,count)
    for i=0,count,1 do
        if not HasThisAdditionalTextLoaded(gxt,i) then
            ClearAdditionalText(i, true)
            RequestAdditionalText(gxt, i)
            while not HasThisAdditionalTextLoaded(gxt,i) do Wait(0); end
        end
    end
end

kxm.scaleform.SetLabels = function(scaleform,labels)
    PushScaleformMovieFunction(scaleform, "SET_LABELS")
    for i=1,#labels,1 do
        local txt = labels[i]
        BeginTextCommandkxm.scaleformtring(txt)
        EndTextCommandkxm.scaleformtring()
    end
    PopScaleformMovieFunctionVoid()
end

-- Push method vals wrappers
kxm.scaleform.PopMulti = function(scaleform,method,...)
    PushScaleformMovieFunction(scaleform,method)
    for _,v in pairs({...}) do
        local trueType = kxm.scaleform.TrueType(v)
        if trueType == "string" then
            PushScaleformMovieFunctionParameterString(v)
        elseif trueType == "boolean" then
            PushScaleformMovieFunctionParameterBool(v)
        elseif trueType == "int" then
            PushScaleformMovieFunctionParameterInt(v)
        elseif trueType == "float" then
            PushScaleformMovieFunctionParameterFloat(v)
        end
    end
    PopScaleformMovieFunctionVoid()
end

kxm.scaleform.PopFloat = function(scaleform,method,val)
    PushScaleformMovieFunction(scaleform,method)
    PushScaleformMovieFunctionParameterFloat(val)
    PopScaleformMovieFunctionVoid()
end

kxm.scaleform.PopInt = function(scaleform,method,val)
    PushScaleformMovieFunction(scaleform,method)
    PushScaleformMovieFunctionParameterInt(val)
    PopScaleformMovieFunctionVoid()
end

kxm.scaleform.PopBool = function(scaleform,method,val)
    PushScaleformMovieFunction(scaleform,method)
    PushScaleformMovieFunctionParameterBool(val)
    PopScaleformMovieFunctionVoid()
end

-- Push no args
kxm.scaleform.PopRet = function(scaleform,method)
    PushScaleformMovieFunction(scaleform, method)
    return PopScaleformMovieFunction()
end

kxm.scaleform.PopVoid = function(scaleform,method)
    PushScaleformMovieFunction(scaleform, method)
    PopScaleformMovieFunctionVoid()
end

-- Get return
kxm.scaleform.RetBool = function(ret)
    return GetScaleformMovieFunctionReturnBool(ret)
end

kxm.scaleform.RetInt = function(ret)
    return GetScaleformMovieFunctionReturnInt(ret)
end

-- Util functions
kxm.scaleform.TrueType = function(val)
    if type(val) ~= "number" then return type(val); end

    local s = tostring(val)
    if string.find(s,'.') then
        return "float"
    else
        return "int"
    end
end
