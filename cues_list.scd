~cuesList = Order.new(size: 20);
~cuesList[0] = { // resetting to start configuration (cue 1)
	{
		v.startSynths(10);
		q.startSynths(10);
		s.sync;
		// no pulses
		~vPulseFunc.(0);
		~qPulseFunc.(0);
		// no looping stuff
		v.loopSynth.set(\mbSelect, 0);
		q.loopSynth.set(\mbSelect, 0);
		// short release
		v.setAllSynths(\rel, 0.03);
		q.setAllSynths(\rel, 0.03);
		// low ampthresh
		v.setAllSynths(\ampThresh, 0.0005);
		q.setAllSynths(\ampThresh, 0.0005);
		// no loop
		v.loopSynth.set(\freeze, 0);
		~midiStates.vFreeze = false;
		q.loopSynth.set(\freeze, 0);
		~midiStates.qFreeze = false;
		{~loopST1Button.valueAction = 0}.defer;
		{~loopST2Button.valueAction = 0}.defer;
	}.fork
};
~cuesList[1] = { // Loop st 1
	v.loopSynth.set(\freeze, 1);
	~midiStates.vFreeze = true;
	{~loopST1Button.valueAction = 1}.defer;
	{
		q.startSynths(40);
		s.sync;
		q.setAllSynths(\rel, 0.1);
		q.loopSynth.set(\mbSelect, 0.2);
	}.fork
};
~cuesList[2] = {
	{
		var pulses = 40.linlin(0, 127, 0, 13).asInteger;
		v.startSynths(14);
		s.sync;
		~vPulseFunc.(pulses);
		v.loopSynth.set(\mbSelect, 0.5);
		v.loopSynth.set(\freeze, 0);
		~midiStates.vFreeze = false;
		{~loopST1Button.valueAction = 0}.defer;
	}.fork
};
~cuesList[3] = {
	{
		var pulses = 60.linlin(0, 127, 0, 19).asInteger;
		v.startSynths(20);
		s.sync;
		~vPulseFunc.(pulses);
		v.loopSynth.set(\mbSelect, 0.25);
		q.setAllSynths(\rel, 0.25);
		q.loopSynth.set(\mbSelect, 0.4);
	}.fork
};
~cuesList[4] = {
	{
		var pulses = 100.linlin(0, 127, 0, 27).asInteger;
		v.startSynths(28);
		s.sync;
		~vPulseFunc.(pulses);
		v.loopSynth.set(\mbSelect, 0.1);
		q.loopSynth.set(\mbSelect, 0.7);
		{q.loopSynth.set(\loopSpeed, 1/6)}.defer(5);
	}.fork
};
~cuesList[5] = {
	{
		var pulses = 127.linlin(0, 127, 0, 119).asInteger;
		v.startSynths(120);
		s.sync;
		~vPulseFunc.(pulses);
		v.loopSynth.set(\mbSelect, 0);
		{q.loopSynth.set(\loopSpeed, 1/4)}.defer(5);
	}.fork
};

~cuesList[6] = {
	{
		var pulses = 30.linlin(0, 127, 0, 119).asInteger;
		v.startSynths(28);
		q.startSynths(120);
		s.sync;
		~vPulseFunc.(pulses);
		q.setAllSynths(\rel, 0.01);
		{q.loopSynth.set(\loopSpeed, 1/2); q.loopSynth.set(\controlLoopBuf, ~slowFine[0])}.defer(5);
	}.fork
};

~cuesList[7] = {
	{
		~vPulseFunc.(0);
		{q.loopSynth.set(\loopSpeed, 1); q.loopSynth.set(\controlLoopBuf, ~slowFine[1])}.defer(5);
	}.fork
};

~cuesList[8] = {
	{
		v.loopSynth.set(\freeze, 1);
		~midiStates.vFreeze = true;
		q.loopSynth.set(\freeze, 1);
		~midiStates.qFreeze = true;
		{~loopST1Button.valueAction = 1}.defer;
		{~loopST2Button.valueAction = 1}.defer;
		v.loopSynth.set(\mbSelect, 0.5);
	}.fork
};

// seite 3. loops aendern immer tempi. sie werden ausserdem rauer. dann kommen pulse dazu (mit hoeheren pulstempi)

~cuesList[9] = {
	q.loopSynth.set(\loopSpeed, 1/3);
	q.loopSynth.set(\controlLoopBuf, ~steps[0]);
	v.loopSynth.set(\loopSpeed, 1/2);
	v.loopSynth.set(\controlLoopBuf, ~slowFine[0]);
};

~cuesList[10] = {
	q.loopSynth.set(\loopSpeed, 1/2);
	q.loopSynth.set(\controlLoopBuf, ~steps[1]);
	v.loopSynth.set(\loopSpeed, 2);
	v.loopSynth.set(\controlLoopBuf, ~steps[2]);
	q.startSynths(28);
};

~cuesList[11] = {
	var pulses = 50.linlin(0, 127, 0, ~maxBands - 1).asInteger;
	q.loopSynth.set(\loopSpeed, 1/4);
	q.loopSynth.set(\controlLoopBuf, ~slowRough[0]);
	v.loopSynth.set(\loopSpeed, 3/4);
	~vPulseFunc.(pulses);
	v.setAllSynths(\lfoSpeed, 2);
	~midiStates.vLfoIndex = 3;
};

~cuesList[12] = {
	var pulses = 90.linlin(0, 127, 0, ~maxBands - 1).asInteger;
	q.loopSynth.set(\loopSpeed, 1);
	v.loopSynth.set(\controlLoopBuf, ~slowRough[1]);
	~vPulseFunc.(pulses);
	~qPulseFunc.(pulses);
	q.setAllSynths(\lfoSpeed, 2);
	~midiStates.qLfoIndex = 3;
};

~cuesList[13] = {
	{
		v.startSynths(120);
		s.sync;
		~vPulseFunc.(0);
		~qPulseFunc.(0);
		v.setAllSynths(\rel, 3);
	}.fork;
};

// Seite 5, durch verschiedene eigenleben kombinationen wandern, numbands nimmt ab
~cuesList[14] = {
	q.loopSynth.set(\loopSpeed, 1/2);
	q.loopSynth.set(\controlLoopBuf, ~steps[0]);
	v.loopSynth.set(\loopSpeed, 1/2);
	v.loopSynth.set(\controlLoopBuf, ~steps[0]);
};

~cuesList[15] = {
	q.loopSynth.set(\loopSpeed, 1);
	q.loopSynth.set(\controlLoopBuf, ~steps[1]);
	v.loopSynth.set(\loopSpeed, 1/2);
	v.loopSynth.set(\controlLoopBuf, ~steps[2]);
};

~cuesList[16] = {
	q.loopSynth.set(\loopSpeed, 1.5);
	q.loopSynth.set(\controlLoopBuf, ~steps[1]);
	v.loopSynth.set(\loopSpeed, 1/4);
	v.loopSynth.set(\controlLoopBuf, ~slowFine[0]);
};

~cuesList[17] = {
	v.startSynths(28);
	q.loopSynth.set(\loopSpeed, 3);
	q.loopSynth.set(\controlLoopBuf, ~slowFine[1]);
	v.loopSynth.set(\loopSpeed, 1/2);
	v.loopSynth.set(\controlLoopBuf, ~slowRough[0]);
};

~cuesList[18] = {
	v.startSynths(10);
	q.loopSynth.set(\loopSpeed, 1/2);
	q.loopSynth.set(\controlLoopBuf, ~slowFine[2]);
	v.loopSynth.set(\loopSpeed, 1/2);
	v.loopSynth.set(\controlLoopBuf, ~slowRough[1]);
	v.loopSynth.set(\freeze, 1);
	~midiStates.vFreeze = true;
	q.loopSynth.set(\freeze, 1);
	~midiStates.qFreeze = true;
};