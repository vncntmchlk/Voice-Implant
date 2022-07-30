~newBuf = { |segments, curve, duration, quant, walkAmt|
	var walk = Pbrown(0,1,0.01).asStream;
	var env = Env.new(
		{ 0.001.exprand(1.0) + (walk.next * walkAmt) } ! segments,
		({1.0.rand.roundUp(quant)} ! (segments - 1)).normalizeSum,
		curve
	);
	env = env.asSignal(s.sampleRate / s.options.blockSize * duration);
	env = env.as(Array);
	env = env.normalize;
	Buffer.loadCollection(s, env);
};

~newBuf_sine = { |duration|
	var env = Env.sine(duration, 1);
	env = env.asSignal(s.sampleRate / s.options.blockSize * duration);
	env = env.as(Array);
	env = env.normalize;
	Buffer.loadCollection(s, env);
};

Routine {
	thisThread.randSeed = 1337;
	~slowRough = 3.collect {~newBuf.(350, \lin, 1, (1/20), 1000)};
	~slowFine = 3.collect {~newBuf.(5, \lin, 1, (1/20), 1000)};
	~steps = 5.collect {~newBuf.(21, \step, 1, (1/8), 5)};
	~sine = ~newBuf_sine.(1);
}.play;
