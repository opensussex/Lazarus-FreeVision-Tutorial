# 01 - Introduction
## 00 - Preface

**Free Vision** is the free variant of Turbo-Vision, which was included with Turbo-Pascal.
Many people think that FV is something outdated from the DOS era.
For normal desktop applications, this is true.
But there are applications where this is still very practical today.
A very good example is with **Telnet** access.
Or on a server that has no graphical interface.

Which Linux enthusiast hasn't had to struggle with **vi** or **nano**?
If Linux had an FV editor on board, life would be much easier. ;-)

For this reason, I am currently working with **Free Vision**.
I learned a lot from the FV sources, and I also found something on an old floppy disk from a Turbo-Pascal book.
You can also find one thing or another on the Internet.
Since I want to share my experience, I am creating this tutorial.

I hope the whole thing is understandable, although it certainly has many spelling errors. :-D

If anyone sees suggestions and errors, they can share their criticism in the German Lazarus forum. ;-)
<a href="">http://www.lazarusforum.de/viewtopic.php?f=22&t=11063&p=98205&hilit=freevision#p98205</a>

The sources for the tutorial can all be downloaded from the main page.
It is a zip file.

---
**Notes on the code:**

Free Vision uses Codepage 437.
For this reason, to ensure error-free display of umlauts, they should be used as char constants.

```pascal
ä = #132  Ä = #142
ö = #148  Ö = #153
ü = #129  Ü = #154
```


**General note:**
If you want to change texts at runtime, e.g. **Label**, **StaticText**, caution is advised.
Since the texts are stored as **PString**, care must be taken to reserve enough memory for the texts in the constructor (Init).
The easiest way to do this is as follows, so that there is enough space for **world**.

```pascal
  StaticText := new(PStaticText, Init(Rect, 'Hallo           '));
  StaticText^.Text^ := 'Hello world';
```


**TListBox**
Caution is advised with the **TListBox** component; the **TList** that you assign here must be cleaned up yourself in a **Destructor**.
Examples are available in the chapter **Lists and ListBoxes**.

**General note for 64Bit:**
With 64Bit code, there may be errors, <s>this mainly affects functions that use **FormatStr**.</s>
Unfortunately, this can be seen clearly with the line and column display of the windows.

**Turbo-Vision**
In this tutorial there are things that are **not** 100% compatible with **Turbo-Vision**.
Certain components and functions were only introduced with **Free-Vision** from **FPC**.
This includes, for example, **TabSheet**.
There are also functions that only exist in Turbo-Vision.

