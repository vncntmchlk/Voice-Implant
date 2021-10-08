~cueWindow = Window.new(bounds:Rect(1000,100,250,250)).front;
~cueText = StaticText(~cueWindow, Rect(10, 10, 200, 20));
~cueText.string = "CUE: 1";
~loopST1Button = Button(~cueWindow, Rect(10, 125, 100, 100));
~loopST1Button.states = [["1 OFF", Color.grey, Color.white], ["1 ON", Color.white, Color.grey]];

~loopST2Button = Button(~cueWindow, Rect(125, 125, 100, 100));
~loopST2Button.states = [["2 OFF", Color.grey, Color.white], ["2 ON", Color.white, Color.grey]];