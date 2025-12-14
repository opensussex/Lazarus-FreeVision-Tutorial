# 11 - Windows
## 00 - Erstes Windows

![image.png](image.png)

Erstes Memo-Windows.

---
Der Constructor wird vererbt, so das von Anfang an ein neues Windows erstellt wird.

```pascal
type
  TMyApp = object(TApplication)
    constructor Init;

    procedure InitStatusLine; virtual;
    procedure InitMenuBar; virtual;

    procedure NewWindows;
  end;
```


```pascal
  constructor TMyApp.Init;
  begin
    inherited Init;   // Der Vorfahre aufrufen.
    NewWindows;       // Windows erzeugen.
  end;
```

Neues Windows erzeugen. Windows werden in der Regel nicht modal geöffnet, da man meistens mehrere davon öffnen will.

```pascal
  procedure TMyApp.NewWindows;
  var
    Win: PWindow;
    R: TRect;
  begin
    R.Assign(0, 0, 60, 20);
    Win := New(PWindow, Init(R, 'Windows', wnNoNumber));
    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end;
  end;
```


