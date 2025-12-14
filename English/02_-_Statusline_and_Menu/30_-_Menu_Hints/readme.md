# 02 - Statusline and Menu
## 30 - Menu Hints

![image.png](image.png)

Hints in the status line for menu items.

---
Constants for individual help items.
It's best to use hcxxx names.

```pascal
const
  cmList   = 1002;  // File list
  cmAbout  = 1001;  // Show about

  hcFile   = 10;
  hcClose  = 11;
  hcOption = 12;
  hcFormat = 13;
  hcEdit   = 14;
  hcHelp   = 15;
  hcAbout  = 16;
```

The hint line must be inherited.

```pascal
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;                   // Rectangle for the menu line position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcFile, NewMenu(
        NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcClose, nil)),

      NewSubMenu('~O~ptions', hcOption, NewMenu(
        NewItem('~F~ormat', '', kbNoKey, cmAbout, hcFormat,
        NewItem('~E~ditor', '', kbNoKey, cmAbout, hcEdit, nil))),

      NewSubMenu('~H~elp', hcHelp, NewMenu(
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcAbout, nil)), nil))));
  end;
```


