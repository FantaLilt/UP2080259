p = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "amen.wav");

(
SynthDef(\sampler, { arg rate = 1, vol = 0.5;
	Out.ar(0, PlayBuf.ar(2, p.bufnum, BufRateScale.kr(p.bufnum)*rate, loop: 1)*vol)
}).add
)

(
var w, xy;
w = Window("I am a window", Rect(200, 200, 400, 400));

~playing = Synth(\sampler);

xy = Slider2D(w, Rect(10, 10, 380, 380));
xy.setXY(0.5, 0.5);

xy.action={~playing.set(
	\rate, xy.x.linlin(0, 1, -1, 2), // from 0 to 1, up to -1 to 2
	\vol, xy.y.linlin(0, 1, 1, 0) // inverted
)};

w.front;
w.onClose = {~playing.free};
)







(
SynthDef(\synthtest, {
	arg amp1 = 0.5, amp2 = 0.5, amp3 = 0.5, amp4 = 0.5;
	var synth1 = SinOsc.ar(200, 0, amp1);
	var synth2 = SinOsc.ar(400, 0, amp2);
	var synth3 = SinOsc.ar(600, 0, amp3);
	var synth4 = SinOsc.ar(800, 0, amp4);

	Out.ar(0, Pan2.ar(synth1 + synth2 + synth3 + synth4, 0, 0.2))
}).add
)

(
var w, xy;
w = Window("I am a window", Rect(200, 200, 400, 400));

~playing = Synth(\synthtest);

xy = Slider2D(w, Rect(10, 10, 380, 380));
xy.setXY(0.5, 0.5);

xy.action={~playing.set(
	\amp1, xy.x,
	\amp2, xy.x.linlin(0, 1, 1, 0),
	\amp1, xy.y,
	\amp1, xy.y.linlin(0, 1, 1, 0),
)};

w.front;
w.onClose = {~playing.free};
)











(
b = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/bass.wav");
c = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/chords.wav");
d = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "audio/drums.wav");
//e = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "");

SynthDef(\multisample, { arg bassvol = 0, chordsvol = 1, drumsvol = 0; /*trumpetvol = 0*/
	var bass = PlayBuf.ar(1, b.bufnum, BufRateScale.kr(b.bufnum), loop: 1)*bassvol;
	var chords = PlayBuf.ar(1, c.bufnum, BufRateScale.kr(c.bufnum), loop: 1)*chordsvol;
	var drums = PlayBuf.ar(1, d.bufnum, BufRateScale.kr(d.bufnum), loop: 1)*drumsvol;
	/*var trumpet = PlayBuf.ar(1, e.bufnum, BufRateScale.kr(e.bufnum), loop: 1)*trumpetvol;*/

	Out.ar(0, bass+chords+drums/*+trumpet*/)
}).add
)

(
var w, xy;
w = Window("I am a window", Rect(200, 200, 400, 400));

~playing = Synth(\multisample);

xy = Slider2D(w, Rect(10, 10, 380, 380));
xy.setXY(0.5, 0.5);

xy.action={~playing.set(
	\drumsvol, xy.x,
	\chordsvol, xy.x.linlin(0, 1, 1, 0),
	\bassvol, xy.y,
	/*\trumpetvol, xy,y.linlin(0, 1, 1, 0),*/
)};

w.front;
w.onClose = {~playing.free};
)
