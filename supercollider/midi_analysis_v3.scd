(
Server.default.boot;
o = Server.default.options;
o.inDevice_("Built-in Microph");
o.outDevice_("Built-in Output");
)



(
~n1 = NetAddr.new("127.0.0.1", 7771);
MIDIClient.init;

MIDIIn.connectAll;
)

(

~notes = Array.newClear(128);
~notesA = Array2D.new(rows: 3, cols: 128);


MIDIdef.noteOn(\noteOnctrl, {
	arg vel, nn;
	[vel, nn].postln;
    //create and store synths for each note
	~notes[nn] = Synth.new( \tone, [ \freq, nn.midicps, \amp, vel.linexp(1,127,0.01,0.3), \gate, 1,]);
	~notesA[0,nn] = vel;
	~notesA[1,nn] = nn;
	~notesA[2,nn] = true;
	[~notesA[0,nn].linlin(0,127,0,255), ~notesA[1,nn],~notesA[2,nn]].postln;
	~n1.sendMsg('/on', ~notesA[0,nn].linlin(0,127,0,255).asFloat, ~notesA[1,nn])
}
);



MIDIdef.noteOff(\noteOffctrl, {
	/*in this function i will address the synth at the correct index corresponding to its notenumber and set the gate argument of that synth to 0. Then replace the synth with a nil value, like that synth was never there*/
	arg nn;
	//[vel, nn].postln;
	~notes[nn].set(\gate, 0);
	~notes[nn] = nil;
	//~notesA[2,nn] = ~notesA[2,nn].beats;
	~notesA[2,nn] = false;
	//[~notesA[0,nn].linlin(0,127,0,255), ~notesA[1,nn], ~notesA[2,nn]].postln;
	[~notesA[1,nn],~notesA[2,nn]].postln;

	//send message
	//~n1.sendMsg('/test', ~notesA[0,nn].linlin(0,127,0,255).asFloat, ~notesA[1,nn]%12, (~notesA[2,nn].asFloat)*100);
	~n1.sendMsg('/off', ~notesA[1,nn]);

}
);


(
SynthDef.new(\tone, {
	arg freq=440, amp=0.3, gate=0;
	var sig, env;
	sig = LFTri.ar(freq)!2;
	env = EnvGen.kr(Env.adsr, gate, doneAction:2);
	sig = sig * env * amp;
	Out.ar(0, sig);
}).add;
)

)

(
MIDIClient.destinations;
m = MIDIOut.new(0);
)

// Melody 1
b = Array2D.fromArray(2,18,[ 62, 62, -0.5, 62, 62, 57, 55, 61, 57, 50, 50, -0.5, 52, 50, 54, 54, 54, 52, 0.25, 0.5, -0.5, 0.25, 0.5, 0.5, 1, 0.25, 0.25, 0.25, 0.5, -0.5, 0.25, 0.5, 0.5, 1, 0.25, 0.25 ]);

//Melody 2
b = Array2D.fromArray(2,16,[ 60, 62, 67, 72, 69, 72, 72, 71, 71, 72, 72, 69, 72, 67, 62, 60, 0.5, 0.5, 1, 0.5, 0.5, 0.25, 0.5, 0.25, 0.5, 0.5, 1, 0.5, 0.5, 0.25, 0.5, 0.25 ]);

//Melody 3
b = Array2D.fromArray(2,29,[ 62, 66, 66, 67, -0.25, 69, 73, 62, 66, 66, 67, -0.25, 69, 73, 73, 69, 67, 66, -0.25, 66, 62, 66, 62, 66, -0.25, -0.125, 69, 66, 67, 0.25, 0.25, 0.25, 0.5, -0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.5, -0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.5, -0.25, 0.25, 0.25, 0.125, 0.25, 0.5, -0.25, -0.125, 0.25, 0.25, 0.25 ]);

(
r = Routine({
	{
		b.colsDo{
			arg nn;
		    if (nn[0] > 0,
			{
				m.noteOn(0,nn[0],60);
				nn[1].wait;
				m.noteOff(0,nn[0],nn[0]);
			},{
				nn[1].wait;
		    }
		);
		};
	}.loop;
}).play;

)







(
r.stop;
(0..127).do{arg n; m.noteOff(0,n,n)};
)


b = NetAddr.new("127.0.0.1", 7771);    // create the NetAddr
b.sendMsg("/hello", "there");

o = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln; }, '/goodbye', n);
o.free;    // remove the OSCFunc when you are done.



