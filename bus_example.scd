(
~fx = Bus.audio;

SynthDef(\bleep, {
	arg send = 0.5;
	var pulse = Impulse.kr(1/2);
	var pitch = TExpRand.kr(60, 72, pulse);
	var env = EnvGen.kr(Env.perc(0.01, 0.2), pulse);
	var sound = SinOsc.ar(pitch.midicps, 0, env) !2;

	Out.ar(0, sound*0.5);
	Out.ar(~fx, sound*send);
}).add;

SynthDef(\delay, {
	arg delaytime = 0.1, wet = -5, fb = -5, lag = 2;
	var sound, delay;
	sound = In.ar(~fx);
	sound = sound + (LocalIn.ar(2) * fb.dbamp);
	delay = DelayC.ar(sound, 2, VarLag.kr(delaytime, lag));
	LocalOut.ar(delay);
	delay = sound + (delay * wet.dbamp);

	Out.ar(0, delay);
}).add
)


a = Synth(\delay);
b = Synth(\bleep);
b.set(\send, 0.5);
a.set(\fb, -0.3, \delaytime, 0.5, \lag, 10)
a.set(\fb, -8, \delaytime, 0.8, \lag, 5)