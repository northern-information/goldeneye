// Engine_Goldeneye

// Inherit methods from CroneEngine
Engine_Goldeneye : CroneEngine {

	// <Goldeneye> 
	var bufGoldeneye;
	var synGoldeneye;
	// </Goldeneye>

	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}

	alloc {
		// <Goldeneye> 
		bufGoldeneye=Dictionary.new(128);
		synGoldeneye=Dictionary.new(128);

		context.server.sync;

		SynthDef("playerGoldeneyeStereo",{ 
				arg bufnum, amp=0, ampLag=0, t_trig=0,
				sampleStart=0,sampleEnd=1,loop=0,
				rate=1;

				var snd;
				var frames = BufFrames.kr(bufnum);

				// lag the amp for doing fade out
				amp = Lag.kr(amp,ampLag);
				// use envelope for doing fade in
				amp = amp * EnvGen.ar(Env([0,1],[ampLag]));
				
				// playbuf
				snd = PlayBuf.ar(
					numChannels:2, 
					bufnum:bufnum,
					rate:BufRateScale.kr(bufnum)*rate,
				 	startPos: ((sampleEnd*(rate<0))*frames)+(sampleStart*frames*(rate>0)),
				 	trigger:t_trig,
				 	loop:loop,
				 	doneAction:2,
				);

				// multiple by amp
				snd = snd * amp;

				// if looping, free up synth if no output
				DetectSilence.ar(snd,doneAction:2);

				Out.ar(0,snd)
		}).add;	

		SynthDef("playerGoldeneyeMono",{ 
				arg bufnum, amp=0, ampLag=0, t_trig=0,
				sampleStart=0,sampleEnd=1,loop=0,
				rate=1;

				var snd;
				var frames = BufFrames.kr(bufnum);

				// lag the amp for doing fade in/out
				amp = Lag.kr(amp,ampLag);
				
				// playbuf
				snd = PlayBuf.ar(
					numChannels:1, 
					bufnum:bufnum,
					rate:BufRateScale.kr(bufnum)*rate,
				 	startPos: ((sampleEnd*(rate<0))*frames)+(sampleStart*frames*(rate>0)),
				 	trigger:t_trig,
				 	loop:loop,
				 	doneAction:2,
				);

				snd = Pan2.ar(snd,0);

				// multiple by amp
				snd = snd * amp;

				// if looping, free up synth if no output
				DetectSilence.ar(snd,doneAction:2);

				Out.ar(0,snd)
		}).add;	


		this.addCommand("play","siffffff", { arg msg;
			var filename=msg[1];
			var synName="playerGoldeneyeMono";
			if (bufGoldeneye.at(filename)==nil,{
				// load buffer
				Buffer.read(context.server,filename,action:{
					arg bufnum;
					if (bufnum.numChannels>1,{
						synName="playerGoldeneyeStereo";
					});
					bufGoldeneye.put(filename,bufnum);
					synGoldeneye.put(filename,Synth(synName,[
						\bufnum,bufnum,
						\amp,msg[2],
						\ampLag,msg[3],
						\sampleStart,msg[4],
						\sampleEnd,msg[5],
						\loop,msg[6],
						\rate,msg[7],
						\t_trig,msg[8],
					],target:context.server).onFree({
	                    ("freed "++filename).postln;
	                }));
					NodeWatcher.register(synGoldeneye.at(filename));
				});
				// if (mxsamplesVoiceAlloc.at(filename).isRunning==true,{
				// 	("stealing "++name).postln;
				// 	mxsamplesVoiceAlloc.at(filename).free;
				// });
			},{
				if (bufGoldeneye.at(filename).numChannels>1,{
					synName="playerGoldeneyeStereo";
				});
				if (synGoldeneye.at(filename).isRunning==true,{
					synGoldeneye.at(filename).set(
						\bufnum,bufGoldeneye.at(filename),
						\amp,msg[2],
						\ampLag,msg[3],
						\sampleStart,msg[4],
						\sampleEnd,msg[5],
						\loop,msg[6],
						\rate,msg[7],
						\t_trig,msg[8],
					);
				},{
					synGoldeneye.put(filename,Synth(synName,[
						\bufnum,bufGoldeneye.at(filename),
						\amp,msg[2],
						\ampLag,msg[3],
						\sampleStart,msg[4],
						\sampleEnd,msg[5],
						\loop,msg[6],
						\rate,msg[7],
						\t_trig,msg[8],
					],target:context.server).onFree({
	                    ("freed "++filename).postln;
	                }));
					NodeWatcher.register(synGoldeneye.at(filename));
				});
			});
		});
		// </Goldeneye> 

	}

	free {
		// <Goldeneye> 
    	synGoldeneye.keysValuesDo({ arg key, value; value.free; });
    	bufGoldeneye.keysValuesDo({ arg key, value; value.free; });
		// </Goldeneye> 
	}
}
