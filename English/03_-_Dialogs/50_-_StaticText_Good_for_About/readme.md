# 03 - Dialogs
## 50 - StaticText Good for About

![image.png](image.png)

Here an About dialog is created; you can see well what labels can be used for.

---
The file in which the data for the dialog is located.

```pascal
const
  DialogFile = 'parameter.cfg';
```

A new function **About** has been added.

```pascal
type
  TMyApp = object(TApplication)
    ParameterData: TParameterData;                     // Parameters for dialog.
    fParameterData: file of TParameterData;            // File handler for saving/loading dialog data.

    constructor Init;                                  // New constructor

    procedure InitStatusLine; virtual;                 // Status line
    procedure InitMenuBar; virtual;                    // Menu
    procedure HandleEvent(var Event: TEvent); virtual; // Event handler
    procedure OutOfMemory; virtual;                    // Called when memory overflows.

    procedure MyParameter;                             // New function for a dialog.
    procedure About;                                   // About dialog.
  end;
```

Here About is called when About is selected in the menu.

```pascal
  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin
          About;   // Call About dialog
        end;
        cmList: begin
        end;
        cmPara: begin
          MyParameter;
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;
```

Create About dialog.
With **TRect.Grow(...** you can shrink and enlarge the rect.
With **#13** you can insert a line break.
With **#3** the text is centered horizontally in the rect.
With **#2** the text is right-aligned.

You could also output text with **PLabel**, but **PStaticText** is better suited for fixed text.

```pascal
  procedure TMyApp.About;
  var
    Dlg: PDialog;
    R: TRect;
  begin
    R.Assign(0, 0, 42, 11);
    R.Move(1, 1);
    Dlg := New(PDialog, Init(R, 'About'));
    with Dlg^ do begin
      Options := Options or ofCentered; // Center dialog

      // Insert StaticText.
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
    if ValidView(Dlg) <> nil then begin
      Desktop^.ExecView(Dlg);           // Call modally, function result is not evaluated.
      Dispose(Dlg, Done);               // Release dialog.
    end;
  end;
```


