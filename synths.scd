SynthDef(\analyseSynth, {
	var source = SoundIn.ar(\input.ir(12)),
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
	var bitwigDC = A2K.kr(SoundIn.ar(\controlIn.ir())); //(LFTri.kr(0.35).range(0, -400) + (LFNoise1.kr(0.25).range(0, 100) * \noiseAmt.kr(0)))
	var loop = BufRd.kr(
		~maxBands,
		\melBuf.ir(),
		Gate.ar(phase,1 - \freeze.kr(0)) + LinLin.kr(bitwigDC,-1,1,-400,0)
	);
	var mix = SelectX.kr(\mbSelect.kr(0),[orig, loop]);
	Out.kr(\loopBus.ir(), mix);
	0
}).add;

SynthDef(\sine, {
	// var freqScale = In.kr(\freqScaleBus.kr(), 1);
	var freqScale = LFPulse.kr(\pulseSpeed.ir() * \lfoSpeed.kr(1)).range(\pulseLow.ir(),\pulseHi.ir());
	//SoundIn.ar(\freqScaleBus.kr()) + 1;
	var amp = In.kr(\busIndex.ir(), 1);
	var modAmp = LagUD.kr(
		amp * (amp > (\ampThresh.kr(0.0005) * \ampThreshFactor.kr(1))),
		(2.pow(10) / 2) * SampleDur.ir, \rel.kr(0.05)
	);
	var pulseSelect = Select.kr(\pulseOn.kr(1), [DC.kr(1), freqScale]);
	var sig = SinOsc.ar(\freq.kr() * pulseSelect);
	sig = sig * modAmp;
	Out.kr(\visBusIndex.ir(), modAmp * pulseSelect * pulseSelect);
	Out.ar(\out.ir(), sig)
}).add;

/*SynthDef(\pulses, {
	var lfo1 = DC.kr(1);
	var lfo2 = LFPulse.kr(\lfo2Speed.kr(5)).range(1,2);
	var lfo3 = LFPulse.kr(\lfo3Speed.kr(7)).range(1,2);
	var lfo4 = LFPulse.kr(\lfo4Speed.kr(11)).range(1,2);
	Out.kr(\lfoBus.ir(), [lfo1, lfo2, lfo3, lfo4]);
	0
}).add;*/