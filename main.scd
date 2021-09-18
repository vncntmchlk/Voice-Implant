(
s.waitForBoot {
	~maxBands = 150;
	"synths.scd".loadRelative;
	"ev.scd".loadRelative;
	v = ~makeEv.();
	// q = ~makeEv.();
	v.initRouting;
	// q.initRouting;
	s.sync;
	v.startAnalyse;
	// q.startAnalyse;
	s.sync;
	v.startLoop;
	// q.startLoop;
	s.sync;
	v.startSynths(10);
	//q.startSynths(10, 6);
}
)

v.startSynths(5);

v.loopSynth.set(\freeze, 1);
v.loopSynth.set(\freeze, 0);


v.loopSynth.set(\mbSelect, 1);
v.loopSynth.set(\mbSelect, 0.5);
v.loopSynth.set(\mbSelect, 0);

q.loopSynth.set(\mbSelect, 1);

