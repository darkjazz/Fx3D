~pat04bus = Bus.control;

~pat04seq = Pseq([
	[3, 6, 3, 3, 3, 6, 3, 3, 12, 3, 6, 3, 6, 6, 3, 3],
	[3, 3, 3, 6, 3, 3, 6, 3, 3, 3, 3, 12, 3, 3, 3, 3],
	[3, 3, 3, 3, 3, 3, 3, 9, 3, 9, 3, 9, 3, 3, 3, 3],
	[12, 3, 3, 3, 9, 3, 3, 3, 6, 3, 3, 3, 12, 3, 6, 3],
	[3, 12, 3, 3, 3, 6, 3, 3, 3, 12, 3, 3, 6, 12, 3, 3]
], inf).asStream;

~pat04map = (
	hfq: ExponentialWarp(ControlSpec(500.0, 8000.0, step: 500.0)),
	xang: ControlSpec(pi, -pi),
	yang: ControlSpec(pi, -pi),
	zang: ControlSpec(pi, -pi)
);

~pat04synth = Synth.tail(~agrp, \pat04play, [\out, ~abus, \intr, ~pat04bus, \frq, 8000.0, 
		\dur, 20, \amp, 0.4, \room, 1, \rtm, 0.5, \early, 0.5, \tail, 0.0, \hfq, 2000,
		\xang, 0, \yang, 0, \zang, 0 
	])
	.setn(\env, Env([0.001, 1.0, 1.0, 0.001], [0.3, 0.4, 0.3], \sine, 2, 1))
	.setn(\pulse, ~pat04seq.next );

~pat04count = 0;	
~fx.addStatesFunction(\pat04, {|values|
	var argstr = Pseq([values.avglbf, values.avgrbb, values.avgltf, values.avgrtb], 1).asStream;
	~pat04bus.value = 1;
	if (~pat04count == 32)
	{
		~pat04count = 0;
	}
	{
		~pat04count = ~pat04count + 1;
	};
	~pat04synth.set(*~pat04map.collect(_.map(argstr.next)).asKeyValuePairs)
});


{
	~pat04synth.set(\gate, -5);
	~fx.removeStatesFunction(\pat04);
	~pat04bus.free;
	~pat04bus = nil;
	~pat04synth = nil;
}