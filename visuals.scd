//create a monitoring bus for the descriptors
// b = Bus.new(\control,0,150);

//create a monitoring window for the values
~gui = ();
~gui.win = Window("Mel Bands Monitor", Rect(0, 0, 600, 600), false, true).front;
// w.alpha = 0.7;
~gui.voiceView = MultiSliderView(~gui.win,Rect(0, 0, 300, 600)).elasticMode_(1).isFilled_(1)
.indexIsHorizontal_(false)
.drawLines_(true)
.drawRects_(false)
.readOnly_(true);
~gui.voiceView.strokeColor = Color.gray(0, 1);
~gui.voiceView.fillColor = Color.gray(0, 1);
~gui.voiceView.background = Color.gray(1, 1);

~gui.electronicsView = MultiSliderView(~gui.win,Rect(300, 0, 300, 600)).elasticMode_(1).isFilled_(1)
.indexIsHorizontal_(false)
.drawLines_(true)
.drawRects_(false)
.readOnly_(true);
~gui.electronicsView.strokeColor = Color.gray(1, 1);
~gui.electronicsView.fillColor = Color.gray(0, 1);
~gui.electronicsView.background = Color.gray(1, 1);

// a.drawRects = false

//run the window updating routine.

~gui.winRange = 0.05;
~gui.frameRate = (1/25);
~gui.updateWindow = Routine {
	{
		v.melBus.get({ arg val;
			{
				if(~gui.win.isClosed.not) {
					~gui.electronicsView.value = val[..v.numBands] / ~gui.winRange
				}
			}.defer
		});
		v.visBus.get({ arg val;
			{
				if(~gui.win.isClosed.not) {
					~gui.voiceView.value = (~gui.winRange - val[..v.numBands])/~gui.winRange;
				}
			}.defer
		});
		~gui.frameRate.wait;
	}.loop
}.play;
