~pat05data = ~atsdata.select({|ats| ats.file.contains("fxloop_").and(ats.nparts > 150) });

~pat05ind = Pstutter(Pbrown(1, 3, 1, inf), Place((0..~pat05data.lastIndex).clump(4), inf)).asStream;

~pat05defs = Pseq(~noisedefs, inf).asStream;

~pat05rate = Pseq([0.5, 1, 0.5, 0.125, 0.125, 0.0625], inf).asStream;

~pat05dur = Pseq([0.05, 0.25, 0.05, 0.1, 0.2, 0.05, 0.2], inf).asStream;

~pat05xy = Pshuf((0..7), inf).asStream;

~pat05gate = 1.0;

~pat05efxgate = 0.05;

~pat05efx = Bus.audio(Server.default);

~pat05ats = Pstutter(Pwrand((1..4), (4..1).normalizeSum, inf), 
	Pshuf(#[pat05saw, pat05imp, pat05pmo], inf)).asStream;
	
~pat05map = (
	aamp: ControlSpec(-6.dbamp, 3.dbamp),
	eamp: ControlSpec(-10.dbamp, 0.dbamp),
	samp: ControlSpec(-6.dbamp, 3.dbamp),
	xang: ControlSpec(-pi, pi),
	yang: ControlSpec(pi, -pi),
	zang: ControlSpec(pi, -pi),
	xpush: ControlSpec(-0.1pi, 0.1pi),
	ypush: ControlSpec(-0.1pi, 0.1pi),
	zpush: ControlSpec(-0.1pi, 0.1pi)
);

~pat05atsmap = (
	aamp: ControlSpec(0.1, 0.25),
	eamp: ControlSpec(0.25, 0.1),
	dur: ControlSpec(0.75, 2.0),
	rate: ControlSpec(0.1, 0.001),
	off: ControlSpec(0.0, 2.0),
	ind: ControlSpec(5.0, 30.0),
	xang: ControlSpec(-pi, pi),
	yang: ControlSpec(pi, -pi),
	zang: ControlSpec(pi, -pi)
);

~pat05efxmap = (
	amp: ControlSpec(0.5, 1.0),
	dur: ControlSpec(1/6, 1, step: 1/6),
	del: ControlSpec(1/6, 1, step: 1/6),
	dec: ControlSpec(3, 6, step: 1/3),
	wsz: ControlSpec(0.01, 0.2),
	xs: ControlSpec(-0.5pi, 1.5pi),
	xe: ControlSpec(pi, -pi),
	ys: ControlSpec(0, 2pi),
	ye: ControlSpec(-1.5pi, 0.5pi),
	zs: ControlSpec(2pi, 0),
	ze: ControlSpec(0.5pi, -1.5pi)
);

~pat05next = [1, 0].lace(16);

~pat05index = 0;

~fx.addStatesFunction(\pat05, {|values|
	var states = Pseq(values.states.clump(8)[~pat05xy.next], inf).asStream;
	if (~pat05next[~pat05index] == 1)
	{
		if (~pat05gate.coin) {
			Synth.tail(~agrp, ~pat05defs.next, [
				\out, ~abus, \efx, ~pat05efx, \dur, ~pat05dur.next, \rate, ~pat05rate.next,
				\buffer, ~pat05data[~pat05ind.next].buffer, \clip, 0.95 
			] ++ ~pat05map.collect({|spec| spec.map(states.next) }).asKeyValuePairs
			).setn(\env, [Env.perc, Env([0.001, 1.0], [1], \sine)].wchoose([0.9, 0.1]))
		}
		{
			Synth.tail(~agrp, ~pat05ats.next, [
				\out, ~abus, \efx, ~pat05efx, \buffer, ~pat05data[~pat05ind.next].buffer
			] ++ ~pat05atsmap.collect({|spec| spec.map(states.next) }).asKeyValuePairs
			).setn(\env, Env([0, 1, 1, 0], [0, 1, 0]))
		};
		if (~pat05efxgate.coin) {
			"comb".postln;
			states = Pseq(values.states.clump(8)[~pat05xy.next], inf).asStream;
			Synth.after(~agrp, \pat05cmb, [\out, ~abus, \in, ~pat05efx] 
				++ ~pat05efxmap.collect({|spec| spec.map(states.next) }).asKeyValuePairs
			).setn(\env, Env([0, 1, 1, 0], [0, 1, 0]))
			.setn(\pch, Array.geom(4, 35/36, 36/35))
			.setn(\tds, Array.series(4, 0.0, pi/66))
		}
	};
	if (~pat05index == ~pat05next.lastIndex) { 
		~pat05next = [Array.fill(4, { [1, 0].wchoose([0.9, 0.1]) }), (0 ! 4)].lace(16) 
	};
	~pat05index = (~pat05index + 1).wrap(0, ~pat05next.lastIndex);
});	

{ ~fx.removeStatesFunction(\pat05) }