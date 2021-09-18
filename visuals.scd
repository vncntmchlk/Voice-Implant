//create a monitoring bus for the descriptors
b = Bus.new(\control,0,150);

//create a monitoring window for the values

(
w = Window("Mel Bands Monitor", Rect(0, 0, 600, 600), false, false).front;
w.alpha = 0.7;
a = MultiSliderView(w,Rect(0, 0, 300, 600)).elasticMode_(1).isFilled_(1)
.indexIsHorizontal_(false)
.drawLines_(true)
.drawRects_(false)
.readOnly_(true);

g = MultiSliderView(w,Rect(300, 0, 300, 600)).elasticMode_(1).isFilled_(1)
.indexIsHorizontal_(false)
.drawLines_(true)
.drawRects_(false)
.readOnly_(true);
)
a.drawRects = false

//run the window updating routine.
(
~winRange = 0.1;
~frameRate = (1/60);
r = Routine {
    {
        b.get({ arg val;
            {
                if(w.isClosed.not) {
					a.value = (0.1 - val)/~winRange;
					g.value = val / ~winRange
                }
            }.defer
        });
        ~frameRate.wait;
    }.loop
}.play
)

//play a simple sound to observe the values
(
x =     {
    var source = SinOsc.ar(LFTri.kr(0.1).exprange(80,8000),0,0.1);
    Out.kr(b,FluidMelBands.kr(source,maxNumBands:150));
    source.dup;
}.play;
)

// free this source
x.free

// load a more exciting one
c = Buffer.read(s,File.realpath(FluidMelBands.class.filenameSymbol).dirname.withTrailingSlash ++ "../AudioFiles/Tremblay-AaS-SynthTwoVoices-M.wav");

// analyse with parameters to be changed
(
x =     {arg bands = 150, low = 20, high = 20000;
    var source = PlayBuf.ar(1,c,loop:1);
    Out.kr(b,FluidMelBands.kr(source, bands, low, high, 40) / 10);
    source.dup;
}.play;
)

//set the winRange to a more informative value
~winRange = 0.05;

// observe the number of bands. The unused ones at the top are not updated
x.set(\bands,20)

// back to thefull range
x.set(\bands,150)

// focus all the bands on a mid range: nothing to see!
x.set(\low,320, \high, 800)

// focusing on the low end shows the fft resolution issue. One could restart the analysis with a larger fft to show more precision
x.set(\low,20, \high, 160)

// back to full range
x.set(\low,20, \high, 20000)

// free everything
x.free;b.free;c.free;r.stop;