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
	"synths.scd".loadRelative;
	"ev.scd".loadRelative;
	v = ~makeEv.(1);
	q = ~makeEv.(0.25);
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

v.startSynths(120);


v.setAllSynths(\rel, 1)

v.numBands
