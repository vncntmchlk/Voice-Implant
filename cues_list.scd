~cuesList = Order.new(size: 25);
~cuesList_reverse = Order.new(size: 25);
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
		v.loopSynth.set(\loopStartLfoAmt, -50);
		q.loopSynth.set(\loopStartLfoAmt, -50);
		// short release
		v.setAllSynths(\rel, 0.03);
		q.setAllSynths(\rel, 0.03);
		// low ampthresh
		v.setAllSynths(\ampThresh, 0.0005);
		q.setAllSynths(\ampThresh, 0.0005);
		// no loop
		~freezeV.(false);
		~freezeQ.(false);
	}.fork
};

~cuesList_reverse[0] = {
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
		~freezeV.(false);
		~freezeQ.(false);
	}.fork
};
~cuesList[1] = { // Loop st 1
	~freezeV.(true);
	~freezeQ.(true);
	{
		q.startSynths(40);
		s.sync;
		q.setAllSynths(\rel, 1.5);
		q.loopSynth.set(\mbSelect, 0.2);
	}.fork
};
~cuesList[2] = {
	{
		var pulses = 5;
		v.startSynths(14);
		s.sync;
		~vPulseFunc.(0);
		~vPulseFunc.(pulses);
		v.loopSynth.set(\mbSelect, 0.5);
		~freezeV.(false);
		~freezeQ.(false);
	}.fork
};
~cuesList[3] = {
	{
		var pulses = 10;
		v.startSynths(20);
		s.sync;
		~vPulseFunc.(0);
		~vPulseFunc.(pulses);
		v.loopSynth.set(\mbSelect, 0.25);
		q.setAllSynths(\rel, 0.25);
		q.loopSynth.set(\mbSelect, 0.4);
	}.fork
};
~cuesList[4] = {
	{
		var pulses = 20;
		v.startSynths(28);
		s.sync;
		~vPulseFunc.(0);
		~vPulseFunc.(pulses);
		v.loopSynth.set(\mbSelect, 0.1);
		q.loopSynth.set(\mbSelect, 0.7);
		q.loopSynth.set(\loopSpeed, 1/6);
	}.fork
};
~cuesList[5] = {
	{
		var pulses = 119;
		v.startSynths(120);
		s.sync;
		~vPulseFunc.(0);
		~vPulseFunc.(pulses);
		v.loopSynth.set(\mbSelect, 0);
		q.loopSynth.set(\loopSpeed, 1/4);
	}.fork
};

~cuesList[6] = {
	{
		var pulses = 30;
		v.startSynths(28);
		q.startSynths(120);
		s.sync;
		~vPulseFunc.(pulses);
		q.setAllSynths(\rel, 0.01);
		q.loopSynth.set(\loopSpeed, 1/2); q.loopSynth.set(\controlLoopBuf, ~slowFine[0]);
	}.fork
};

~cuesList[7] = {
	{
		~vPulseFunc.(0);
		q.loopSynth.set(\loopSpeed, 1); q.loopSynth.set(\controlLoopBuf, ~slowFine[1]);
	}.fork
};

~cuesList_reverse[7] = {
	~freezeV.(false);
	~freezeQ.(false);
};
~cuesList[8] = {
	{
		~freezeV.(true);
		~freezeQ.(true);
		{~loopST1Button.valueAction = 1}.defer;
		{~loopST2Button.valueAction = 1}.defer;
		v.loopSynth.set(\mbSelect, 0.5);
	}.fork
};

// seite 3. loops aendern immer tempi. sie werden ausserdem rauer. dann kommen pulse dazu (mit hoeheren pulstempi)

~cuesList_reverse[8] = {
	v.freqMult = 1;
	v.startSynths(28);
};
~cuesList[9] = {
	q.loopSynth.set(\loopSpeed, 1/3);
	q.loopSynth.set(\controlLoopBuf, ~slowFine[0]);
	v.loopSynth.set(\loopSpeed, 1/2);
	v.loopSynth.set(\controlLoopBuf, ~steps[0]);
	v.freqMult = 0.5;
	v.startSynths(28);
};

~cuesList[10] = {
	q.loopSynth.set(\loopSpeed, 1/4);
	q.loopSynth.set(\controlLoopBuf, ~steps[1]);
	v.loopSynth.set(\loopSpeed, 1/4);
	v.loopSynth.set(\controlLoopBuf, ~steps[2]);
	q.startSynths(28);
	v.freqMult = 1;
	v.startSynths(28);
};

~cuesList[11] = {
	var pulses = 50.linlin(0, 127, 0, ~maxBands - 1).asInteger;
	q.loopSynth.set(\loopSpeed, 1/8);
	q.loopSynth.set(\controlLoopBuf, ~slowRough[0]);
	v.loopSynth.set(\loopSpeed, 1/8);
	v.loopSynth.set(\controlLoopBuf, ~slowFine[1]);
	~vPulseFunc.(pulses);
	v.setAllSynths(\lfoSpeed, 2);
	~midiStates.vLfoIndex = 3;
};

~cuesList[12] = {
	var pulses = 90.linlin(0, 127, 0, ~maxBands - 1).asInteger;
	// {
	// q.startSynths(28);
	// s.sync;
	q.loopSynth.set(\loopSpeed, 1);
	v.loopSynth.set(\controlLoopBuf, ~slowRough[1]);
	~vPulseFunc.(pulses);
	~qPulseFunc.(pulses);
	q.setAllSynths(\lfoSpeed, 2);
	~midiStates.qLfoIndex = 3;
	// }.fork
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
	q.startSynths(20);
	q.loopSynth.set(\loopStart, -150);
	q.loopSynth.set(\loopSpeed, 1/2);
	q.loopSynth.set(\controlLoopBuf, ~steps[0]);
	v.loopSynth.set(\loopStart, -150);
	v.loopSynth.set(\loopSpeed, 1/2);
	v.loopSynth.set(\controlLoopBuf, ~steps[0]);
};

~cuesList[15] = {
	v.startSynths(28);
	q.startSynths(14);
	q.loopSynth.set(\loopSpeed, 1);
	q.loopSynth.set(\controlLoopBuf, ~steps[1]);
	v.loopSynth.set(\loopSpeed, 1/2);
	v.loopSynth.set(\controlLoopBuf, ~steps[2]);
	v.loopSynth.set(\loopStartLfoAmt, 0);
	q.loopSynth.set(\loopStartLfoAmt, 0);
};

~cuesList[16] = {
	v.startSynths(20);
	q.startSynths(10);
	q.loopSynth.set(\loopSpeed, 1.5);
	q.loopSynth.set(\controlLoopBuf, ~steps[1]);
	v.loopSynth.set(\loopSpeed, 1/4);
	v.loopSynth.set(\controlLoopBuf, ~slowFine[0]);
};

~cuesList[17] = {
	v.startSynths(14);
	q.loopSynth.set(\loopSpeed, 3);
	q.loopSynth.set(\controlLoopBuf, ~slowFine[1]);
	v.loopSynth.set(\loopSpeed, 1/2);
	v.loopSynth.set(\controlLoopBuf, ~slowRough[0]);
};

~cuesList_reverse[17] = {
	~freezeV.(false);
	~freezeQ.(false);
};
~cuesList[18] = {
	v.startSynths(10);
	q.loopSynth.set(\loopSpeed, 1/2);
	q.loopSynth.set(\controlLoopBuf, ~slowFine[2]);
	v.loopSynth.set(\loopSpeed, 1/2);
	v.loopSynth.set(\controlLoopBuf, ~slowRough[1]);
	~freezeV.(true);
	~freezeQ.(true);
};
~cuesList[19] = {
	v.loopSynth.set(\loopSpeed, 1/4);
};
~cuesList[20] = {
	v.loopSynth.set(\loopSpeed, 1/8);
};
~cuesList[21] = {
	v.loopSynth.set(\loopSpeed, 1/16);
};
~cuesList[22] = {
	v.loopSynth.set(\loopSpeed, 1/32);
};
~cuesList[23] = {
	v.loopSynth.set(\loopSpeed, 1/64);
};
~cuesList[24] = {
	v.loopSynth.set(\loopSpeed, 1/512);
};
