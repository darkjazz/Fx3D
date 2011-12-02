Routine({
	~pat03bufA = Buffer.read(s, "/Users/alo/sounds/fb/fb_8.aif");
	~pat03bufB = Buffer.read(s, "/Users/alo/sounds/fb/fb_6.aif");
	
	Server.default.sync;
	
	~pat03trgbus = Bus.control;
	
	~pat03amps = Pseq([0, Array.rand(4, 0, 4)].lace(16), inf).asStream;
	
	~pat03map = (
		xang: CyclicWarp(ControlSpec(-pi, pi)),
		yang: CyclicWarp(ControlSpec(pi, -pi)),
		zang: CyclicWarp(ControlSpec(-pi, pi)),
		azm: CyclicWarp(ControlSpec(0, 2pi))
	);
	
	~pat03synth = Synth.tail(~agrp, \pat03play, [
		\out, ~abus, \trgin, ~pat03trgbus, \bufferA, ~pat03bufA, \bufferB, ~pat03bufB, 
		\bdur, 0.01, \del, 1/3, \dec, 6, \rtm, 9, \spr, 20, \rev, 0.1, \tail, 0.3, \wid, 0.5pi
	]).setn(\env, Env([0.001, 1.0, 1.0, 0.001], [10, 0.4, 0.3], \sine, 2, 1));
	
	~fx.addGlobalsFunction(\pat03, {|values|
		var amp = ~pat03amps.next;
		if (amp > 0)
		{
			~pat03trgbus.set(amp);
			~pat03synth.set(
				\xang, ~pat03map[\xang].map(values.avglbf),
				\yang, ~pat03map[\yang].map(values.avgrtb),
				\zang, ~pat03map[\zang].map(values.avgstate),
				\azm, ~pat03map[\azm].map(values.stddev)
			)
		}
	});
	
	~pat03paramseq = (
		bdur: Pseq([0.03, 0.05, 0.07, 1.0, 0.05, 0.02], inf).asStream,
		del: Pseq([1/3, 1/6, 1/3, 1/1.5], inf).asStream,
		dec: Pseq([3, 6, 12], inf).asStream,
		rtm: Pseq([3, 1, 3, 6, 1], inf).asStream,
		rev: Pseq([0.1, 0.1, 0.2, 0.1], inf).asStream,
		tail: Pseq([0.05, 0.3, 0.05, 0.3, 0.1, 0.1], inf).asStream
	);
	
}).play;

{
	~pat03synth.set(\gate, -10);
	SystemClock.sched(10, { ~pat03synth = nil; nil });
	~fx.removeGlobalsFunction(\pat03);
}