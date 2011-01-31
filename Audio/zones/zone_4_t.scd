(
~loadAts = false;
~localDecoder = true;
~stereoOutput = true;
"/Users/alo/Development/Fx3D/Audio/zones/initiate_zones.rtf".load;
)

(
SynthDef(\zone4_waveTerrain, {|out, buffer, aa, ab, ac, ad,
		pxa, pya, pxb, pyb, pxc, pyc, pxd, pyd, xang, yang, zang|
	var a, b, c, d, w, x, y, z, raL, raR, rcL, rcR;
	a = WaveTerrain.ar(buffer, LFSaw.ar(pxa).range(0.0, 1.0), LFSaw.ar(pya).range(0.0, 1.0), 16, 16) * aa;
	b = WaveTerrain.ar(buffer, LFSaw.ar(pxb).range(0.0, 1.0), LFSaw.ar(pyb).range(0.0, 1.0), 16, 16) * ab;
	c = WaveTerrain.ar(buffer, LFSaw.ar(pxc).range(0.0, 1.0), LFSaw.ar(pyc).range(0.0, 1.0), 16, 16) * ac;
	d = WaveTerrain.ar(buffer, LFSaw.ar(pxd).range(0.0, 1.0), LFSaw.ar(pyd).range(0.0, 1.0), 16, 16) * ad;
	#raL, raR = PitchShift.ar(GVerb.ar(a+Dust2.ar(ab.linlin(0, 1, 10, 80)), 10, 15, 0.5, 0.5, 15, 0, 0.06, 0.1), 0.1, 0.5);
	#rcL, rcR = PitchShift.ar(GVerb.ar(c+Dust2.ar(ad.linlin(0, 1, 10, 80)), 10, 15, 0.5, 0.5, 15, 0, 0.06, 0.1), 0.1, 2.0);
	a = Compander.ar(a**0.5, a**0.5, 0.95, 0.1, 0.1);
	b = Compander.ar(b**0.5, b**0.5, 0.95, 0.1, 0.1);
	c = Compander.ar(c**0.5, c**0.5, 0.95, 0.1, 0.1);
	d = Compander.ar(d**0.5, d**0.5, 0.95, 0.1, 0.1);
	#a, b, c, d = [a, b, c, d] + [raL, raR, rcL, rcR];
	#w, x, y, z = A2B.ar(a, b, c, d);
	Out.ar(out, AtkRotateXYZ.ar(w, x, y, z, xang, yang, zang))
}).add;


SynthDef(\zone4_rawOsc, {|out, delay, freq|
	var bufs, ptrs, sig, deltimes, trigs;
	deltimes = [0, 1 / delay * 0.5, 1 / delay];
	bufs = ArrayControl.kr(\bufnums, 3, 0);
	ptrs = Array.fill(3, {|i| LFSaw.ar(freq, 1, 0.5, 0.5) });
	trigs = Array.fill(3, {|i| DelayN.kr(Impulse.kr(delay * (2 / 3)), deltimes@i, deltimes@i) });
	sig = Mix.fill(3, {|i| 
		BufRd.ar(1, bufs@i, ptrs@i) * 
			EnvGen.kr(
				Env([0.0,1.0,1.0,0.0],[0.3,0.4,0.3],\sine, 0, 3), 
				trigs.rotate(-1)@i, timeScale: 1.0 / delay
			)
	});
	Out.ar(0, sig.dup)
}).add;

SynthDef(\rough, {|dur=1|
	var sig, frqs;
	frqs = Array.geom(7, pi**pi*1.5, 2**(1/5));
	sig = Mix(
		Resonz.ar(
			LFSaw.ar(
				frqs, 
				(0,2/7..1.9),
				1,
				LFNoise0.kr(64).range(0, 1)
			), 
			frqs+1,
			5/(frqs+1)
		)
	).distort * EnvGen.kr(
		Env([0.001, 2.0, 0.1, 1.0, 0.001], [0.01, 0.33, 0.33, 0.33], \sine), 
		timeScale: dur, 
		doneAction: 2 
	);
	sig = Compander.ar(sig, sig, 0.99, 0.5, 0.1, 0.01, 0.01) ;
	Out.ar(0, sig.dup)
}).add;
)
(
~glmap = (
	aa: ExponentialWarp(ControlSpec(8.0, 0.5)),
	ab: ExponentialWarp(ControlSpec(8.0, 0.5)),
	ac: ExponentialWarp(ControlSpec(8.0, 0.5)),
	ad: ExponentialWarp(ControlSpec(8.0, 0.5)),
	xang: CyclicWarp(ControlSpec(-pi, pi)),
	yang: CyclicWarp(ControlSpec(-pi, pi)),
	zang: CyclicWarp(ControlSpec(-pi, pi))
);

~stmap = (
	
)

)

CuspL

~fx = Fx3D().makeOglGui

~fx.startFx

//~fx.addRenewResponder;

~fx.addGlobalsResponder;

~fx.addStatesResponder;

~rawBufs = ({ Buffer.sendCollection(s, Array.rand(256, -1.0, 1.0)) } ! 3)

~synth = Synth(\zone4_rawOsc, [\out, 0, \delay, 0.75, \freq, 10]);

r = Routine({
	i = 0;
	inf.do({
		~rawBufs.wrapAt(i).sendCollection(Array.rand(256, -1.0, 1.0));
		(1/6).wait;
		i = i + 1;
	})
	
})

r.stop

~synth.free

//~fx.addRenewFunction(\f1, { Synth(\rough, [0.25, 0.5, 1.0].wchoose([0.5, 0.3, 0.2])) })

~fx.addGlobalsFunction(\f1, {|invalues|
	if (~waves.notNil) {
		~waves.set(
			\aa, ~glmap[\aa].map(invalues.avglbf),
			\ab, ~glmap[\ab].map(invalues.avgrbf),
			\ac, ~glmap[\ac].map(invalues.avgrbb), 
			\ad, ~glmap[\ad].map(invalues.avglbb),
			\xang, ~glmap[\xang].map(invalues.avgltf),
			\yang, ~glmap[\yang].map(invalues.avgrtf),
			\zang, ~glmap[\zang].map(invalues.avgrtb)
		)
	}
});

~fx.addStatesFunction(\f1, {|values| values.postln })


~fx.addStatesFunction(\f1, {|values| 
	if (~buffer.isNil) { ~buffer = Buffer.sendCollection(s, values.states * 2 - 1, 1) }
	{ ~buffer.sendCollection(values.states * 2 - 1) };
})

if (~waves.notNil) {
	~waves.set(
		\pxa, 10,
		\pya, 200,
		\pxb, 17,
		\pyb, 2,
		\pxc, 41,
		\pyc, 39,
		\pxd, 300,
		\pyd, 31
	)
}


~waves = Synth(\zone4_waveTerrain, [\out, ~abus, \buffer, ~buffer, 
		\pxa, 10,
		\pya, 200,
		\pxb, 17,
		\pyb, 2,
		\pxc, 41,
		\pyc, 39,
		\pxd, 300,
		\pyd, 31
	]);

~waves.free;
~waves = nil

~fx.removeStatesFunction(\f1);

~fx.removeRenewFunction(\f1);


~fx.invalues.states.size
