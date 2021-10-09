(
s.waitForBoot {
	~maxBands = 150;
	~pulseGroup = Group.new();
	~vGroup = Group.new(~pulseGroup, 'addAfter');
	~qGroup = Group.new(~pulseGroup, 'addAfter');
	// ~freqScaleBus ?? {~freqScaleBus = Bus.control(s, 4)};
	//~bitwigPulseBusses = [16, 17, 18, 19, 20, 21, 22];
	// s.sync;
	// ~freqScaleBus.setSynchronous(1);
	s.sync;
	"midicontrols.scd".loadRelative; // fuer cues von Bitwig
	"generate_controlLoops.scd".loadRelative;
	"synths.scd".loadRelative;
	"ev.scd".loadRelative;
	"cue_gui.scd".loadRelative;
	"cues_list.scd".loadRelative;
	v = ~makeEv.(1);
	q = ~makeEv.(2); // 0.25
	q.minFreq = 250;
	q.maxFreq = 880;
	v.initRouting(~vGroup, 12);
	q.initRouting(~qGroup, 13);
	s.sync;
	v.startAnalyse;
	q.startAnalyse;
	s.sync;
	v.startLoop(16);
	q.startLoop(17);
	s.sync;
	v.startSynths(10);
	q.startSynths(10);
}
)

// todo
// cues fuer seite 5: hall weg (release kurz) (ne, lieber manuell graduell!)
// ausserdem verschiedene loop kombies durchgehen und am ende numbands zurueckfahren
// der loop am ende entwickelt sich error maeesig, immer schneller und zerhackter

// cues rueckgaengig machbar
// poti fuer loop offset (oder loop laenge?)
// testen wie es waere wenn die loops statt beide -400, -300 und -600 haben

v.startSynths(120);
v.setAllSynths(\rel,4)
v.setAllSynths(\rel,0.1)
v.synthGroup.set(\rel, 3)

v.loopSynth.set(\loopSpeed, 1/8)

// v state high
freqMult: 1,
// v state low
freqMult: 0.25, // oder 0.5?

// q state hi
freqMult: 0.5 // wie v state low im grunde
minFreq: 880,
maxFreq: 7000,

// q state low
freqMult: 2
minFreq: 250,
maxFreq: 880,
v.freqMult = 1
v.startSynths(28)
q.setAllSynths(\rel,4)
q.startSynths(10)
q.freqMult = 2;
q.minFreq = 250;
q.maxFreq = 880;
q.setAllSynths(\ampThresh, 0.001)

// bei q.numBands == 10 und diesen settings eignen sich f g a h (mit g im zentrum)
q.setAllSynths(\rel,4)
q.freqMult = 2;
q.minFreq = 250;
q.maxFreq = 880;
q.setAllSynths(\ampThresh, 0.001)
// dieses setting mit vokal gesang auf wenigen tonhoehen. fade zu stimme und gleichzeitig mehr pulsieren
// am ende crossfade in v mit anfangssetting (evtl ein paar pulser bei v die dann auch raus gehen)
// bisschen auf beiden gleichzeitig auch bleiben
