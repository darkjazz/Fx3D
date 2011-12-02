Routine({	
	
	var funcs, makedef, envs, bufs, names, name;
	
	names = Pseq([10, 11, 13, 16, 18, 23, 25, 29].collect({|num| "fxloop_" ++ num ++ ".aif" }), 1).asStream;

	name = names.next;
	
	bufs = Array();
	
	~loops.do({|loop|
		if (name.notNil) {
			if (loop.path.contains(name))
			{
				bufs = bufs.add(loop);
				name = names.next;
			}
		}
	});	
	
	funcs = (
		\zz: { Warp1.ar(1, bufs[0], LFSaw.kr(0.5, 1).range(0, 1), 0.125, 0.1, -1, 4) ** 0.5 },
		\yy: { Warp1.ar(1, bufs[1], LFSaw.kr(1.0, 1).range(0, 1), 0.5, 0.05, -1, 2) ** 0.5 },
		\xx: { Warp1.ar(1, bufs[2], LFSaw.kr(0.25, 1).range(0, 1), 0.25, 0.1, -1, 4) ** 0.5 },
		\ww: { Warp1.ar(1, bufs[3], LFSaw.kr(1.0, 1).range(0, 1), 0.5, 0.05, -1, 6) ** 0.5 },
		\vv: { Warp1.ar(1, bufs[4], LFSaw.kr(0.5, 1).range(0, 1), 0.125, 0.1, -1, 4) ** 0.5 },
		\uu: { Warp1.ar(1, bufs[5], LFSaw.kr(2.0, 1).range(0, 1), 0.25, 0.05, -1, 2) ** 0.5 },
		\tt: { Warp1.ar(1, bufs[6], LFSaw.kr(0.5, 1).range(0, 1), 0.5, 0.1, -1, 4) ** 0.5 },
		\ss: { Warp1.ar(1, bufs[7], LFSaw.kr(1.0, 1).range(0, 1), 0.125, 0.05, -1, 6) ** 0.5 }
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
//		\ss: Env.perc(curve: 4),
//		\tt: Env.perc(curve: -8),
//		\uu: Env([0, 1, 1, 0], [0.3, 0.4, 0.3]),
//		\vv: Env.perc(curve: -2),
//		\ww: Env([0.01, 1.0, 0.001], [0.8, 0.2]),
		\default: Env.perc(curve: 4)
	);	
	
	funcs.keysValuesDo({|name, func, env|
		makedef.value(name, func, envs[name] ? envs[\default])
	});
		
	SynthDef(\pat00rev, {|out, in|
		var input, sig, dels, w, x, y, z;
		dels = Array.geom(4, 0.01, 1+5.sqrt/2);
		input = In.ar(in);
		sig = GVerb.ar(input + Dust2.ar(LFNoise0.kr(9.reciprocal).range(10, 100).round(10)), 
			100, 5, drylevel: 0, earlyreflevel: 0.5, taillevel: 1.0, maxroomsize: 100);
		#w, x, y, z = A2B.ar(*Array.fill(4, {|i| DelayN.ar(sig.wrapAt(i), 0.1, dels[i]) }));
		Out.ar(out, 
			AtkRotateXYZ.ar(w, x, y, z, 
				LFSaw.kr(2.25.reciprocal).range(-pi, pi),
				LFSaw.kr(4.5.reciprocal).range(-pi, pi),
				LFSaw.kr(7.reciprocal).range(-pi, pi)
			) * 0
		)
	}).add;
	
	Server.default.sync;
	
	~pat00pats = (
		\zz: [1, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  1, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0],
		\yy: [0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 1, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0],
		\xx: [0, 0, 0, 0, 1, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0],
		\ww: [0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  1, 0, 0, 0, 1, 0, 0, 0],
		\vv: [0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 1, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0],
		\uu: [0, 0, 0, 0, 0, 0, 0, 0,  1, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0],
		\tt: [0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  1, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0],
		\ss: [0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 1, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  1, 0, 0, 0, 0, 0, 0, 0]
	);
	
	~pat00args = (
		\zz: (\dur: ControlSpec(0.1, 0.1), \emp: ControlSpec(0.01, 0.01),
			\xang: ControlSpec(-0.5pi, 0.5pi, step: 0.25pi), \yang: ControlSpec(-0.25pi, 0.25pi), \zang: ControlSpec(-0.25pi, 0.25pi)),
		\yy: (\dur: ControlSpec(0.25, 0.25), \emp: ControlSpec(0.0, 0.0), 
			\xang: ControlSpec(-pi, pi, step: 0.25pi), \yang: ControlSpec(0.5pi, 0.5pi), \zang: ControlSpec(0.5pi, 0.5pi)),
		\xx: (\dur: ControlSpec(0.2, 0.2), \emp: ControlSpec(0.1, 0.1), 
			\xang: ControlSpec(-pi, pi), \yang: ControlSpec(pi, pi), \zang: ControlSpec(pi, pi)),
		\ww: (\dur: ControlSpec(0.1, 0.1), \emp: ControlSpec(0.0, 0.0), 
			\xang: ControlSpec(pi, -pi), \yang: ControlSpec(-0.5pi, -0.5pi), \zang: ControlSpec(-0.5pi, -0.5pi)),
		\vv: (\dur: ControlSpec(0.2, 0.2), \emp: ControlSpec(0.05, 0.05),
			\xang: ControlSpec(pi, -pi), \yang: ControlSpec(-pi, -pi), \zang: ControlSpec(-pi, -pi)),
		\uu: (\dur: ControlSpec(0.1, 0.1), \emp: ControlSpec(0.0, 0.0),
			\xang: ControlSpec(-pi, pi), \yang: ControlSpec(-pi, pi), \zang: ControlSpec(-pi, pi)),
		\tt: (\dur: ControlSpec(0.3, 0.3), \emp: ControlSpec(0.1, 0.1),
			\xang: ControlSpec(-pi, pi), \yang: ControlSpec(-pi, pi), \zang: ControlSpec(-pi, pi)),
		\ss: (\dur: ControlSpec(0.1, 0.1), \emp: ControlSpec(0.0, 0.0),
			\xang: ControlSpec(-pi, pi), \yang: ControlSpec(-pi, pi), \zang: ControlSpec(-pi, pi))
	);
		
	~pat00amps = ~pat00pats.collect({ (active: 0, amp: 0) });
		
	~pat00strm = ~pat00pats.collect({|pt,ky| Pdefn(ky,Pseq(pt, inf)).count(32).asStream });
	
	~pat00counter = 0;
	
	~pat00efxbus = Bus.audio;
	
	~pat00efx = Synth.tail(~agrp, \pat00rev, [\out, ~abus, \in, ~pat00efxbus]);
		
	~fx.addTriggerFunction(\pat00tr, {
		~pat00strm.keysValuesDo({|name, stream|
			if ((stream.next == 1) and: {~pat00amps[name].active > 0})
			{
				Synth.head(~agrp, name, [\out, ~abus, \efx, ~pat00efxbus, \amp, ~pat00amps[name].amp] 
					++ ~pat00args[name].collect(_.map(1.0.rand)).asKeyValuePairs)
			};
			~fx.visualdict.globals[\alpha] = rrand(0.5, 1.0).round(0.25);
			~fx.sendCurrentSettings
		});
		
	});
	~pat00ampctr = FaderWarp();
	~pat00font = Font("Courier", 10);
	~pat00win = Window("_o_o_o_o 03 o_o_o_o_", Rect(10, 500, 32*20+200,~pat00pats.size*20+20)).background_(Color.grey(0.1)).alpha_(0.99).front;
	#[zz,yy,xx,ww,vv,uu,tt,ss].do({|key, i|
		StaticText(~pat00win, Rect(5,i*20+5,20,20))
			.align_(\center)
			.font_(~pat00font)
			.stringColor_(Color.grey(0.7))
			.string_(key.asString);
		~pat00pats[key].do({|onoff,j|
			Button(~pat00win, Rect(j*20+30,i*20+5,20,20))
				.font_(~pat00font)
				.states_([["-", Color.grey(0.5), Color.grey(0.3)],["o", Color.green, Color.grey(0.6)]])
				.value_(onoff)
				.action_({|btn|
					~pat00pats[key][j] = btn.value;
					Pdefn(key, Pseq(~pat00pats[key], inf));
				})
		});
		Button(~pat00win, Rect(670,i*20+5,30,20))
			.font_(~pat00font)
			.states_([[\off, Color.grey(0.5), Color.grey(0.2)], [\on, Color.green, Color.grey(0.6)]])
			.action_({|btn|
				~pat00amps[key].active = btn.value
			});
		SmoothSlider(~pat00win, Rect(705,i*20+5,100,18))
			.font_(~pat00font)
			.string_("0")
			.stringColor_(Color.grey(0.5))
			.action_({|slider|
				~pat00amps[key].amp = ~pat00ampctr.map(slider.value);
				slider.string_(~pat00amps[key].amp.round(0.01).asString)
			})
	})
		
}).play(AppClock);

{
	~fx.removeTriggerFunction(\pat00tr);
	~pat00win.close;
	~pat00win = nil;
	~pat00efx.free;
	~pat00efx = nil;
	~pat00efxbus.free;
	~pat00efxbus = nil;
}
