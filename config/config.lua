Config = {
-------------------------------------------------------------------------------------------------------activate------------------ /antilag
    flameSize = 2.0, -- Default = 2.0, anything above 2.5 looks like shit.------------------------------------------- /antilagflameSize
    explosionMaxSpeed = 250, -- Default = 250, Max 1000, this is the max speed of the explosions at high RPM. ---------------------------------- /antilagminspeed
    explosionMinSpeed = 50, -- Default = 50, Min 50, anything under will crash, this is the min speed of the explosions at low RPM.------------ /antilagmaxspeed
    basePitch = 1.0, -- Default = 1.0, anything under 0.5 and above 1.0 sounds like shit.--------------------------------- /antilagpitch
    Volume = 0.7,    -- Default 0.7,
    revLimiterRPM = 0.96, -- Default = 0.96, rpm trigger revlimiter antilag 0.9 and 1.0.---------------------------------------- /antilagminrpm
    
    RPM = 0.4, -- Default = 0.4, RPM: The amount of RPM needed until the antilag is triggered, 0.1 will trigger the antilag at idle, 0.9 will trigger the antilag ONLY at max RPM.
}
