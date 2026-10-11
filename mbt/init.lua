-- mbt run demo [-- LIBRARY]: run CINFO, COBINFO and ASMINFO as one job on
-- the target and print what they wrote. The library is the deploy target
-- unless one is named.
mbt.command { name = "demo", description = "run the three main programs on MVS and show their output",
  run = function(ctx)
    local t = ctx.target()
    local lib = ctx.args[1] or ctx.project.deploy_target
    local jcl = { "//MVSINFOA JOB (1),'MVSINFOA',CLASS=" .. t.jobclass .. ",MSGCLASS=" .. t.msgclass }
    for _, m in ipairs { "CINFO", "COBINFO", "ASMINFO" } do
      jcl[#jcl + 1] = string.format("//%-8s EXEC PGM=%s", m, m)
      jcl[#jcl + 1] = "//STEPLIB  DD DSN=" .. lib .. ",DISP=SHR"
      jcl[#jcl + 1] = "//SYSPRINT DD SYSOUT=*"   -- C's stdout
      jcl[#jcl + 1] = "//SYSOUT   DD SYSOUT=*"   -- COBOL's DISPLAY
    end
    local code, body = ctx.mvs.request { method = "PUT", path = "/restjobs/jobs",
      body = table.concat(jcl, "\n") .. "\n", content_type = "text/plain" }
    local id = body:match('"jobid"%s*:%s*"([^"]+)"')
    assert(id, "submit failed: HTTP " .. code .. " " .. body)
    ctx.log("MVSINFOA " .. id .. " from " .. lib)
    local status
    for _ = 1, 60 do
      local _, st = ctx.mvs.request { path = "/restjobs/jobs/MVSINFOA/" .. id }
      status = st:match('"retcode"%s*:%s*"([^"]*)"')
      if st:match('"status"%s*:%s*"OUTPUT"') then break end
      ctx.exec { "sleep", "2" }
    end
    local _, files = ctx.mvs.request { path = "/restjobs/jobs/MVSINFOA/" .. id .. "/files" }
    for f in files:gmatch("%b{}") do
      local fid, dd = f:match('"id"%s*:%s*(%d+)'), f:match('"ddname"%s*:%s*"([^"]*)"')
      if dd == "SYSPRINT" or dd == "SYSOUT" or dd == "JESMSGLG" then
        local _, rec = ctx.mvs.request { path = "/restjobs/jobs/MVSINFOA/" .. id .. "/files/" .. fid .. "/records" }
        for line in rec:gmatch("[^\n]+") do
          if dd ~= "JESMSGLG" or line:find("ASMINFO", 1, true) then print(line) end
        end
      end
    end
    ctx.log("retcode " .. tostring(status))
  end }
