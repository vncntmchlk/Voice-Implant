~makeEv = {
	(
		minFreq: 880,
		maxFreq: 7000,
		numBands: 10,
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
		synthArray: Array.newClear(150), // numBands
		startSynths: { |self, numBands = 10, out = 4|
			self.numBands = numBands;
			self.analyseSynth.set(\numBands, numBands);
			self.calcMelValues;
			if(self.lastNumBands.isNil){
				self.numBands.do{ |i|
					self.synthArray[i] = Synth(\sine, [
						\busIndex, self.loopBus.index + i,
						\freq, self.freqAtStep(i),
						\out, out
					], self.synthGroup)
				};
			}{
				if(self.lastNumBands > self.numBands){
					self.synthArray[self.numBands..].do {|syn| syn.free };
					self.numBands.do{ |i| self.synthArray[i].set(\freq, self.freqAtStep(i))};
				}{
					//update running
					self.lastNumBands.do {|i| self.synthArray[i].set(\freq, self.freqAtStep(i))};
					//start new
					(self.lastNumBands .. (self.numBands - 1)).do {|i|
						self.synthArray[i] = Synth(\sine, [
							\busIndex, self.loopBus.index + i,
							\freq, self.freqAtStep(i),
							\out, out
						], self.synthGroup)
					}
				};
			};

			self.lastNumBands = self.numBands;
		},
		initRouting: {|self|
			self.phaseBus ?? {self.phaseBus = Bus.audio(s, 1)};
			self.loopBus ?? {self.loopBus = Bus.control(s, ~maxBands)};
			self.melBus ?? {self.melBus = Bus.control(s, ~maxBands)};
			self.melBuf ?? {self.melBuf = Buffer.alloc(s, (s.sampleRate / s.options.blockSize) * 120, ~maxBands)};
			self.analyseGroup = Group.new();
			self.loopGroup = Group.new(self.analyseGroup, 'addAfter');
			self.synthGroup = Group.new(self.loopGroup, 'addAfter');
		},
		startAnalyse: {|self|
			self.analyseSynth = Synth(\analyseSynth, [
				\input, 4,
				\numBands, self.numbands,
				\minFreq, self.minFreq,
				\maxFreq, self.maxFreq,
				\melBuf, self.melBuf,
				\phaseBus, self.phaseBus,
				\melBus, self.melBus
			], self.analyseGroup)
		},
		startLoop: {|self|
			self.loopSynth = Synth(\loopSynth, [
				\melBus, self.melBus,
				\phaseBus, self.phaseBus,
				\melBuf, self.melBuf,
				\loopBus, self.loopBus
			], self.loopGroup);
		}
	)
}
