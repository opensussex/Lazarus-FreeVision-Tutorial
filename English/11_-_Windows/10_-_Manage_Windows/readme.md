# 11 - Windows
## 10 - Windows verwalten

![image.png](image.png)

Windows verwalten. Nun ist es möglich über das Menu Steuerkomandos für die Windowsverwaltung zu geben.
ZB. Zoom, verkleinern, Windowswechsel, Kaskade, etc.

---
Das Menu wurde um die Steuerbefehle für die Windowsverwatung ergänzt.
Die ausgeklammerten Kommandos müssen manuel gemacht werden.

```pascal
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(
        NewItem('~N~eu', 'F4', kbF4, cmNewWin, hcNoContext,
        NewLine(
        NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)))),
      NewSubMenu('~F~enster', hcNoContext, NewMenu(
        NewItem('~N~ebeneinander', '', kbNoKey, cmTile, hcNoContext,
        NewItem(#154'ber~l~append', '', kbNoKey, cmCascade, hcNoContext,
        NewItem('~A~lle schliessen', '', kbNoKey, cmCloseAll, hcNoContext,
        NewItem('Anzeige ~e~rneuern', '', kbNoKey, cmRefresh, hcNoContext,
        NewLine(
        NewItem('Gr'#148'sse/~P~osition', 'Ctrl+F5', kbCtrlF5, cmResize, hcNoContext,
        NewItem('Ver~g~'#148'ssern', 'F5', kbF5, cmZoom, hcNoContext,
        NewItem('~N~'#132'chstes', 'F6', kbF6, cmNext, hcNoContext,
        NewItem('~V~orheriges', 'Shift+F6', kbShiftF6, cmPrev, hcNoContext,
        NewLine(
        NewItem('~S~chliessen', 'Alt+F3', kbAltF3, cmClose, hcNoContext, Nil)))))))))))), nil)))));

  end;
```

Beim Windows erzeugen, ist noch ein Counter hinzugekommen.
Wen man bei den Windows eine überlappend oder nebeneinader Darstellung will, muss man noch den Status **ofTileable** setzen.

```pascal
  procedure TMyApp.NewWindows;
  var
    Win: PWindow;
    R: TRect;
  const
    WinCounter: integer = 0;                    // Zählt Windows
  begin
    R.Assign(0, 0, 60, 20);
    Inc(WinCounter);
    Win := New(PWindow, Init(R, 'Windows', WinCounter));
    Win^.Options := Win^.Options or ofTileable; // Für Tile und Cascade

    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end else begin
      Dec(WinCounter);
    end;
  end;
```

Diese Procedure schliesst alle Windows im Desktop.
Dazu wird jedem Windows mit **ForEach** ein **cmClose**-Event gesendet.

```pascal
  procedure TMyApp.CloseAll;

    procedure SendClose(P: PView);
    begin
      Message(P, evCommand, cmClose, nil);
    end;

  begin
    Desktop^.ForEach(@SendClose);
  end;
```

**cmNewWin** muss man selbst abarbeiten. **cmClose** für das Schliessen des Windows läuft im Hintergrund automatisch.

```pascal

  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmNewWin: begin
          NewWindows;    // Windows erzeugen.
        end;
        cmCloseAll:begin
          CloseAll;      // Schliesst alle Windows.
        end;
        cmRefresh: begin
          ReDraw;        // Anwendung neu zeichnen.
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;
```


