# 02 - Statusline and Menu
## 20 - Menu Nested

![image.png](image.png)

Menu items can also be nested within each other.

---
For the status line, I nested the entries, so no pointers are needed.
I also find this clearer than a jungle of variables.

```pascal
  procedure TMyApp.InitStatusLine;
  var
    R: TRect;              // Rectangle for the status line position.
  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;

    StatusLine := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Exit program', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F1~ Help', kbF1, cmHelp, nil))), nil)));
  end;
```

The following example demonstrates a nested menu.
The creation is also nested.

```File
  Exit
Demo
  Simple 1
  Nested
    Menu 0
    Menu 1
    Menu 2
  Simple 2
Help
  About
```


```pascal
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;                   // Rectangle for the menu line position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(
        NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)),

      NewSubMenu('Dem~o~', hcNoContext, NewMenu(
        NewItem('Simple ~1~', '', kbNoKey, cmAbout, hcNoContext,
        NewSubMenu('~N~ested', hcNoContext, NewMenu(
          NewItem('Menu ~0~', '', kbNoKey, cmAbout, hcNoContext,
          NewItem('Menu ~1~', '', kbNoKey, cmAbout, hcNoContext,
          NewItem('Menu ~2~', '', kbNoKey, cmAbout, hcNoContext, nil)))),
        NewItem('Simple ~2~', '', kbNoKey, cmAbout, hcNoContext, nil)))),

      NewSubMenu('~H~elp', hcNoContext, NewMenu(
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil)))));
  end;
```


