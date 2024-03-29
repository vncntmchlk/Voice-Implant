~makeEv = { |freqMult = 1|
	(
		freqMult: freqMult,
		minFreq: 880,
		maxFreq: 7000,
		numBands: 10,
		randomOrder: (0..(~maxBands - 1)).scramble,
		fftSize: 2.pow(10),
		calcMelValues: {|self|
			self.lowMel =  1127.010498 * ((self.minFreq/700) + 1).log;
			self.highMel = 1127.010498 * ((self.maxFreq/700) + 1).log;
			self.rangeMel = self.highMel - self.lowMel;
			self.stepMel = self.rangeMel / (self.numBands + 1);
		},
		freqAtStep: {|self, i|
			var freqMel = (self.stepMel * (i +1)) + self.lowMel;
			((freqMel/ 1127.01048).exp - 1 ) * 700;
		},
		synthParams: (rel: 0.05, ampThresh: 0.0005, lfoSpeed: 1),
		setAllSynths: {|self, param, val|
			self.synthGroup.set(param, val);
			self.synthParams[param] = val
		},
		synthArray: Array.newClear(150), // numBands
		startSynths: { |self, numBands = 10|
			var ampThreshFactor = 10 / numBands;
			var ampFactor = numBands.linlin(10,120,1,2);
			self.numBands = numBands;
			self.analyseSynth.set(\numBands, numBands);
			self.analyseSynth.set(\minFreq, self.minFreq);
			self.analyseSynth.set(\maxFreq, self.maxFreq);
			self.calcMelValues;
			if(self.lastNumBands.isNil){
				self.numBands.do{ |i|
					self.synthArray[i] = Synth(\sine, [
						\busIndex, self.loopBus.index + i,
						\visBusIndex, self.visBus.index + i,
						\lfoSpeed, self.synthParams.lfoSpeed,
						\pulseOn, 0,
						\pulseSpeed, [5, 7, 11].choose,
						\pulseLow, [0.5, 1].choose,
						\pulseHi, [1, 2].choose,
						\freq, self.freqAtStep(i) * self.freqMult,
						\ampThreshFactor, ampThreshFactor,
						\ampFactor, ampFactor,
						\out, self.outChn,
						\rel, self.synthParams.rel,
						\ampThresh, self.synthParams.ampThresh
					], self.synthGroup)
				};
			}{
				if(self.lastNumBands > self.numBands){
					self.synthArray[self.numBands..].do {|syn| syn.free };
					self.numBands.do{ |i|
						self.synthArray[i].set(\freq, self.freqAtStep(i) * self.freqMult);
						self.synthArray[i].set(\ampThreshFactor, ampThreshFactor);
						self.synthArray[i].set(\ampFactor, ampFactor);
					};
				}; // wenn sie gleich sind soll nichts passieren!
				if(self.lastNumBands < self.numBands){
					//update running
					self.lastNumBands.do {|i|
						self.synthArray[i].set(\freq, self.freqAtStep(i) * self.freqMult);
						self.synthArray[i].set(\ampThreshFactor, ampThreshFactor);
						self.synthArray[i].set(\ampFactor, ampFactor);
					};
					//start new
					(self.lastNumBands .. (self.numBands - 1)).do {|i|
						self.synthArray[i] = Synth(\sine, [
							\busIndex, self.loopBus.index + i,
							\visBusIndex, self.visBus.index + i,
							\lfoSpeed, self.synthParams.lfoSpeed,
							\pulseOn, 0,
							\pulseSpeed, [5, 7, 11].choose,
							\pulseLow, [0.5, 1].choose,
							\pulseHi, [1, 2].choose,
							\freq, self.freqAtStep(i) * self.freqMult,
							\ampThreshFactor, ampThreshFactor,
							\ampFactor, ampFactor,
							\out, self.outChn,
							\rel, self.synthParams.rel,
							\ampThresh, self.synthParams.ampThresh
						], self.synthGroup)
					}
				};
				// wenn sie gleich sind nur freq updaten
				if(self.lastNumBands == self.numBands){
					self.numBands.do{ |i|
						self.synthArray[i].set(\freq, self.freqAtStep(i) * self.freqMult);
					};
				};
			};

			self.lastNumBands = self.numBands;
		},
		initRouting: {|self, mainGroup, outChn|
			self.outChn = outChn;
			self.phaseBus ?? {self.phaseBus = Bus.audio(s, 1)};
			self.loopBus ?? {self.loopBus = Bus.control(s, ~maxBands)};
			self.visBus ?? {self.visBus = Bus.control(s, ~maxBands)};
			self.melBus ?? {self.melBus = Bus.control(s, ~maxBands)};
			self.melBuf ?? {self.melBuf = Buffer.alloc(s, (s.sampleRate / s.options.blockSize) * 120, ~maxBands)};
			self.analyseGroup = Group.new(mainGroup, 'addToHead');
			self.loopGroup = Group.new(self.analyseGroup, 'addAfter');
			self.synthGroup = Group.new(self.loopGroup, 'addAfter');
		},
		startAnalyse: {|self|
			self.analyseSynth = Synth(\analyseSynth, [
				\input, 12,
				\numBands, self.numbands,
				\minFreq, self.minFreq,
				\maxFreq, self.maxFreq,
				\melBuf, self.melBuf,
				\phaseBus, self.phaseBus,
				\melBus, self.melBus
			], self.analyseGroup)
		},
		startLoop: {|self, controlIn|
			self.loopSynth = Synth(\loopSynth, [
				\melBus, self.melBus,
				\phaseBus, self.phaseBus,
				\melBuf, self.melBuf,
				\loopBus, self.loopBus,
				\controlLoopBuf, ~sine,
				\loopSpeed, 1/6,
				\loopStart, -600
				//\controlIn, controlIn
			], self.loopGroup);
		}
	)
}
