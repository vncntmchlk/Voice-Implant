/*v.loopSynth.set(\controlLoopBuf, ~steps[0])

~slowRough
~slowFine.size
~steps*/

~cuesListFades = Order.new(size: 30);
~cuesListST1 = Order.new(size: 30);
~cuesListST2 = Order.new(size: 30);

// nil heisst wird nicht geaendert (weil es manuell passiert)
// 0 ST1/2 %, 1 FxWet %
~cuesListFades[0] = [0, 0];
~cuesListFades[1] = [0, 100];
~cuesListFades[2] = [0, 100];
~cuesListFades[3] = [0, nil];
~cuesListFades[4] = [0, 100];
~cuesListFades[5] = [50, 50];
~cuesListFades[6] = [50, 50];
~cuesListFades[7] = [25, 75];
~cuesListFades[8] = [15, 90];
~cuesListFades[9] = [0, 100];
~cuesListFades[10] = [30, 80];
~cuesListFades[11] = [70, 60];
~cuesListFades[12] = [100, 60];
~cuesListFades[13] = [50, 75];
~cuesListFades[14] = [50, 75];
~cuesListFades[15] = [20, 80];
~cuesListFades[16] = [0, 80];
~cuesListFades[17] = [0, nil];
~cuesListFades[18] = [0, nil];
~cuesListFades[19] = [nil, nil];
~cuesListFades[20] = [nil, nil];
~cuesListFades[21] = [nil, nil];

// ST 1
// Pulses, Release, Ampthresh, Sync, Loop, numBands
~cuesListST1[0] = [0, 0.03, 0.0005, 100, 0, 10];
~cuesListST1[1] = [0, 0.03, 0.0005, 100, 0, 10];
~cuesListST1[2] = [0, 0.03, 0.0005, 100, 0, 10];
~cuesListST1[3] = [0, 0.03, 0.0005, nil, 0, 10];
~cuesListST1[4] = [0, 0.03, 0.0005, 0, 1, 10];
~cuesListST1[5] = [0, 0.03, 0.0005, 0, 1, 10];
~cuesListST1[6] = [15, 0.03, 0.0005, 50, 0, 14];
~cuesListST1[7] = [30, 0.03, 0.0005, 75, 0, 20];
~cuesListST1[8] = [50, 0.03, 0.0005, 90, 0, 40];
~cuesListST1[9] = [100, 0.03, 0.0005, 100, 0, 120];
~cuesListST1[10] = [30, 0.03, 0.0005, 75, 0, 40];
~cuesListST1[11] = [0, 0.03, 0.0005, 50, 0, 40];
~cuesListST1[12] = [0, 0.03, 0.0005, 50, 0, 14];
~cuesListST1[13] = [0, 0.03, 0.0005, nil, nil, 20];
~cuesListST1[14] = [0, 0.03, 0.0005, nil, nil, 40];
~cuesListST1[15] = [0, 0.3, 0.0005, 80, 0, 120];
~cuesListST1[16] = [0, 0.5, 0.0005, 100, 0, 120];
~cuesListST1[17] = [0, 0.5, 0.0005, 100, 0, 120];
~cuesListST1[18] = [100, 0.5, 0.0005, nil, 0, 120];
~cuesListST1[19] = [0, 0.03, 0.0005, nil, nil, 120];
~cuesListST1[20] = [0, 0.03, 0.0005, nil, nil, 40];
~cuesListST1[21] = [0, 0.03, 0.0005, 0, 1, 10];

// ST 1
// Pulses, Release, Ampthresh, Sync, Loop, numBands
~cuesListST2[0] = [0, 0.03, 0.0005, 100, 0, 40];
~cuesListST2[1] = [0, 0.03, 0.0005, 100, 0, 40];
~cuesListST2[2] = [0, 0.03, 0.0005, 100, 0, 40];
~cuesListST2[3] = [0, 0.03, 0.0005, 100, 0, 40];
~cuesListST2[4] = [0, 0.03, 0.0005, 100, 0, 40];
~cuesListST2[5] = [0, 0.1, 0.0005, 100, 0, 40];
~cuesListST2[6] = [0, 0.1, 0.0005, 80, 0, 40];
~cuesListST2[7] = [0, 0.2, 0.0005, 60, 0, 40];
~cuesListST2[8] = [0, 0.2, 0.0005, 30, 0, 40];
~cuesListST2[9] = [0, 0.2, 0.0005, 30, 0, 40];
~cuesListST2[10] = [0, 0.03, 0.0005, 30, 0, 120];
~cuesListST2[11] = [0, 0.03, 0.0005, 0, 1, 120];
~cuesListST2[12] = [0, 0.03, 0.0005, 40, nil, 120];
~cuesListST2[13] = [0, 0.03, 0.0005, nil, nil, 40];
~cuesListST2[14] = [0, 0.03, 0.0005, nil, nil, 40];
~cuesListST2[15] = [50, 0.03, 0.0005, 80, 0, 20];
~cuesListST2[16] = [50, 0.03, 0.0005, 80, 0, 20];
~cuesListST2[17] = [50, 0.03, 0.0005, 80, 0, 20];
~cuesListST2[18] = [50, 0.03, 0.0005, 80, 0, 20];
~cuesListST2[19] = [0, 0.03, 0.0005, nil, nil, 20];
~cuesListST2[20] = [0, 0.03, 0.0005, nil, nil, 10];
~cuesListST2[21] = [0, 0.03, 0.0005, 0, 1, 10];