local function ostime()
    return os.time()
end

lib.callback.register('kxm_utils:cb:ostime', ostime)
