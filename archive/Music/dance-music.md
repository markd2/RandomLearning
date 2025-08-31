# Oontz Oontz Oontz Oontz

* [My Soundclown](https://soundcloud.com/borkware)

## Edumacation

* https://www.proaudioears.com/ - Dance Music Production's ear training games. (HARD!)
* https://dancemusicproduction.com/ - Dance Music Production (SubClub gets access to all the DMP tutorial DVD content, which goes pretty deep)

## Plugins

* https://www.soundtoys.com/ - Sound Toys
* Xfer Records (Steve Duda)
    - LFO Tool - https://xferrecords.com/products/lfo-tool
    - Serum Wavetable Synthesizer - https://xferrecords.com/products/serum
* Native Instruments
  - Komplete (for all the things) - https://www.native-instruments.com/en/products/komplete/bundles/komplete-14-standard/
  - Battery 4 (drum sampler) - https://www.native-instruments.com/en/products/komplete/drums/battery-4/

# Stuff Gleaned from Videos

Questions when listening to stuff

  - was there a bass line?
  - if so what was it doing?  
      - Changing pitch?
      - offbeat?
      - real or synth?
      - how many pitches and did it change
  - what drums were there
      - kick, of course, what else?
      - snare? 
      - open/closed hat?
      - cymbal?
  - was there a melody?
    - what did it play?
    - constant tone or rise and fall
    - what instrument
  - hear any effects?
    - delay on anything?
    - reverb?
    - chorus?
    - filter?
  - how did the arrangement go?

Picking samples from [DMP French house](https://www.dancemusicproduction.com/product/french-house/)
  - sample a short part that changes in pitch
  - ignore the bass, concentrae on the high frequency instruments
  - try to sample out of context of the original record
  - sample a little more than intended for the Stockhausen Effect

Making a funky bass
  - take your chord
  - essentially triplets for each beat
  - raise the middle up an octave
  - fiddle with shorter notes to give some drive
  - echo boy, some distortion (Decapitator)
  - Tube Tech CL1B compressor for some groove.
    - Which I don't have.  It's an optical compressor. NI VC-2A is an opto, but doesn't seem to have direct control over the usual compressor parameters
    - longer attack, bass will sweep in lower freq more prominent
    - fast attack stage more prominent


### Transients

1176 compressor on a rock drum. The FET tends to clamp donw and
distort the transient, adds punch, and brings snare to the front
of the mix.

Transient engery can move the sound forward (or back) in the mix

### Reverb

Types and Uses

* Hall - adds height
  - large spaces, for long smooth decay
  - reflections farther apart
  - lower diffusion than room.
* Spring - adds character
  - "easy to hear" - manifestations of a vibrating spring
  - low diffusion, but a metallic bouncy texture
  - sounds flat, not 3-D sound
    - (sounds kind of weird)
* Room - adds depth
  - smaller rooms, living rooms. Short decay times and closer reflections.
* Plate - adds width and dimension
  - a huge vibrating metal plate with contact microphones
  - always sound bright with metallic edge. And heavily diffused (describes how close the reflections)
  - high diffusion compared to room - reflections close together
  - sounds kind of flat
  - often have a filter to roll off the highs

### Prog Trance

* Find a loop, cut out interesting part
  - LFOTool to take out kick ("reverse sidechain")
  - Or put into a sampler (e.g. Battery 4)

* Battery 4 subliminal modulation.  Velocity changing
  - Volume
  - Tune
  - Cutoff

* Can use LFO tool hi-band cutoff to remove zero-crossing click (or leftover hats from samples)


# Stuff gleaned from Slack

* Find a schematic of dB levels for your genre with a breakdown, for a place to start. for example, kick -6dB, subbass -12dB, pads/non-main-melodies -14dB, main melodies -12dB, vocals -10 to -6dB, effects -18dB, snare matching loudness of kick(depends on the type of snare for dB)
* After you have the rough schematic, use a pink noise generator and isolate each instrument until you can just barely hear it while playing pink noise at -6dB.
* Izotope's Tonal Balance Control can really show you what is wrong with first iterations of an arrangement/mix.
* Cut reverb tails abruptly (fade out, not Phil Collins style) to sound more modern, don't let tails step on the next note (unless you're going for a washed out vibe)
* Use clipping with your gain staging to cut peaks, using oversampling to get the most of digital world (cut peaks will be less distorted with oversampling, in theory)
* Use arrangement to fix mix issues, less is often more, but not always.
* A clear focused "lead" is usually helpful to guide the audience.
* Keep air pushing through the sub, even if it's not a bass heavy part. If a sub disappears fully and it's not a breakdown or something, the whole room will wonder why and it is very distracting.
* Use MIDI to sidechain because it will trigger faster and it's easier to edit/bump up a tad/pull back a bit.

and a reply (not me!) 

I feel like the "Cut reverb tails abruptly" is 100% a stylistic
decision, but a very useful one to be aware of. I like to interchange
it depending on the situation. Cutting a reverb off like that makes me
think of the effect dance music has when it cuts from space to
space. It's like instantly teleporting from one space to another.

A more artistic way you could think about it is, the listener
travelling through a tunnel at a very high speed, and in there is a
bunch of reverberation, but at the end of that measure, the reverb
stops suddenly when they exit the tunnel and no longer hear
reverb. That's why I think it's a very stylistic decision. As artists,
we're painting with sound and teleporting people to these worlds of
their imagination.

