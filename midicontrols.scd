if(MIDIClient.initialized.not){
	MIDIClient.init;
	MIDIIn.connect(0, MIDIClient.sources.select{|m| m.name == "VirMIDI 0-0"}[0]);
};
~midiStates = (
	lfoSpeeds: [0.25, 0.5, 1, 2, 4],
	vFreeze: false,
	vlastRand: 0,
	vSynthNumList: [10, 14, 20, 28, 36, 120],
	vSynthListIndex: 0,
	vSwitchState: true,
	vTrueState: (freqMult: 1),
	vFalseState: (freqMult: 0.5),
	vLfoIndex: 2,
	qFreeze: false,
	qlastRand: 0,
	qSynthNumList: [10, 14, 20, 28, 36, 120],
	qSynthListIndex: 0,
	qSwitchState: true,
	qTrueState: (freqMult: 2, minFreq: 250, maxFreq: 880),
	qFalseState: (freqMult: 0.5, minFreq: 880, maxFreq: 7000),
	qLfoIndex: 2,
	cue: 0
);

~cueActions = (
	1: {~midiStates.cue = (~midiStates.cue - 1).clip(0,20); ~cuesList[~midiStates.cue].value;
		{~cueText.string = "CUE: " ++ (~midiStates.cue + 1)}.defer;
	},
	2: {~midiStates.cue = (~midiStates.cue + 1).clip(0,20); ~cuesList[~midiStates.cue].value;
		{~cueText.string = "CUE: " ++ (~midiStates.cue + 1)}.defer;
	},
	10: {
		~midiStates.vSynthListIndex = (~midiStates.vSynthListIndex + 1).clip(0, 5);
		v.startSynths(~midiStates.vSynthNumList[~midiStates.vSynthListIndex])
	},
	11: {
		~midiStates.vSynthListIndex = (~midiStates.vSynthListIndex - 1).clip(0, 5);
		v.startSynths(~midiStates.vSynthNumList[~midiStates.vSynthListIndex])
	},
	12: {
		~midiStates.vFreeze = ~midiStates.vFreeze.not;
		("FREEZE V " ++ (~midiStates.vFreeze.asString)).postln;
		v.loopSynth.set(\freeze, ~midiStates.vFreeze.asInteger);
		{~loopST1Button.valueAction = ~midiStates.vFreeze.asInteger}.defer;
	},
	/*	13: {
	~midiStates.vSwitchState = ~midiStates.vSwitchState.not;
	if(~midiStates.vSwitchState){
	~midiStates.vTrueState.keysValuesDo{|sym, val| v[sym] = val};
	}{
	~midiStates.vFalseState.keysValuesDo{|sym, val| v[sym] = val};
	};
	v.startSynths(v.numBands);
	},*/
	14: {
		~midiStates.vLfoIndex = (~midiStates.vLfoIndex + 1).clip(0,4);
		v.setAllSynths(\lfoSpeed, ~midiStates.lfoSpeeds[~midiStates.vLfoIndex]);
	},
	15: {
		~midiStates.vLfoIndex = (~midiStates.vLfoIndex - 1).clip(0,4);
		v.setAllSynths(\lfoSpeed, ~midiStates.lfoSpeeds[~midiStates.vLfoIndex]);
	},
	20: {
		~midiStates.qSynthListIndex = (~midiStates.qSynthListIndex + 1).clip(0, 5);
		q.startSynths(~midiStates.qSynthNumList[~midiStates.qSynthListIndex])
	},
	21: {
		~midiStates.qSynthListIndex = (~midiStates.qSynthListIndex - 1).clip(0, 5);
		q.startSynths(~midiStates.qSynthNumList[~midiStates.qSynthListIndex])
	},
	22: {
		~midiStates.qFreeze = ~midiStates.qFreeze.not;
		("FREEZE Q " ++ (~midiStates.qFreeze.asString)).postln;
		q.loopSynth.set(\freeze, ~midiStates.qFreeze.asInteger);
		{~loopST2Button.valueAction = ~midiStates.qFreeze.asInteger}.defer;
	},
	/*	23: {
	~midiStates.qSwitchState = ~midiStates.qSwitchState.not;
	if(~midiStates.qSwitchState){
	~midiStates.qTrueState.keysValuesDo{|sym, val| q[sym] = val};
	}{
	~midiStates.qFalseState.keysValuesDo{|sym, val| q[sym] = val};
	};
	q.startSynths(q.numBands);
	},*/
	24: {
		~midiStates.qLfoIndex = (~midiStates.qLfoIndex + 1).clip(0,4);
		q.setAllSynths(\lfoSpeed, ~midiStates.lfoSpeeds[~midiStates.qLfoIndex]);
	},
	25: {
		~midiStates.qLfoIndex = (~midiStates.qLfoIndex - 1).clip(0,4);
		q.setAllSynths(\lfoSpeed, ~midiStates.lfoSpeeds[~midiStates.qLfoIndex]);
	},
);
MIDIdef.program(\cue, {|val|
	/*if(~midiStates.prevVal == 3 && val == 0){
	~cueActions[3].value
	}{
	~cueActions[val].value
	};*/
	~cueActions[val].value;
	~midiStates.prevVal = val
});
MIDIdef.cc(\mbSelectV, {|val| v.loopSynth.set(\mbSelect, val / 127)}, 1);
MIDIdef.cc(\mbSelectQ, {|val| q.loopSynth.set(\mbSelect, val / 127)}, 10);

~vPulseFunc = { |val|
	if(val > ~midiStates.vlastRand){
		// neue randomisieren
		(~midiStates.vlastRand..val).do {|i|
			// v.synthArray[v.randomOrder[i]].set(\freqScaleBus, ~bitwigPulseBusses[1..].choose)
			v.synthArray[v.randomOrder[i]].set(\pulseOn, 1)
		}
	};
	if(val < ~midiStates.vlastRand){
		// alte zuruecksetzen
		(val..~midiStates.vlastRand).do {|i|
			// v.synthArray[v.randomOrder[i]].set(\freqScaleBus, ~bitwigPulseBusses[0])
			v.synthArray[v.randomOrder[i]].set(\pulseOn, 0)
		}
	};
	~midiStates.vlastRand = val
};

MIDIdef.cc(\randomiseV, {|val|
	val = val.linlin(0, 127, 0, ~maxBands - 1).asInteger;
	~vPulseFunc.(val);
}, 2);

~qPulseFunc = { |val|
	if(val > ~midiStates.qlastRand){
		(~midiStates.qlastRand..val).do {|i|
			q.synthArray[q.randomOrder[i]].set(\pulseOn, 1)
		}
	};
	if(val < ~midiStates.qlastRand){
		(val..~midiStates.qlastRand).do {|i|
			q.synthArray[q.randomOrder[i]].set(\pulseOn, 0)
		}
	};
	~midiStates.qlastRand = val
};

MIDIdef.cc(\randomiseQ, {|val|
	val = val.linlin(0, 127, 0, ~maxBands - 1).asInteger;
	~qPulseFunc.(val);
}, 11);

MIDIdef.cc(\ampThreshV, {|val| v.setAllSynths(\ampThresh, val.lincurve(0, 127, 0,0.3,8))}, 3);
MIDIdef.cc(\ampThreshQ, {|val| q.setAllSynths(\ampThresh, val.lincurve(0, 127, 0,0.3,8))}, 12);
MIDIdef.cc(\relV, {|val| v.setAllSynths(\rel, val.lincurve(0, 127, 0.03,5,3))}, 4);
MIDIdef.cc(\relQ, {|val| q.setAllSynths(\rel, val.lincurve(0, 127, 0.03,5,3))}, 13);

MIDIdef.cc(\opacity, {|val|
	~gui !? {
		{
			// hier muessen noch die richtigen colors uebernommen werden (red blue)
			// vielleicht leichter mit hsv zu loesen?
			~gui.voiceView.background = Color.gray(val.linlin(63.5,127, 1, 0), 1);
			~gui.electronicsView.fillColor = Color.gray(val.linlin(0,63.5, 1, 0), 1);

			~gui.voiceView2.background = Color.gray(val.linlin(63.5,127, 1, 0), 1);
			~gui.electronicsView2.fillColor = Color.gray(val.linlin(0,63.5, 1, 0), 1);
		}.defer
	}
}, 20);
MIDIdef.cc(\windowAlpha, {|val|
	~gui !? {
		{
			val = val / 127;
			~gui.win.alpha = 1 - val;
			~gui.win2.alpha = val;
		}.defer
	}
}, 21);
/*

~nanoActions = (
0: {|val| v.loopSynth.set(\mbSelect, val); ~nanoActions.vMbSelect = val},
vFreeze: Pseq([1,0],inf).asStream,
64: {|val|
if(val != 0){
var onOff = ~nanoActions.vFreeze.next;
if(onOff == 0){
~midiOut.control(0, 64, 127);
// ACTIVATE FREEZE
}{
~midiOut.control(0, 64, 0);
// DEACTIVATE FREEZE
};
}
}
);
MIDIdef.cc(\nano, {|val ccNum|
~nanoActions[ccNum.postln].(val.postln/127)
});

~midiOut = MIDIOut.new(0).latency_(0);

~midiOut.connect(MIDIClient.destinations.select{|m| m.name == "nanoKONTROL2 MIDI 1"}[0]);

~midiOut.sysex(Int8Array[0xF0, 0x7E, 0x7F, 0x06, 0x01, 0xF7]);
~midiOut.sysex(Int8Array[0xF0, 0x42, 0x40, 0x00, 0x01, 0x13, 0x00, 0x1F, 0x12, 0x00, 0xF7]);
~midiOut.sysex(Int8Array[0xF0, 0x7E, 0x7F, 0x06, 0x01, 0xF7]);
~midiOut.sysex(Int8Array[0xF0, 0x42, 0x40, 0x00, 0x01, 0x13, 0x00, 0x7F, 0x7F, 0x02, 0x03, 0x05, 0x40, 0x00, 0x00, 0x00,
0x01, 0x10, 0x01, 0x00, 0x00, 0x00, 0x00, 0x7F, 0x00, 0x01, 0x00, 0x10, 0x00, 0x00, 0x7F, 0x00,
0x01, 0x00, 0x20, 0x00, 0x7F, 0x00, 0x00, 0x01, 0x00, 0x30, 0x00, 0x7F, 0x00, 0x00, 0x01, 0x00,
0x40, 0x00, 0x7F, 0x00, 0x10, 0x00, 0x01, 0x00, 0x01, 0x00, 0x7F, 0x00, 0x01, 0x00, 0x00, 0x11,
0x00, 0x7F, 0x00, 0x01, 0x00, 0x00, 0x21, 0x00, 0x7F, 0x00, 0x01, 0x00, 0x31, 0x00, 0x00, 0x7F,
0x00, 0x01, 0x00, 0x41, 0x00, 0x00, 0x7F, 0x00, 0x10, 0x01, 0x00, 0x02, 0x00, 0x00, 0x7F, 0x00,
0x01, 0x00, 0x12, 0x00, 0x7F, 0x00, 0x00, 0x01, 0x00, 0x22, 0x00, 0x7F, 0x00, 0x00, 0x01, 0x00,
0x32, 0x00, 0x7F, 0x00, 0x01, 0x00, 0x00, 0x42, 0x00, 0x7F, 0x00, 0x10, 0x01, 0x00, 0x00, 0x03,
0x00, 0x7F, 0x00, 0x01, 0x00, 0x00, 0x13, 0x00, 0x7F, 0x00, 0x01, 0x00, 0x23, 0x00, 0x00, 0x7F,
0x00, 0x01, 0x00, 0x33, 0x00, 0x00, 0x7F, 0x00, 0x01, 0x00, 0x43, 0x00, 0x7F, 0x00, 0x00, 0x10,
0x01, 0x00, 0x04, 0x00, 0x7F, 0x00, 0x00, 0x01, 0x00, 0x14, 0x00, 0x7F, 0x00, 0x00, 0x01, 0x00,
0x24, 0x00, 0x7F, 0x00, 0x01, 0x00, 0x00, 0x34, 0x00, 0x7F, 0x00, 0x01, 0x00, 0x00, 0x44, 0x00,
0x7F, 0x00, 0x10, 0x01, 0x00, 0x00, 0x05, 0x00, 0x7F, 0x00, 0x01, 0x00, 0x15, 0x00, 0x00, 0x7F,
0x00, 0x01, 0x00, 0x25, 0x00, 0x00, 0x7F, 0x00, 0x01, 0x00, 0x35, 0x00, 0x7F, 0x00, 0x00, 0x01,
0x00, 0x45, 0x00, 0x7F, 0x00, 0x00, 0x10, 0x01, 0x00, 0x06, 0x00, 0x7F, 0x00, 0x00, 0x01, 0x00,
0x16, 0x00, 0x7F, 0x00, 0x01, 0x00, 0x00, 0x26, 0x00, 0x7F, 0x00, 0x01, 0x00, 0x00, 0x36, 0x00,
0x7F, 0x00, 0x01, 0x00, 0x46, 0x00, 0x00, 0x7F, 0x00, 0x10, 0x01, 0x00, 0x07, 0x00, 0x00, 0x7F,
0x00, 0x01, 0x00, 0x17, 0x00, 0x00, 0x7F, 0x00, 0x01, 0x00, 0x27, 0x00, 0x7F, 0x00, 0x00, 0x01,
0x00, 0x37, 0x00, 0x7F, 0x00, 0x00, 0x01, 0x00, 0x47, 0x00, 0x7F, 0x00, 0x10, 0x00, 0x01, 0x00,
0x3A, 0x00, 0x7F, 0x00, 0x01, 0x00, 0x00, 0x3B, 0x00, 0x7F, 0x00, 0x01, 0x00, 0x00, 0x2E, 0x00,
0x7F, 0x00, 0x01, 0x00, 0x3C, 0x00, 0x00, 0x7F, 0x00, 0x01, 0x00, 0x3D, 0x00, 0x00, 0x7F, 0x00,
0x01, 0x00, 0x3E, 0x00, 0x7F, 0x00, 0x00, 0x01, 0x00, 0x2B, 0x00, 0x7F, 0x00, 0x00, 0x01, 0x00,
0x2C, 0x00, 0x7F, 0x00, 0x01, 0x00, 0x00, 0x2A, 0x00, 0x7F, 0x00, 0x01, 0x00, 0x00, 0x29, 0x00,
0x7F, 0x00, 0x01, 0x00, 0x2D, 0x00, 0x00, 0x7F, 0x00, 0x7F, 0x7F, 0x7F, 0x7F, 0x00, 0x7F, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0xF7, 0xF0, 0x7E, 0x7F, 0x06, 0x01, 0xF7]);
~midiOut.sysex(Int8Array[0xF0, 0x7E, 0x7F, 0x06, 0x01, 0xF7]);
~midiOut.sysex(Int8Array[0xF0, 0x42, 0x40, 0x00, 0x01, 0x13, 0x00, 0x1F, 0x11, 0x00, 0xF7]);

*/
