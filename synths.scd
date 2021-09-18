SynthDef(\analyseSynth, {
	var source = SoundIn.ar(\input.ir(4)),
	kRate = 1 / ControlRate.ir,
	phase = Phasor.ar(0, kRate, 0, ControlRate.ir * 120),
	mb = FluidMelBands.kr(source,
		numBands: \numBands.kr(10),
		minFreq: \minFreq.kr(880),
		maxFreq: \maxFreq.kr(7000),
		maxNumBands: ~maxBands);
	BufWr.kr(mb, \melBuf.ir(), phase);
	Out.ar(\phaseBus.ir(), phase);
	Out.kr(\melBus.ir(), mb);
	0
}).add;

SynthDef(\loopSynth, {
	var orig = In.kr(\melBus.ir(), ~maxBands);
	var phase = In.ar(\phaseBus.ir(), 1);
	var loop = BufRd.kr(~maxBands, \melBuf.ir(), Gate.ar(phase,\freeze.kr(1)) + LFNoise1.kr(3).range(0, -400));
	var mix = SelectX.kr(\mbSelect.kr(0),[orig, loop]);
	Out.kr(\loopBus.ir(), mix);
	0
}).add;

SynthDef(\sine, {
	var amp = In.kr(\busIndex.ir(), 1);
	var sig = SinOsc.ar(\freq.kr());
	sig = sig * LagUD.kr(
		amp * (amp > \ampThresh.kr(0.0005)),(2.pow(10) / 2) * SampleDur.ir, \rel.kr(0.05)
	);
	Out.ar(\out.ir(), sig)
}).add;