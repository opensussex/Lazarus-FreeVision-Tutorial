# 04 - Dialogs as Component
## 00 - A Simple About

![image.png](image.png)

If you need the same dialog repeatedly, it's best to package it as a component in a unit.
To do this, you write a descendant of **TDialog**.
As an example, an About dialog is built here.

---
Here the About dialog is loaded and then released again on close.

```pascal
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    AboutDialog: PMyAbout;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin
          AboutDialog := New(PMyAbout, Init);         // Create new dialog.
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

The About dialog is created as a descendant of TDialog.

```pascal
unit MyAbout;

interface

uses
  Objects, Drivers, Views, Dialogs;

type
  PMyAbout = ^TMyAbout;
  TMyAbout = object(TDialog)
    constructor Init;
  end;

implementation

constructor TMyAbout.Init;
var
  R: TRect;
begin
  R.Assign(0, 0, 42, 11);
  inherited Init(R, 'About');
  Options := Options or ofCentered;

  R.Assign(2, 2, 40, 8);
  Insert(New(PStaticText, Init(R,
    #13 +
    'Free Vision Tutorial 1.0' + #13 +
    '2017' + #13 +
    #3 + 'Centered' + #13 +
    #2 + 'Right')));

  R.Assign(16, 8, 26, 10);
  Insert(New(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;

end.
```


