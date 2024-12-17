//
(
~bfx = Bus.audio;
~cfx = Bus.audio;
~kfx = Bus.audio;
~sfx = Bus.audio;

b = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/bass.wav");
c = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/cymbals.wav");
d = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/kick.wav");
e = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/snare.wav");


// bassvol etc connected to the 2D slider, rate connect to rate of all tracks
SynthDef(\multisample, { arg bassvol = 1, cymbalsvol = 1, kickvol = 1, snarevol = 1, rate = 1;
	var bass = PlayBuf.ar(1, b.bufnum, BufRateScale.kr(b.bufnum)*rate, loop: 1)*bassvol !2;
	var cymbals = PlayBuf.ar(1, c.bufnum, BufRateScale.kr(c.bufnum)*rate, loop: 1)*cymbalsvol !2;
	var kick = PlayBuf.ar(1, d.bufnum, BufRateScale.kr(d.bufnum)*rate, loop: 1)*kickvol !2;
	var snare = PlayBuf.ar(1, e.bufnum, BufRateScale.kr(e.bufnum)*rate, loop: 1)*snarevol !2;

	//all outputs are going through a seperate delay
	//bass output
	Out.ar(0, bass*0.5);
	Out.ar(~bfx, bass*0.5);
	//cymbals output
	Out.ar(0, cymbals*0.5);
	Out.ar(~cfx, cymbals*0.5);
	//kick output
	Out.ar(0, kick*0.5);
	Out.ar(~kfx, kick*0.5);
	//snare output
	Out.ar(0, snare*0.5);
	Out.ar(~sfx, snare*0.5);

}).add;

//SynthDefs are going through these delays
SynthDef(\delay, {
	arg delaytime = 0.1, wet = 0, fb = 1, lag = 2;
	var sound, delay;
	sound = In.ar(~bfx);
	delay = CombL.ar(sound, 2, Lag.kr(delaytime, lag), fb, wet);

	Out.ar(0, delay);
}).add;

SynthDef(\cdelay, {
	arg delaytime = 0.1, wet = 0, fb = 1, lag = 2;
	var sound, delay;
	sound = In.ar(~cfx);
	delay = CombL.ar(sound, 2, Lag.kr(delaytime, lag), fb, wet);

	Out.ar(0, delay);
}).add;

SynthDef(\kdelay, {
	arg delaytime = 0.1, wet = 0, fb = 1, lag = 2;
	var sound, delay;
	sound = In.ar(~kfx);
	delay = CombL.ar(sound, 2, Lag.kr(delaytime, lag), fb, wet);

	Out.ar(0, delay);
}).add;

SynthDef(\sdelay, {
	arg delaytime = 0.1, wet = 0, fb = 1, lag = 2;
	var sound, delay;
	sound = In.ar(~sfx);
	delay = CombL.ar(sound, 2, Lag.kr(delaytime, lag), fb, wet);

	Out.ar(0, delay);
}).add
)

(
//variables for all sliders
var w, xy, slider1, spec1, slider2, spec2, slider3, spec3, slider4, slider5, slider6, slider7, slider8, slider9;
w = Window("2D Slider", Rect(800, 100, 800, 800));

// pulls the synth delays
~sdelay = Synth(\sdelay);
~kdelay = Synth(\kdelay);
~cdelay = Synth(\cdelay);
~delay = Synth(\delay);
~playing = Synth(\multisample);

// controls the values the sliders can go up or down to
spec1 = ControlSpec(-1, 2, \lin, 0, 1);
spec2 = ControlSpec(0.2, 1, \lin, 0, 0.5);
spec3 = ControlSpec(0, 1, \lin, 0, 0);

//sliders pulling the control values, delays
slider1 = EZSlider(w, Rect(400, 20, 300, 20),
	label: "Rate", controlSpec: spec1, action: {~playing.set(\rate, slider1.value)}, initVal: 1);

slider2 = EZKnob(w, Rect(400, 100, 100, 100),
	label: "Bass Delay", controlSpec: spec2, action: {~delay.set(\delaytime, slider2.value)}, initVal: 0.2);

slider3 = EZKnob(w, Rect(600, 100, 100, 100),
	label: "Bass Delay Wet", controlSpec: spec3, action: {~delay.set(\wet, slider3.value)}, initVal: 0);

slider4 = EZKnob(w, Rect(400, 200, 100, 100),
	label: "Snare Delay", controlSpec: spec2, action: {~sdelay.set(\delaytime, slider4.value)}, initVal: 0.2);

slider5 = EZKnob(w, Rect(600, 200, 100, 100),
	label: "Snare Delay Wet", controlSpec: spec3, action: {~sdelay.set(\wet, slider5.value)}, initVal: 0);

slider6 = EZKnob(w, Rect(400, 300, 100, 100),
	label: "Cymbals Delay", controlSpec: spec2, action: {~cdelay.set(\delaytime, slider6.value)}, initVal: 0.2);

slider7 = EZKnob(w, Rect(600, 300, 100, 100),
	label: "Cymbals Delay Wet", controlSpec: spec3, action: {~cdelay.set(\wet, slider7.value)}, initVal: 0);

slider8 = EZKnob(w, Rect(400, 400, 100, 100),
	label: "Kick Delay", controlSpec: spec2, action: {~kdelay.set(\delaytime, slider8.value)}, initVal: 0.2);

slider9 = EZKnob(w, Rect(600, 400, 100, 100),
	label: "Kick Delay Wet", controlSpec: spec3, action: {~kdelay.set(\wet, slider9.value)}, initVal: 0);



//creates a 2D slider
xy = Slider2D(w, Rect(10, 100, 380, 380));
xy.setXY(0.5, 0.5);

// pulls all of the vols giving it an X/Y
xy.action={~playing.set(
	\kickvol, xy.x,
	\cymbalsvol, xy.x.linlin(0, 1, 1, 0),
	\bassvol, xy.y,
	\snarevol, xy.y.linlin(0, 1, 1, 0),


)};

w.front;
w.onClose = {~playing.free};
)
