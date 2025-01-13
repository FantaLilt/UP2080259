(
~bfx = Bus.audio(s, 2);
~cfx = Bus.audio(s, 2);
~kfx = Bus.audio(s, 2);
~sfx = Bus.audio(s, 2);

b = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "nin_audio/bass4.wav");
c = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "nin_audio/drums8.wav");
d = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "nin_audio/gtr8.wav");
e = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "nin_audio/vox8.wav");



SynthDef(\multisample, { arg bassvol = 1, drumsvol = 1, gtrvol = 1, voxvol = 1, rate = 1;
	var bass = PlayBuf.ar(2, b.bufnum, BufRateScale.kr(b.bufnum)*rate, loop: 1)*bassvol !2;
	var drums = PlayBuf.ar(2, c.bufnum, BufRateScale.kr(c.bufnum)*rate, loop: 1)*drumsvol !2;
	var gtr = PlayBuf.ar(2, d.bufnum, BufRateScale.kr(d.bufnum)*rate, loop: 1)*gtrvol !2;
	var vox = PlayBuf.ar(2, e.bufnum, BufRateScale.kr(e.bufnum)*rate, loop: 1)*voxvol !2;

	Out.ar(0, bass*0.5);
	Out.ar(~bfx, bass*0.5);
	Out.ar(0, drums*0.5);
	Out.ar(~cfx, drums*0.5);
	Out.ar(0, gtr*0.5);
	Out.ar(~kfx, gtr*0.5);
	Out.ar(0, vox*0.5);
	Out.ar(~sfx, vox*0.5);

}).add;

SynthDef(\bdelay, {
	arg delaytime = 0.1, wet = 0, fb = 1, lag = 2;
	var sound, delay;
	sound = In.ar(~bfx);
	delay = CombL.ar(sound, 1, Lag.kr(delaytime, lag), fb, wet);

	Out.ar(0, delay);
}).add;

SynthDef(\cdelay, {
	arg delaytime = 0.1, wet = 0, fb = 1, lag = 2;
	var sound, delay;
	sound = In.ar(~cfx);
	delay = CombL.ar(sound, 1, Lag.kr(delaytime, lag), fb, wet);

	Out.ar(0, delay);
}).add;

SynthDef(\kdelay, {
	arg delaytime = 0.1, wet = 0, fb = 1, lag = 2;
	var sound, delay;
	sound = In.ar(~kfx);
	delay = CombL.ar(sound, 1, Lag.kr(delaytime, lag), fb, wet);

	Out.ar(0, delay);
}).add;

SynthDef(\sdelay, {
	arg delaytime = 0.1, wet = 0, fb = 1, lag = 2;
	var sound, delay;
	sound = In.ar(~sfx);
	delay = CombL.ar(sound, 1, Lag.kr(delaytime, lag), fb, wet);

	Out.ar(0, delay);
}).add;

SynthDef(\lowpassfilter, { arg freq = 220;
	LPF.kr(\multisample,freq,1,0);
}).add;
)

(
var w, xy, slider1, spec1, slider2, spec2, slider3, spec3, slider4, slider5, slider6, slider7, slider8, slider9, slider10;
w = Window("I am a window", Rect(800, 500, 800, 800));

~lpf = Synth(\lowpassfilter);
~bdelay = Synth(\bdelay);
~cdelay = Synth(\cdelay);
~kdelay = Synth(\kdelay);
~sdelay = Synth(\sdelay);
~playing = Synth(\multisample);

spec1 = ControlSpec(-1, 2, \lin, 0, 1);
spec2 = ControlSpec(0.2, 1, \lin, 0, 0.5);
spec3 = ControlSpec(0, 1, \lin, 0, 0);


slider1 = EZSlider(w, Rect(250, 50, 300, 20),
	label: "Rate", controlSpec: spec1, action: {~playing.set(\rate, slider1.value)}, initVal: 1);

slider2 = EZKnob(w, Rect(400, 100, 130, 100),
	label: "Bass Delay", controlSpec: spec2, action: {~bdelay.set(\delaytime, slider2.value)}, initVal: 0.2);

slider3 = EZKnob(w, Rect(600, 100, 130, 100),
	label: "Bass Delay Wet", controlSpec: spec3, action: {~bdelay.set(\wet, slider3.value)}, initVal: 0);

slider4 = EZKnob(w, Rect(400, 200, 130, 100),
	label: "Drums Delay", controlSpec: spec2, action: {~cdelay.set(\delaytime, slider4.value)}, initVal: 0.2);

slider5 = EZKnob(w, Rect(600, 200, 130, 100),
	label: "Drums Delay Wet", controlSpec: spec3, action: {~cdelay.set(\wet, slider5.value)}, initVal: 0);

slider6 = EZKnob(w, Rect(400, 300, 130, 100),
	label: "Guitar Delay", controlSpec: spec2, action: {~kdelay.set(\delaytime, slider6.value)}, initVal: 0.2);

slider7 = EZKnob(w, Rect(600, 300, 130, 100),
	label: "Guitar Delay Wet", controlSpec: spec3, action: {~kdelay.set(\wet, slider7.value)}, initVal: 0);

slider8 = EZKnob(w, Rect(400, 400, 130, 100),
	label: "Vocal Delay", controlSpec: spec2, action: {~sdelay.set(\delaytime, slider8.value)}, initVal: 0.2);

slider9 = EZKnob(w, Rect(600, 400, 130, 100),
	label: "Vocal Delay Wet", controlSpec: spec3, action: {~sdelay.set(\wet, slider9.value)}, initVal: 0);

slider10 = EZSlider(w, Rect(10, 50, 300, 20),
	label: "LPF", controlSpec: spec1, action: {~lpf.set(\freq, slider10.value)}, initVal: 1);


xy = Slider2D(w, Rect(10, 100, 380, 380));
xy.setXY(0.5, 0.5);

xy.action={~playing.set(
	\gtrvol, xy.x,
	\drumsvol, xy.x.linlin(0, 1, 1, 0),
	\bassvol, xy.y,
	\voxvol, xy.y.linlin(0, 1, 1, 0),


)};

w.front;
w.onClose = {~playing.free};
)


-------------------------------------------------------------------------------------------------------
//current work 17/12 - delay breaks after everytime i add a new sound to it
/*
(
~fx = Bus.audio;

b = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/bass.wav");
c = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/cymbals.wav");
d = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/kick.wav");
e = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/snare.wav");



SynthDef(\multisample, { arg bassvol = 0, snarevol = 0, rate = 1;
	var bass = PlayBuf.ar(1, b.bufnum, BufRateScale.kr(b.bufnum)*rate, loop: 1)*bassvol;
	var snare = PlayBuf.ar(1, e.bufnum, BufRateScale.kr(e.bufnum)*rate, loop: 1)*snarevol;
	Out.ar(0, bass*0.5);
	Out.ar(~fx, bass*0.5);
	Out.ar(0, snare*0.5);
	Out.ar(~fx, snare*0.5);

}).add;

SynthDef(\delay, {
	arg delaytime = 0.1, wet = 0, fb = 1, lag = 2;
	var sound, delay;
	sound = In.ar(~fx);
	delay = CombL.ar(sound, 2, Lag.kr(delaytime, lag), fb, wet);

	Out.ar(0, delay);
}).add
)

(
var w, xy, slider1, spec1, slider2, spec2, slider3, spec3, slider4, slider5;
w = Window("I am a window", Rect(800, 500, 800, 400));

~delay = Synth(\delay);
~playing = Synth(\multisample);

spec1 = ControlSpec(-1, 2, \lin, 0, 1);
spec2 = ControlSpec(0.2, 1, \lin, 0, 0.5);
spec3 = ControlSpec(0, 1, \lin, 0, 0);


slider1 = EZSlider(w, Rect(400, 20, 300, 20),
	label: "Rate", controlSpec: spec1, action: {~playing.set(\rate, slider1.value)}, initVal: 1);

slider2 = EZKnob(w, Rect(400, 100, 100, 100),
	label: "Bass Delay", controlSpec: spec2, action: {~delay.set(\delaytime, slider2.value)}, initVal: 0.2);

slider3 = EZKnob(w, Rect(600, 100, 100, 100),
	label: "Bass Delay Wet", controlSpec: spec3, action: {~delay.set(\wet, slider3.value)}, initVal: 0);

slider4 = EZKnob(w, Rect(400, 200, 100, 100),
	label: "Bass Delay", controlSpec: spec2, action: {~delay.set(\delaytime, slider4.value)}, initVal: 0.2);

slider5 = EZKnob(w, Rect(600, 200, 100, 100),
	label: "Bass Delay Wet", controlSpec: spec3, action: {~delay.set(\wet, slider5.value)}, initVal: 0);



xy = Slider2D(w, Rect(10, 10, 380, 380));
xy.setXY(0.5, 0.5);

xy.action={~playing.set(
	\kickvol, xy.x,
	\cymbalsvol, xy.x.linlin(0, 1, 1, 0),
	\bassvol, xy.y,
	\snarevol, xy.y.linlin(0, 1, 1, 0),


)};

w.front;
w.onClose = {~playing.free};
)
*/
-----------------------------------------------------------------------------------------------------
// problems with sounds not syncing
/*
(
~fx = Bus.audio;

b = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/bass.wav");
c = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/cymbals.wav");
d = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/kick.wav");
e = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/snare.wav");



SynthDef(\basssample, { arg bassvol = 1, rate = 1, fx = 0;
	var bass = PlayBuf.ar(1, b.bufnum, BufRateScale.kr(b.bufnum)*rate, loop: 1)*bassvol;

	Out.ar(0, bass*0.5);
	Out.ar(~fx, bass*0.5);

}).add;

SynthDef(\cymbalssample, { arg cymbalsvol = 1, rate = 1, fx = 0;
	var cymbals = PlayBuf.ar(1, c.bufnum, BufRateScale.kr(c.bufnum)*rate, loop: 1)*cymbalsvol;

	Out.ar(0, cymbals*0.5);
	Out.ar(~fx, cymbals*0.5);

}).add;

SynthDef(\delay, {
	arg delaytime = 0.1, wet = 0, fb = 1, lag = 2;
	var sound, delay;
	sound = In.ar(~fx);
	delay = CombL.ar(sound, 2, Lag.kr(delaytime, lag), fb, wet);

	Out.ar(0, delay);
}).add
)

(
var w, xy, slider1, spec1, slider2, spec2, slider3, spec3, slider4, spec4;
w = Window("I am a window", Rect(800, 500, 800, 400));

~delay = Synth(\delay);
~playing = Synth(\cymbalssample);
~playing = Synth(\basssample); // Both synths do not play through gui at same time, which ever is last will be attached to gui. Problem here????????

spec1 = ControlSpec(-1, 2, \lin, 0, 1);
spec2 = ControlSpec(0.2, 1, \lin, 0, 0.5);
spec3 = ControlSpec(0, 1, \lin, 0, 0);


slider1 = EZSlider(w, Rect(400, 20, 300, 20),
	label: "Rate", controlSpec: spec1, action: {~playing.set(\rate, slider1.value)}, initVal: 1);

slider2 = EZKnob(w, Rect(400, 100, 150, 150),
	label: "Bass Delay", controlSpec: spec2, action: {~delay.set(\delaytime, slider2.value)}, initVal: 0.2);

slider3 = EZKnob(w, Rect(600, 100, 150, 150),
	label: "Bass Delay Wet", controlSpec: spec3, action: {~delay.set(\wet, slider3.value)}, initVal: 0);

slider4 = EZKnob(w, Rect(600, 250, 150, 150),
	label: "FX", controlSpec: spec3, action: {~basssample.set(\fx, slider4.value)}, initVal: 0);



xy = Slider2D(w, Rect(10, 10, 380, 380));
xy.setXY(0.5, 0.5);

xy.action={~playing.set(
	\kickvol, xy.x,
	\cymbalsvol, xy.x.linlin(0, 1, 1, 0),
	\bassvol, xy.y,
	\snarevol, xy.y.linlin(0, 1, 1, 0),


)};

w.front;
w.onClose = {~playing.free}; // does not stop 2nd synth from playing
)*/
------------------------------------------------------------------------------------------------------
// adding delays to gui
/*
(
~fx = Bus.audio;

b = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/bass.wav");
c = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/cymbals.wav");
d = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/kick.wav");
e = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/snare.wav");



SynthDef(\multisample, { arg bassvol = 0, rate = 1;
	var bass = PlayBuf.ar(1, b.bufnum, BufRateScale.kr(b.bufnum)*rate, loop: 1)*bassvol;

	Out.ar(0, bass*0.5);
	Out.ar(~fx, bass*0.5);

}).add;

SynthDef(\delay, {
	arg delaytime = 0.1, wet = 0, fb = 1, lag = 2;
	var sound, delay;
	sound = In.ar(~fx);
	delay = CombL.ar(sound, 2, Lag.kr(delaytime, lag), fb, wet);

	Out.ar(0, delay);
}).add
)

(
var w, xy, slider1, spec1, slider2, spec2, slider3, spec3;
w = Window("I am a window", Rect(800, 500, 800, 400));

~delay = Synth(\delay);
~playing = Synth(\multisample);

spec1 = ControlSpec(-1, 2, \lin, 0, 1);
spec2 = ControlSpec(0.2, 1, \lin, 0, 0.5);
spec3 = ControlSpec(0, 1, \lin, 0, 0);


slider1 = EZSlider(w, Rect(400, 20, 300, 20),
	label: "Rate", controlSpec: spec1, action: {~playing.set(\rate, slider1.value)}, initVal: 1);

slider2 = EZKnob(w, Rect(400, 100, 150, 150),
	label: "Bass Delay", controlSpec: spec2, action: {~delay.set(\delaytime, slider2.value)}, initVal: 0.2);

slider3 = EZKnob(w, Rect(600, 100, 150, 150),
	label: "Bass Delay Wet", controlSpec: spec3, action: {~delay.set(\wet, slider3.value)}, initVal: 0);



xy = Slider2D(w, Rect(10, 10, 380, 380));
xy.setXY(0.5, 0.5);

xy.action={~playing.set(
	\kickvol, xy.x,
	\cymbalsvol, xy.x.linlin(0, 1, 1, 0),
	\bassvol, xy.y,
	\snarevol, xy.y.linlin(0, 1, 1, 0),


)};

w.front;
w.onClose = {~playing.free};
)
*/

