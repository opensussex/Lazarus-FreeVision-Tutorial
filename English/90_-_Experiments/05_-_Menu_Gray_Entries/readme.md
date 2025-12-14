# 90 - Experiments
## 05 - Menu Gray Entries

![image.png](image.png)

Menupunkt kann man auch ineinander verschachteln.

---
Bei der Status line habe ich die Einträge verschachtelt, somit braucht man keine Zeiger.
Ich finde dies auch übersichtlicher, als ein Variablen-Urwald.

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

Folgendes Beispiel demonstriert ein verschachteltes Menu.
Die Erzeugung ist auch verschachtelt.

```Datei
  Beenden
Demo
  Einfach 1
  Verschachtelt
    Menu 0
    Menu 1
    Menu 2
  Einfach 2
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
        NewItem('Einfach ~1~', '', kbNoKey, cmAbout, hcNoContext,
        NewSubMenu('~V~erschachtelt', hcNoContext, NewMenu(
          NewItem('Menu ~0~', '', kbNoKey, cmAbout, hcNoContext,
          NewItem('Menu ~1~', '', kbNoKey, cmAbout, hcNoContext,
          NewItem('Menu ~2~', '', kbNoKey, cmAbout, hcNoContext, nil)))),
        NewItem('Einfach ~2~', '', kbNoKey, cmAbout, hcNoContext, nil)))),

      NewSubMenu('~H~elp', hcNoContext, NewMenu(
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil))))));

    MenuBar^.Menu^.Items^.Next^.SubMenu^.Items^.Next^.Disabled:=True;
  end;
```


