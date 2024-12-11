p = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/thunder.wav");

(
SynthDef(\sampler, { arg rate = 1, vol = 0.5;
	Out.ar(0, PlayBuf.ar(2, p.bufnum, BufRateScale.kr(p.bufnum)*rate, loop: 1)*vol)
}).add
)

(
var w, slider1, spec1, slider2, spec2;
w = Window("I am a window", Rect(200, 200, 350, 140));

~playing = Synth(\sampler);

spec1 = ControlSpec(-1, 2, \lin, 0, 1);
spec2 = ControlSpec(0, 1, \lin, 0, 0.5);

slider1 = EZSlider(w, Rect(0, 20, 300, 20),
	label: "Rate", controlSpec: spec1, action: {~playing.set(\rate, slider1.value)}, initVal: 1);
slider2 = EZSlider(w, Rect(0, 50, 300, 20),
	label: "Volume", controlSpec: spec2, action: {~playing.set(\vol, slider2.value)}, initVal: 0.5);

w.front;
w.onClose = {~playing.free};
)

--------------------------------------------------------------------------------------------------------------------
(
b = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/luude.wav");
c = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/silence.wav");
d = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/thunder.wav");
e = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/bed.wav");

SynthDef(\multisample, { arg luudevol = 0, silencevol = 0, thundervol = 0, bedvol = 0, rate = 1, srate = 1, drate = 1, frate = 1;
	var luude = PlayBuf.ar(2, b.bufnum, BufRateScale.kr(b.bufnum)*frate, loop: 1)*luudevol;
	var silence = PlayBuf.ar(1, c.bufnum, BufRateScale.kr(c.bufnum)*rate, loop: 1)*silencevol;
	var thunder = PlayBuf.ar(1, d.bufnum, BufRateScale.kr(d.bufnum)*srate, loop: 1)*thundervol;
	var bed = PlayBuf.ar(1, e.bufnum, BufRateScale.kr(e.bufnum)*drate, loop: 1)*bedvol;

	Out.ar(0, luude+silence+thunder+bed)
}).add
)

(
var w, xy, slider1, spec1, slider2, spec2, slider3, spec3, slider4, spec4, slider5, spec5, slider6, spec6, slider7, spec7, slider8, spec8;
w = Window("I am a window", Rect(800, 500, 800, 400));

~playing = Synth(\multisample);

spec1 = ControlSpec(-1, 2, \lin, 0, 1);
spec2 = ControlSpec(-1, 2, \lin, 0, 1);
spec3 = ControlSpec(-1, 2, \lin, 0, 1);
spec4 = ControlSpec(-1, 2, \lin, 0, 1);

spec5 = ControlSpec(0, 1, \lin, 0, 0.5);
spec6 = ControlSpec(0, 1, \lin, 0, 0.5);
spec7 = ControlSpec(0, 1, \lin, 0, 0.5);
spec8 = ControlSpec(0, 1, \lin, 0, 0.5);

slider1 = EZSlider(w, Rect(400, 20, 300, 20),
	label: "Sample 1 Rate", controlSpec: spec1, action: {~playing.set(\rate, slider1.value)}, initVal: 1);
slider2 = EZSlider(w, Rect(400, 50, 300, 20),
	label: "Sample 2 Rate", controlSpec: spec2, action: {~playing.set(\srate, slider2.value)}, initVal: 1);
slider3 = EZSlider(w, Rect(400, 80, 300, 20),
	label: "Sample 3 Rate", controlSpec: spec3, action: {~playing.set(\drate, slider3.value)}, initVal: 1);
slider4 = EZSlider(w, Rect(400, 110, 300, 20),
	label: "Sample 4 Rate", controlSpec: spec4, action: {~playing.set(\frate, slider4.value)}, initVal: 1);

slider5 = EZSlider(w, Rect(400, 140, 300, 20),
	label: "Sample 1 Vol", controlSpec: spec5, action: {~playing.set(\silencevol, slider5.value)}, initVal: 0.5);
slider6 = EZSlider(w, Rect(400, 170, 300, 20),
	label: "Sample 2 Vol", controlSpec: spec6, action: {~playing.set(\thundervol, slider6.value)}, initVal: 0.5);
slider7 = EZSlider(w, Rect(400, 200, 300, 20),
	label: "Sample 3 Vol", controlSpec: spec7, action: {~playing.set(\bedvol, slider7.value)}, initVal: 0.5);
slider8 = EZSlider(w, Rect(400, 230, 300, 20),
	label: "Sample 4 Vol", controlSpec: spec8, action: {~playing.set(\luudevol, slider8.value)}, initVal: 0.5);




xy = Slider2D(w, Rect(10, 10, 380, 380));
xy.setXY(0.5, 0.5);

xy.action={~playing.set(
	\thundervol, xy.x,
	\silencevol, xy.x.linlin(0, 1, 1, 0),
	\luudevol, xy.y,
	\bedvol, xy.y.linlin(0, 1, 1, 0),


)};

w.front;
w.onClose = {~playing.free};
)
----------------------------------------------------------------------------------------------------------------------
/*
(
b = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/luude.wav");
c = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/guitar.wav");
d = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/trumpet.wav");
e = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/bed.wav");

SynthDef(\multisample, { arg luudevol = 0, silencevol = 1, thundervol = 0, bedvol = 0, rate = 1, srate = 1, drate = 1, frate = 1;
	var luude = PlayBuf.ar(2, b.bufnum, BufRateScale.kr(b.bufnum)*frate, loop: 1)*luudevol;
	var silence = PlayBuf.ar(1, c.bufnum, BufRateScale.kr(c.bufnum)*rate, loop: 1)*silencevol;
	var thunder = PlayBuf.ar(1, d.bufnum, BufRateScale.kr(d.bufnum)*srate, loop: 1)*thundervol;
	var bed = PlayBuf.ar(1, e.bufnum, BufRateScale.kr(e.bufnum)*drate, loop: 1)*bedvol;

	Out.ar(0, luude+silence+thunder+bed)
}).add
)

(
var w, xy, slider1, spec1, slider2, spec2, slider3, spec3, slider4, spec4, slider5, spec5, slider6, spec6;
w = Window("I am a window", Rect(800, 500, 800, 400));

~playing = Synth(\multisample);

spec1 = ControlSpec(-1, 2, \lin, 0, 1);
spec2 = ControlSpec(-1, 2, \lin, 0, 1);
spec3 = ControlSpec(-1, 2, \lin, 0, 1);
spec4 = ControlSpec(-1, 2, \lin, 0, 1);

spec5 = ControlSpec(0, 1, \lin, 0, 0.5);
spec6 = ControlSpec(0, 1, \lin, 0, 0.5);
//spec7 = ControlSpec(-1, 2, \lin, 0, 1);
//spec8 = ControlSpec(-1, 2, \lin, 0, 1);

slider1 = EZSlider(w, Rect(400, 20, 300, 20),
	label: "Sample 1 Rate", controlSpec: spec1, action: {~playing.set(\rate, slider1.value)}, initVal: 1);
slider2 = EZSlider(w, Rect(400, 50, 300, 20),
	label: "Sample 2 Rate", controlSpec: spec2, action: {~playing.set(\srate, slider2.value)}, initVal: 1);
slider3 = EZSlider(w, Rect(400, 80, 300, 20),
	label: "Sample 3 Rate", controlSpec: spec3, action: {~playing.set(\drate, slider3.value)}, initVal: 1);
slider4 = EZSlider(w, Rect(400, 110, 300, 20),
	label: "Sample 4 Rate", controlSpec: spec4, action: {~playing.set(\frate, slider4.value)}, initVal: 1);

slider5 = EZSlider(w, Rect(400, 140, 300, 20),
	label: "Sample 1 Vol", controlSpec: spec5, action: {~playing.set(\silencevol, slider1.value)}, initVal: 1);
slider6 = EZSlider(w, Rect(400, 170, 300, 20),
	label: "Sample 2 Vol", controlSpec: spec6, action: {~playing.set(\thundervol, slider2.value)}, initVal: 1);




xy = Slider2D(w, Rect(10, 10, 380, 380));
xy.setXY(0.5, 0.5);

xy.action={~playing.set(
	\thundervol, xy.x,
	\silencevol, xy.x.linlin(0, 1, 1, 0),
	\luudevol, xy.y,
	\bedvol, xy.y.linlin(0, 1, 1, 0),


)};

w.front;
w.onClose = {~playing.free};
)
*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*(
b = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/luude.wav");
c = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/guitar.wav");
d = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/trumpet.wav");
e = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/bed.wav");

SynthDef(\multisample, { arg luudevol = 0, silencevol = 0, thundervol = 0, bedvol = 0;
	var luude = PlayBuf.ar(2, b.bufnum, BufRateScale.kr(b.bufnum), loop: 1)*luudevol;
	var silence = PlayBuf.ar(1, c.bufnum, BufRateScale.kr(c.bufnum), loop: 1)*silencevol;
	var thunder = PlayBuf.ar(1, d.bufnum, BufRateScale.kr(d.bufnum), loop: 1)*thundervol;
	var bed = PlayBuf.ar(1, e.bufnum, BufRateScale.kr(e.bufnum), loop: 1)*bedvol;

	Out.ar(0, luude+silence+thunder+bed)
}).add
)

(
var w, xy;
w = Window("I am a window", Rect(200, 200, 400, 400));

~playing = Synth(\multisample);

xy = Slider2D(w, Rect(10, 10, 380, 380));
xy.setXY(0.5, 0.5);

xy.action={~playing.set(
	\thundervol, xy.x,
	\silencevol, xy.x.linlin(0, 1, 1, 0),
	//\luudevol, xy.y,
	//\bedvol, xy.y.linlin(0, 1, 1, 0),
)};

w.front;
w.onClose = {~playing.free};
)*/































/*(
b = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/luude.wav");
c = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/guitar.wav");
d = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/trumpet.wav");
e = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/bed.wav");

SynthDef(\multisample, { arg luudevol = 0, silencevol = 0, thundervol = 0, bedvol = 0;
	var luude = PlayBuf.ar(2, b.bufnum, BufRateScale.kr(b.bufnum), loop: 1)*luudevol;
	var silence = PlayBuf.ar(1, c.bufnum, BufRateScale.kr(c.bufnum), loop: 1)*silencevol;
	var thunder = PlayBuf.ar(1, d.bufnum, BufRateScale.kr(d.bufnum), loop: 1)*thundervol;
	var bed = PlayBuf.ar(1, e.bufnum, BufRateScale.kr(e.bufnum), loop: 1)*bedvol;

	Out.ar(0, luude+silence+thunder+bed)
}).add
)

(
var w, xy;
w = Window("I am a window", Rect(200, 200, 400, 400));

~playing = Synth(\multisample);

xy = Slider2D(w, Rect(10, 10, 380, 380));
xy.setXY(0.5, 0.5);

xy.action={~playing.set(
	\thundervol, xy.x,
	\silencevol, xy.x.linlin(0, 1, 1, 0),
	//\luudevol, xy.y,
	//\bedvol, xy.y.linlin(0, 1, 1, 0),
)};

w.front;
w.onClose = {~playing.free};
)*/