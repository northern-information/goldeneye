-- goldeneye

engine.name="Goldeneye"

function init()
end


function playkick()
  fname="/home/we/dust/audio/common/808/808-BD.wav"
  amp=1
  amp_lag=0
  sample_start=0
  sample_end=1
  loop=0
  rate=1
  trig=1
  engine.play(fname,amp,amp_lag,sample_start,sample_end,loop,rate,trig)
end

function fade_in_loop()
  -- fade in and loop...
  fname="/home/we/dust/audio/tehn/whirl1.aif"
  amp=1
  amp_lag=4 -- fade in time
  sample_start=0
  sample_end=1
  loop=1
  rate=2
  trig=1
  engine.play(fname,amp,amp_lag,sample_start,sample_end,loop,rate,trig)
end

function retrig_loop()
  -- retrig
  fname="/home/we/dust/audio/tehn/whirl1.aif"
  amp=1
  amp_lag=0
  sample_start=0
  sample_end=1
  loop=1
  rate=2
  trig=1 -- just keep trig 1 and everything the same
  engine.play(fname,amp,amp_lag,sample_start,sample_end,loop,rate,trig)
end

function fade_out_loop()
  -- fade out the same sample...
  fname="/home/we/dust/audio/tehn/whirl1.aif"
  amp=0 -- turn amp to 0
  amp_lag=4 -- fade out time
  sample_start=0
  sample_end=1
  loop=1
  rate=2
  trig=0 -- 0 trig means we won't reset the sample to the beginning
  engine.play(fname,amp,amp_lag,sample_start,sample_end,loop,rate,trig)
end
