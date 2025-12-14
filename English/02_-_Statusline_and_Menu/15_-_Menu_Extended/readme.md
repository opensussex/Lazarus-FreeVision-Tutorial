# 02 - Statusline and Menu
## 15 - Menu Extended

![image.png](image.png)

Adding multiple menu items.
For clarity, this is also split.

---
For custom commands, you must define command codes.
It is recommended to use values > 1000 to avoid overlaps with standard codes.

```pascal
const
  cmList = 1002;      // File list
  cmAbout = 1001;     // Show about
```

For a menu, you must inherit **InitMenuBar**.

```pascal
type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;   // Status line
    procedure InitMenuBar; virtual;      // Menu
  end;
```

You can also split menu entries via pointers.
Whether you nest or split is a matter of taste.
With **NewLine** you can insert a blank line.
It is recommended that if a dialog opens for a menu item, you write **...** after the label.

```pascal
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;                          // Rectangle for the menu line position.

    M: PMenu;                          // Entire menu
    SM0, SM1,                          // Submenu
    M0_0, M0_1, M0_2, M1_0: PMenuItem; // Simple menu items

  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    M1_0 := NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil);
    SM1 := NewSubMenu('~H~elp', hcNoContext, NewMenu(M1_0), nil);

    M0_2 := NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil);
    M0_1 := NewLine(M0_2);
    M0_0 := NewItem('~L~ist', 'F2', kbF2, cmList, hcNoContext, M0_1);
    SM0 := NewSubMenu('~F~ile', hcNoContext, NewMenu(M0_0), SM1);

    M := NewMenu(SM0);

    MenuBar := New(PMenuBar, Init(R, M));
  end;
```


