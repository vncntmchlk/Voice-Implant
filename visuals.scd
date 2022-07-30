//create a monitoring bus for the descriptors
// b = Bus.new(\control,0,150);

//create a monitoring window for the values
~gui = ();
~gui.width = 1920;
~gui.height = 1080;
~gui.offsetX = 1920;
~gui.win = Window("Mel Bands Monitor", Rect(~gui.offsetX, 0, ~gui.width, ~gui.height), false, false).front;
~gui.win.background = Color.black;
~gui.alpha1 = 1;
~gui.alpha2 = 1;
// Voice 1
// ~gui.voiceView = MultiSliderView(~gui.win,Rect(~gui.width / 2, 0, ~gui.width / 2, ~gui.height)).elasticMode_(1).isFilled_(1)
~gui.voiceView = MultiSliderView(~gui.win,Rect(0,0,~gui.width / 2, ~gui.height)).elasticMode_(1).isFilled_(1)
.indexIsHorizontal_(false)
.drawLines_(true)
.drawRects_(false)
.readOnly_(true);
~gui.voiceView.strokeColor = Color.gray(0, ~gui.alpha1);
~gui.voiceView.fillColor = Color.gray(0, ~gui.alpha1); //Color.new(0.2,0,0, ~gui.alpha1);
~gui.voiceView.background = Color.gray(1, ~gui.alpha1);

// ~gui.electronicsView = MultiSliderView(~gui.win,Rect(0, 0, ~gui.width / 2, ~gui.height)).elasticMode_(1).isFilled_(1)
~gui.electronicsView = MultiSliderView(~gui.win,Rect(~gui.width / 2, 0, ~gui.width / 2, ~gui.height)).elasticMode_(1).isFilled_(1)
.indexIsHorizontal_(false)
.drawLines_(true)
.drawRects_(false)
.readOnly_(true);
~gui.electronicsView.strokeColor = Color.gray(1, ~gui.alpha1);
~gui.electronicsView.fillColor = Color.gray(0, ~gui.alpha1);//Color.new(0.2,0,0, ~gui.alpha1);
~gui.electronicsView.background = Color.gray(1, ~gui.alpha1);

// Voice 2
~gui.win2 = Window("Mel Bands Monitor", Rect(~gui.offsetX, 0, ~gui.width, ~gui.height), false, false).front;
~gui.win2.background = Color.black;

// ~gui.voiceView2 = MultiSliderView(~gui.win2,Rect(~gui.width / 2, 0, ~gui.width / 2, ~gui.height)).elasticMode_(1).isFilled_(1)
~gui.voiceView2 = MultiSliderView(~gui.win2,Rect(0, 0, ~gui.width / 2, ~gui.height)).elasticMode_(1).isFilled_(1)
.indexIsHorizontal_(false)
.drawLines_(true)
.drawRects_(false)
.readOnly_(true);
~gui.voiceView2.strokeColor = Color.gray(0, ~gui.alpha2);
~gui.voiceView2.fillColor = Color.gray(0, ~gui.alpha2);//Color.new(0,0,0.2, ~gui.alpha2);
~gui.voiceView2.background = Color.gray(1, ~gui.alpha2);

// ~gui.electronicsView2 = MultiSliderView(~gui.win2,Rect(0, 0, ~gui.width / 2, ~gui.height)).elasticMode_(1).isFilled_(1)
~gui.electronicsView2 = MultiSliderView(~gui.win2,Rect(~gui.width / 2, 0, ~gui.width / 2, ~gui.height)).elasticMode_(1).isFilled_(1)
.indexIsHorizontal_(false)
.drawLines_(true)
.drawRects_(false)
.readOnly_(true);
~gui.electronicsView2.strokeColor = Color.gray(1, ~gui.alpha2);
~gui.electronicsView2.fillColor = Color.gray(0, ~gui.alpha2);//Color.new(0,0,0.2, ~gui.alpha2);
~gui.electronicsView2.background = Color.gray(1, ~gui.alpha2);



~gui.winRange = 0.05;
~gui.frameRate = (1/25) * 0.5;
~gui.updateWindow = Routine {
	{
		v.melBus.get({ arg val;
			{
				if(~gui.win.isClosed.not) {
					~gui.electronicsView.value = val[..v.numBands] / ~gui.winRange
					// ~gui.electronicsView.value = (~gui.winRange - val[..v.numBands])/~gui.winRange
				}
			}.defer
		});
		v.visBus.get({ arg val;
			{
				if(~gui.win.isClosed.not) {
					// ~gui.voiceView.value = val[..v.numBands] / ~gui.winRange;
					~gui.voiceView.value = (~gui.winRange - val[..v.numBands])/~gui.winRange;
				}
			}.defer
		});
		~gui.frameRate.wait;
		q.melBus.get({ arg val;
			{
				if(~gui.win.isClosed.not) {
					// ~gui.electronicsView2.value = (~gui.winRange - val[..q.numBands])/~gui.winRange;
					~gui.electronicsView2.value = val[..q.numBands] / ~gui.winRange
				}
			}.defer
		});
		q.visBus.get({ arg val;
			{
				if(~gui.win.isClosed.not) {
					// ~gui.voiceView2.value = val[..q.numBands] / ~gui.winRange
					~gui.voiceView2.value = (~gui.winRange - val[..q.numBands])/~gui.winRange;
				}
			}.defer
		});
		~gui.frameRate.wait;
	}.loop
}.play;
