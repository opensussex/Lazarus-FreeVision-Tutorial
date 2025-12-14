# 02 - Statusline and Menu
## 05 - Status Line Multiple Entries

![image.png](image.png)

Changing the status line with multiple options.

---
Multiple hotkeys are also possible in the status line.
The declaration could be written nested in one line.
In the example, it is split.

```pascal
  procedure TMyApp.InitStatusLine;
  var
    R: TRect;                 // Rectangle for the status line position.

    P0: PStatusDef;           // Pointer to entire entry.
    P1, P2, P3: PStatusItem;  // Pointer to individual hotkeys.
  begin
    GetExtent(R);             // Returns the size/position of the App, normally 0, 0, 80, 24.
    R.A.Y := R.B.Y - 1;       // Position of the status line, set to the bottom line of the App.

    P3 := NewStatusKey('~F1~ Help', kbF1, cmHelp, nil);
    P2 := NewStatusKey('~F10~ Menu', kbF10, cmMenu, P3);
    P1 := NewStatusKey('~Alt+X~ Exit program', kbAltX, cmQuit, P2);
    P0 := NewStatusDef(0, $FFFF, P1, nil);

    StatusLine := New(PStatusLine, Init(R, P0));
  end;
```

The declaration and execution remain the same.

```pascal
var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Initialize
  MyApp.Run;    // Execute
  MyApp.Done;   // Release
end.
```


