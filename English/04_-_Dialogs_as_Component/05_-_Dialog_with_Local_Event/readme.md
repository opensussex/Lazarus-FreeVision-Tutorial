# 04 - Dialogs as Component
## 05 - Dialog with Local Event

![image.png](image.png)

In inherited dialogs, it is possible to build in buttons that perform an action locally in the dialog.
In the example, a MessageBox is called.

---
Nothing changes in the main program; it doesn't matter whether something is done locally.

```pascal
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    AboutDialog: PMyAbout;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of                   // About Dialog
        cmAbout: begin
          AboutDialog := New(PMyAbout, Init);
          if ValidView(AboutDialog) <> nil then begin // Check if enough memory.
            Desktop^.ExecView(AboutDialog);           // Execute About dialog.
            Dispose(AboutDialog, Done);               // Release dialog and memory.
          end;
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;
```


---
**Unit with the new dialog.**

The command for the local button.

```pascal
const
  cmInfo = 1001;
```

The event handler must be overridden.

```pascal
type
  PMyAbout = ^TMyAbout;
  TMyAbout = object(TDialog)
    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
```

In the constructor, the Info button is added.

```pascal
constructor TMyAbout.Init;
var
  R: TRect;
begin
  R.Assign(0, 0, 42, 11);
  inherited Init(R, 'About');
  Options := Options or ofCentered;

  R.Assign(2, 2, 40, 7);
  Insert(New(PStaticText, Init(R,
    #13 +
    'Free Vision Tutorial 1.0' + #13 +
    '2017' + #13 +
    #3 + 'Centered' + #13 +
    #2 + 'Right')));

  R.Assign(10, 8, 20, 10);
  Insert(New(PButton, Init(R, '~I~nfo', cmInfo, bfNormal)));

  R.Assign(22, 8, 32, 10);
  Insert(New(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;
```

The event handler for the local button.

```pascal
procedure TMyAbout.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);

  if Event.What = evCommand then begin
    case Event.Command of
      cmInfo: begin
        MessageBox('This is a local event', nil, mfInformation + mfOKButton);
      end;
      else begin
        Exit;
      end;
    end;
  end;
  ClearEvent(Event);
end;
```


