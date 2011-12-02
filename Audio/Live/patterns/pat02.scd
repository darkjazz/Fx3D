Routine({	
	
	var funcs, makedef, envs;
	
	funcs = (
		\aa: { Mix(SinOsc.ar([20, 25, 30, 35], 0.5pi)) },
		\bb: { LFNoise0.ar(1000 + LFNoise0.ar(2500, 10).range(50, 200), 200).tanh },
		\cc: { Mix(SinOsc.ar(SinOsc.ar([1000, 100]).range(20, 200), 0.5pi)) },
		\dd: { Mix(SinOsc.ar(SinOsc.ar([1000, 5000]).range(2000, 8000), 0.5pi)) },
		\ee: { Impulse.ar(1, 100).clip(-0.9, 0.9) + Reverb.ar(Dust2.ar(100, 2),50).tanh },
		\ff: { LFSaw.ar(20, 0.5, LFNoise0.ar(10000).range(10, 100)).distort },
		\gg: { Pulse.ar(10, 0.1, 1000).clip(-0.9, 0.9) * 10 },
		\hh: { SineShaper.ar(SinOsc.ar(200, 0, 200), 0.5) }
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
		\aa: Env.perc(curve: 4),
		\cc: Env.perc(curve: -8),
		\dd: Env([0, 1, 1, 0], [0.3, 0.4, 0.3]),
		\ee: Env.perc(curve: -2),
		\ff: Env([0.01, 1.0, 0.001], [0.8, 0.2]),
		\default: Env([1, 1, 0], [1, 0])
	);	
	
	funcs.keysValuesDo({|name, func, env|
		makedef.value(name, func, envs[name] ? envs[\default])
	});
		
	SynthDef(\pat02rev, {|out, in|
		var input, sig, dels, w, x, y, z;
		dels = Array.geom(4, 0.01, 1+5.sqrt/2);
		input = In.ar(in);
		sig = GVerb.ar(input, 30, 5, drylevel: 0, earlyreflevel: 1.0, taillevel: 0.5, maxroomsize: 30);
		#w, x, y, z = A2B.ar(*Array.fill(4, {|i| DelayN.ar(sig.wrapAt(i), 0.1, dels[i]) }));
		Out.ar(out, 
			AtkRotateXYZ.ar(w, x, y, z, 
				LFSaw.kr(2.25.reciprocal).range(-pi, pi),
				LFSaw.kr(4.5.reciprocal).range(-pi, pi),
				LFSaw.kr(7.reciprocal).range(-pi, pi)
			)
		)
	}).add;
	
	Server.default.sync;
	
	~pat02pats = (
		\aa: [0, 0, 0, 1, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  1, 0, 0, 0, 0, 0, 0, 0],
		\bb: [1, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0],
		\cc: [1, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 1, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0],
		\dd: [0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 1, 0, 0, 0],
		\ee: [0, 0, 0, 0, 1, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 1, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0],
		\ff: [0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 1, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0],
		\gg: [0, 0, 0, 0, 1, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0],
		\hh: [0, 0, 0, 0, 0, 0, 0, 1,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 1, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0]
	);
	
	~pat02args = (
		\aa: (\dur: ControlSpec(0.1, 0.3), \emp: ControlSpec(0.0, 0.0),
			\xang: ControlSpec(-0.5pi, 0.5pi, step: 0.25pi), \yang: ControlSpec(-0.25pi, 0.25pi), \zang: ControlSpec(-0.25pi, 0.25pi)),
		\bb: (\dur: ControlSpec(0.1, 0.2), \emp: ControlSpec(0.0, 0.0), 
			\xang: ControlSpec(-pi, pi, step: 0.25pi), \yang: ControlSpec(0.5pi, 0.5pi), \zang: ControlSpec(0.5pi, 0.5pi)),
		\cc: (\dur: ControlSpec(0.1, 0.25), \emp: ControlSpec(0.0, 0.0), 
			\xang: ControlSpec(-pi, pi), \yang: ControlSpec(pi, pi), \zang: ControlSpec(pi, pi)),
		\dd: (\dur: ControlSpec(0.01, 0.01), \emp: ControlSpec(0.1, 0.1), 
			\xang: ControlSpec(pi, -pi), \yang: ControlSpec(-0.5pi, -0.5pi), \zang: ControlSpec(-0.5pi, -0.5pi)),
		\ee: (\dur: ControlSpec(0.1, 0.2), \emp: ControlSpec(0.0, 0.0),
			\xang: ControlSpec(pi, -pi), \yang: ControlSpec(-pi, -pi), \zang: ControlSpec(-pi, -pi)),
		\ff: (\dur: ControlSpec(0.06, 0.09), \emp: ControlSpec(0.2, 0.4),
			\xang: ControlSpec(-pi, pi), \yang: ControlSpec(-pi, pi), \zang: ControlSpec(-pi, pi)),
		\gg: (\dur: ControlSpec(0.2, 0.2), \emp: ControlSpec(0.0, 0.0),
			\xang: ControlSpec(-pi, pi), \yang: ControlSpec(-pi, pi), \zang: ControlSpec(-pi, pi)),
		\hh: (\dur: ControlSpec(0.1, 0.1), \emp: ControlSpec(0.05, 0.1),
			\xang: ControlSpec(-pi, pi), \yang: ControlSpec(-pi, pi), \zang: ControlSpec(-pi, pi))
	);
		
	~pat02amps = ~pat02pats.collect({ (active: 0, amp: 0) });
		
	~pat02strm = ~pat02pats.collect({|pt,ky| Pdefn(ky,Pseq(pt, inf)).count(32).asStream });
	
	~pat02counter = 0;
	
	~pat02efxbus = Bus.audio;
	
	~pat02efx = Synth.tail(~agrp, \pat02rev, [\out, ~abus, \in, ~pat02efxbus]);
		
	~fx.addTriggerFunction(\pat02tr, {
		~pat02strm.keysValuesDo({|name, stream|
			if ((stream.next == 1) and: {~pat02amps[name].active > 0})
			{
				Synth.head(~agrp, name, [\out, ~abus, \efx, ~pat02efxbus, \amp, ~pat02amps[name].amp] 
					++ ~pat02args[name].collect(_.map(1.0.rand)).asKeyValuePairs)
			};
			~fx.visualdict.globals[\alpha] = rrand(0.5, 1.0).round(0.25);
			~fx.sendCurrentSettings
		});
		
	});
	~pat02ampctr = FaderWarp();
	~pat02font = Font("Courier", 10);
	~pat02win = Window("_o_o_o_o 03 o_o_o_o_", Rect(10, 500, 32*20+200,~pat02pats.size*20+20)).background_(Color.grey(0.1)).alpha_(0.99).front;
	#[aa,bb,cc,dd,ee,ff,gg,hh].do({|key, i|
		StaticText(~pat02win, Rect(5,i*20+5,20,20))
			.align_(\center)
			.font_(~pat02font)
			.stringColor_(Color.grey(0.7))
			.string_(key.asString);
		~pat02pats[key].do({|onoff,j|
			Button(~pat02win, Rect(j*20+30,i*20+5,20,20))
				.font_(~pat02font)
				.states_([["-", Color.grey(0.5), Color.grey(0.3)],["o", Color.green, Color.grey(0.6)]])
				.value_(onoff)
				.action_({|btn|
					~pat02pats[key][j] = btn.value;
					Pdefn(key, Pseq(~pat02pats[key], inf));
				})
		});
		Button(~pat02win, Rect(670,i*20+5,30,20))
			.font_(~pat02font)
			.states_([[\off, Color.grey(0.5), Color.grey(0.2)], [\on, Color.green, Color.grey(0.6)]])
			.action_({|btn|
				~pat02amps[key].active = btn.value
			});
		SmoothSlider(~pat02win, Rect(705,i*20+5,100,18))
			.font_(~pat02font)
			.string_("0")
			.stringColor_(Color.grey(0.5))
			.action_({|slider|
				~pat02amps[key].amp = ~pat02ampctr.map(slider.value);
				slider.string_(~pat02amps[key].amp.round(0.01).asString)
			})
	})
		
}).play(AppClock);

{
	~fx.removeTriggerFunction(\pat02tr);
	~pat02win.close;
	~pat02win = nil;
	~pat02efx.free;
	~pat02efx = nil;
	~pat02efxbus.free;
	~pat02efxbus = nil;
}
