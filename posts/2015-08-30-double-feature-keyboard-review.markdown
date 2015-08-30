---
title: Double Feature keyboard review!
tags: hardware, keyboard, code87, atreus
---

## Code 87

Last year, after many months spent in thinking, scouting the market
and evaluating, I eventually bought myself a mechanical keyboard. I
chose the
[CODE 87](http://www.wasdkeyboards.com/index.php/code-87-key-mechanical-keyboard.html)
model by [WASD Keyboards](http://www.wasdkeyboards.com/), a keyboard
designed and produced together with
[Jeff Atwood](http://blog.codinghorror.com/the-code-keyboard/): it is
a distillation of their ideas about how keyboards should be.

I never had a mechanical keyboard before, besides the old and glorious
[IBM model M](https://en.wikipedia.org/wiki/Model_M_keyboard) back in
the high school days, when I was using a PS/2 80286.

But I have a penchant for keyboards, and I thought I could appreciate
the benefits I would gain from a more sophisticated construction. 

I've now spent some months using the CODE Keyboard every day at work,
so here my impressions.

### Construction

The common denominator of the reviews I read before buying and
receiving my CODE 87 is that they're sturdier and more reliable than
the average.  I concur.

The body is pleasantly heavy (wherever you put it, there it stays: it
takes more than the tension of a USB cable to move it).

I planned to use the keyboard in the office open space, and my
co-workers already made their aversion for "clicky" keyboards very
clear, so I chose
[clear switches](http://deskthority.net/wiki/Cherry_MX_Clear): it
means I got tactile feedback but they're not noisy.

### Owning the CODE

It is true one could buy a dozen perfectly usable keyboards for the
price of a single CODE, but it is also true you would not have such a
solid, robust and precise device at your fingertips. It's a matter of
taste: I love the feeling of typing on it, and it makes working more
pleasant and more rapid.

## Atreus Keyboard kit

![My Atreus keyboard, assembled](/images/atreus-small.jpg)

After one year with the CODE Keyboard I was happy but I still had the
ergonomic itch to scratch. Also, I wanted something I could hack and
customize. So I decided to buy one of
[Phil Hagelberg](http://technomancy.us/)'s
[Atreus](http://atreus.technomancy.us/) kits. The schematics and the
software are open, so if you're more expert you can put one together
using spare parts (diodes and wires plus switches and key-caps) and
cutting yourself the enclosure from plywood (or maybe 3d-printing it
for a more modern look).

### Assembling the keyboard

I had no previous experience with soldering. At all. Moreover, I'd
classify myself as manually inept, so I feared the assembling
part. Quite startlingly -- perhaps due to the extra attention I put in
the operations -- I had zero problems. Actually, I'm so happy with the
results that I'll indulge in giving some advice I think could be
useful to other beginners that try to build this kit or similar
projects.

* Phil suggests to use a third hand in some phases of the
  assembling. I think you should buy one already: the lens in
  particular proved to be extremely useful during the entire process.

* Another cheap and very useful tool you should consider buying is a
  multimeter. See below.
  
* The first time the instructions mention the possibility of
  performing tests is when you have soldered the first switches: this
  happen in a quite advanced phase of the project, when it would be
  annoying to correct the errors you may have made. I'm maybe stating
  the obvious, but you can do tests throughout almost the entire
  project: with a multimeter, to check diodes soldering, or with a
  jumper, touching the keys switches holes, when you finished
  soldering the diodes. The same jumper can be used to reset and test
  the controller even before it's in place on the board.

### Using it

I think the Atreus keyboard is not for everyone. If assembling the
keyboard has been easier than expected, I have to say the opposite
with regard to using it.

![Atreus QWERTY layers (L0, L1, L2)](/images/atreus-layout-small.png)

I figured I would have problems with the organization in layers, but I
didn't consider other factors such vertical staggering and I thought
that just typing text was going to be feasible (although slower) in a
few hours. I was wrong. I'm still making a lot of errors, I'm very
slow, and I have to look where my fingers are while I type. In other
words, I have not yet the sensation that I'm in control of my
system. But I'm seeing the progress: Atreus surely requires some
commitment.@w

Also, changes to the usual layout are very radical. Take cursor keys,
for example.

#### Cursor keys

In some environments I'm facing problems with the fact
that cursor keys are "far" from reach (they're on the third layer in
the default layout proposed: look at the picture above).

Let's talk about Emacs, and let's consider a very common case while
coding: opening a C-like block.

What I usually do is typing the opening and closing curly braces, then
moving into the block to fill it. Using a traditional keyboard, I'd do
like that:

<kbd>{</kbd>, <kbd>}</kbd>, <kbd>left arrow</kbd> 

On Atreus, using cursor keys, that becomes:

<kbd>{</kbd>, <kbd>}</kbd>, <kbd>fn</kbd> + <kbd>Esc</kbd> (to swith
to Layer 2), <kbd>left arrow</kbd>, <kbd>fn</kbd> (back to Layer 0)

or

<kbd>{</kbd>, <kbd>}</kbd>, <kbd>Ctrl</kbd> + <kbd>b</kbd>

the last option has one keypress more (I'm counting the
<kbd>Ctrl</kbd>), and moving cursor using <kbd>Ctrl</kbd> +
(<kbd>b</kbd> <kbd>n</kbd> <kbd>p</kbd> <kbd>f</kbd>) is admidtettly
more impervious.

### Price

As the Code 87, the Atreus kit is not cheap. Counting the cost, plus
shipping, plus in my case the custom fees and the extra stuff I had to
purchase to assemble it, it is not a itch I scratched for free.

I am usually an advocate of not going for cheap stuff when it's about
work tools, but in this case, given the fact I had no evidence this
particular tool was going to suit me, I can't say that.

That being said, considering the quality of the materials (I'm liking
the switches!) and having faith in the ergonomic choices Phil made, I
don't regret the money and the time spent for having it.

## Conclusions

