Routine({	
	
	var funcs, makedef, envs;
	
	funcs = (
		\kc: { Mix(SinOsc.ar([40, 51, 63], 0.5pi)) },
		\cl: { Impulse.ar(1, 10).clip(-0.9, 0.9) },
		\hi: { PinkNoise.ar.clip(-0.9, 0.9) },
		\sw: { Mix(LFSaw.ar([60, 61] + LFSaw.ar([1, 8]).range(20, 80))).clip(-0.9, 0.9) },
		\ds: { BPF.ar(BrownNoise.ar(10).clip(-0.9, 0.9), 200, 0.2, 10) },
		\nf: { VarSaw.ar(IRand(10000, 15000).round(5000), 0.25, 0.01, 20).clip(-0.9, 0.9) },
		\pm: { LFPulse.ar(20 + LFPulse.ar(10)).distort },
		\dd: { Dust2.ar(200, 2, SinOsc.ar(Rand(8000, 16000).round(2**(1/5)))) }
	);
	
	makedef = {|name, func, env|
		SynthDef(name, {|out, efx, dur = 0.1, amp = 1.0, emp = 0.0, xang, yang, zang| 
			var sig;
			sig = SynthDef.wrap(func) * EnvGen.kr(env, levelScale: amp, timeScale: dur, doneAction: 2);
			Out.ar(efx, sig * emp);
			Out.ar(out, BFEncode1.ar(sig, xang, yang)) 
		}).add;		
	};
	
	envs = (
		\nf: Env.perc(curve: -8),
		\pm: Env([0, 1, 1, 0], [0.3, 0.4, 0.3]),
		\dd: Env.perc(curve: -2),
		\default: Env([1, 1, 0], [1, 0])
	);	
	
	funcs.keysValuesDo({|name, func, env|
		makedef.value(name, func, envs[name] ? envs[\default])
	});
		
	SynthDef(\pat01rev, {|out, in|
		var input, sig, dels, w, x, y, z;
		dels = Array.geom(4, 0.01, 1+5.sqrt/2);
		input = In.ar(in);
		sig = RHPF.ar(GVerb.ar(input, 100, 10, drylevel: 0, earlyreflevel: 0.5, taillevel: 1.0, maxroomsize: 100), [1000.0, 5000.0], [2, 3]);
		#w, x, y, z = A2B.ar(*Array.fill(4, {|i| DelayN.ar(sig.wrapAt(i), 0.1, dels[i]) }));
		Out.ar(out, 
			AtkRotateXYZ.ar(w, x, y, z, 
				LFNoise1.kr(2.25.reciprocal).range(-pi, pi),
				LFNoise2.kr(4.5.reciprocal).range(-pi, pi),
				LFNoise0.kr(7.reciprocal).range(-pi, pi)
			)
		)
	}).add;
	
	Server.default.sync;
	
	~pat01pats = (
		\kc: [1, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 1, 0, 0, 0],
		\cl: [0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  1, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0],
		\hi: [0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  1, 0, 0, 0, 0, 0, 0, 0],
		\sw: [0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 1, 0],
		\ds: [0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 1, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0],
		\nf: [0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 1, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0],
		\pm: [0, 0, 0, 0, 1, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0],
		\dd: [0, 0, 0, 0, 0, 0, 0, 1,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0]
	);
	
	~pat01args = (
		\kc: (\dur: ControlSpec(0.05, 0.1), \emp: ControlSpec(0.0, 0.0),
			\xang: ControlSpec(-0.5pi, 0.5pi, step: 0.25pi), \yang: ControlSpec(-0.25pi, 0.25pi), \zang: ControlSpec(-0.25pi, 0.25pi)),
		\cl: (\dur: ControlSpec(0.001, 0.001), \emp: ControlSpec(0.0, 0.0), 
			\xang: ControlSpec(-pi, pi, step: 0.25pi), \yang: ControlSpec(0.5pi, 0.5pi), \zang: ControlSpec(0.5pi, 0.5pi)),
		\hi: (\dur: ControlSpec(0.025, 0.025), \emp: ControlSpec(0.0, 0.0), 
			\xang: ControlSpec(-pi, pi), \yang: ControlSpec(pi, pi), \zang: ControlSpec(pi, pi)),
		\sw: (\dur: ControlSpec(0.01, 0.1), \emp: ControlSpec(0.0, 0.0), 
			\xang: ControlSpec(pi, -pi), \yang: ControlSpec(-0.5pi, -0.5pi), \zang: ControlSpec(-0.5pi, -0.5pi)),
		\ds: (\dur: ControlSpec(0.01, 0.01), \emp: ControlSpec(0.0, 0.0),
			\xang: ControlSpec(pi, -pi), \yang: ControlSpec(-pi, -pi), \zang: ControlSpec(-pi, -pi)),
		\nf: (\dur: ControlSpec(0.01, 0.01), \emp: ControlSpec(0.2, 0.4),
			\xang: ControlSpec(-pi, pi), \yang: ControlSpec(-pi, pi), \zang: ControlSpec(-pi, pi)),
		\pm: (\dur: ControlSpec(0.2, 0.2), \emp: ControlSpec(0.0, 0.0),
			\xang: ControlSpec(-pi, pi), \yang: ControlSpec(-pi, pi), \zang: ControlSpec(-pi, pi)),
		\dd: (\dur: ControlSpec(0.1, 0.1), \emp: ControlSpec(0.0, 0.0),
			\xang: ControlSpec(-pi, pi), \yang: ControlSpec(-pi, pi), \zang: ControlSpec(-pi, pi))
	);
		
	~pat01amps = ~pat01pats.collect({ (active: 0, amp: 0) });
		
	~pat01strm = ~pat01pats.collect({|pt,ky| Pdefn(ky,Pseq(pt, inf)).count(32).asStream });
	
	~pat01counter = 0;
	
	~pat01efxbus = Bus.audio;
	
	~pat01efx = Synth.tail(~agrp, \pat01rev, [\out, ~abus, \in, ~pat01efxbus]);
		
	~fx.addTriggerFunction(\pat01tr, {
		~pat01strm.keysValuesDo({|name, stream|
			if ((stream.next == 1) and: {~pat01amps[name].active > 0})
			{
				Synth.head(~agrp, name, [\out, ~abus, \efx, ~pat01efxbus, \amp, ~pat01amps[name].amp] 
					++ ~pat01args[name].collect(_.map(1.0.rand)).asKeyValuePairs)
			};
		});
		
	});
	~pat01ampctr = FaderWarp();
	~pat01font = Font("Courier", 10);
	~pat01win = Window("_o_o_o_o 03 o_o_o_o_", Rect(10, 500, 32*20+200,~pat01pats.size*20+20)).background_(Color.grey(0.1)).alpha_(0.99).front;
	#[kc,cl,hi,sw,ds,nf,pm,dd].do({|key, i|
		StaticText(~pat01win, Rect(5,i*20+5,20,20))
			.align_(\center)
			.font_(~pat01font)
			.stringColor_(Color.grey(0.7))
			.string_(key.asString);
		~pat01pats[key].do({|onoff,j|
			Button(~pat01win, Rect(j*20+30,i*20+5,20,20))
				.font_(~pat01font)
				.states_([["-", Color.grey(0.5), Color.grey(0.3)],["o", Color.green, Color.grey(0.6)]])
				.value_(onoff)
				.action_({|btn|
					~pat01pats[key][j] = btn.value;
					Pdefn(key, Pseq(~pat01pats[key], inf));
				})
		});
		Button(~pat01win, Rect(670,i*20+5,30,20))
			.font_(~pat01font)
			.states_([[\off, Color.grey(0.5), Color.grey(0.2)], [\on, Color.green, Color.grey(0.6)]])
			.action_({|btn|
				~pat01amps[key].active = btn.value
			});
		SmoothSlider(~pat01win, Rect(705,i*20+5,100,18))
			.font_(~pat01font)
			.string_("0")
			.stringColor_(Color.grey(0.5))
			.action_({|slider|
				~pat01amps[key].amp = ~pat01ampctr.map(slider.value);
				slider.string_(~pat01amps[key].amp.round(0.01).asString)
			})
	})
		
}).play(AppClock);

{
	~fx.removeTriggerFunction(\pat01tr);
	~pat01win.close;
	~pat01win = nil;
	~pat01efx.free;
	~pat01efx = nil;
	~pat01efxbus.free;
	~pat01efxbus = nil;
}
