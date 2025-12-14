# 02 - Statusline and Menu
## 10 - Menu

![image.png](image.png)

Adding a menu.

---
The same units as for the status line are needed for the menu.

```pascal
uses
  App,      // TApplication
  Objects,  // Window area (TRect)
  Drivers,  // Hotkey
  Views,    // Event (cmQuit)
  Menus;    // Status line
```

For a menu, you must inherit **InitMenuBar**.

```pascal
type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;   // Status line
    procedure InitMenuBar; virtual;      // Menu
  end;
```

Creating the menu; the example has only a single menu item, Exit.
In the menu, the characters highlighted with **~x~** are not only visual but also functional.
To exit, you can also press **[Alt+f]**, **[e]**.
There are also direct hotkeys for menu items; in this example, **[Alt+x]** is for exit.
This coincidentally overlaps with **[Alt+x]** from the status line, but this doesn't matter.
The structure of menu creation is similar to the status line.
The last menu item always has a **nil**.

```pascal
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;           // Rectangle for the menu line position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1; // Position of the menu, set to the top line of the App.

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(
      NewItem('~E~xit', 'Alt-X', kbAltX, cmQuit, hcNoContext,
      nil)), nil))));
  end;
```


