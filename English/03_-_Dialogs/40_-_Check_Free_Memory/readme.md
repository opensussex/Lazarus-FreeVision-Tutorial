# 03 - Dialogs
## 40 - Check Free Memory

![image.png](image.png)

Check if enough memory is free to create the dialog.
On today's computers, this will probably no longer be the case that memory overflows because of a dialog.

---
The virtual procedure **OutOfMemory**, if memory does overflow.
If you don't override this method, no error message is displayed; the user just doesn't know why their view doesn't appear.

```pascal
type
  TMyApp = object(TApplication)
    ParameterData: TParameterData;                     // Parameters for dialog.
    constructor Init;                                  // New constructor

    procedure InitStatusLine; virtual;                 // Status line
    procedure InitMenuBar; virtual;                    // Menu
    procedure HandleEvent(var Event: TEvent); virtual; // Event handler
    procedure OutOfMemory; virtual;                    // Called when memory overflows.

    procedure MyParameter;                             // New function for a dialog.
  end;
```

The procedure is called when there is not enough memory.

```pascal
  procedure TMyApp.OutOfMemory;
  begin
    MessageBox('Not enough memory!', nil, mfError + mfOkButton);
  end;
```

The dialog is now loaded with values.
This is done as soon as you are finished creating components.
With **ValidView(...** you check if there is enough memory to create the component.
If not, **nil** is returned. It doesn't matter whether you override **OutOfMemory**.

```pascal
  procedure TMyApp.MyParameter;
  var
    Dlg: PDialog;
    R: TRect;
    dummy: word;
    View: PView;
  begin
    R.Assign(0, 0, 35, 15);
    R.Move(23, 3);
    Dlg := New(PDialog, Init(R, 'Parameter'));
    with Dlg^ do begin

      R.Assign(2, 3, 18, 7);
      View := New(PCheckBoxes, Init(R,
        NewSItem('~F~ile',
        NewSItem('~L~ine',
        NewSItem('D~a~te',
        NewSItem('~T~ime',
        nil))))));
      Insert(View);
      R.Assign(2, 2, 10, 3);
      Insert(New(PLabel, Init(R, 'Pr~i~nt', View)));

      R.Assign(21, 3, 33, 6);
      View := New(PRadioButtons, Init(R,
        NewSItem('~P~rinter 1',
        NewSItem('Printer ~2~',
        NewSItem('Printer ~3~',
        nil)))));
      Insert(View);
      R.Assign(21, 2, 30, 3);
      Insert(New(PLabel, Init(R, '~F~ont', View)));

      R.Assign(2, 9, 33, 10);
      View := New(PInputLine, Init(R, 50));
      Insert(View);
      R.Assign(2, 8, 10, 9);
      Insert(New(PLabel, Init(R, '~N~ote', View)));

      R.Assign(7, 12, 17, 14);
      Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));

      R.Assign(19, 12, 32, 14);
      Insert(new(PButton, Init(R, '~C~ancel', cmCancel, bfNormal)));

      SetData(ParameterData);
    end;

    Dlg := PDialog(Application^.ValidView(Dlg));
    if Dlg <> nil then begin
      dummy := Desktop^.ExecView(Dlg);
      if dummy <> cmCancel then begin
        Dlg^.GetData(ParameterData);
      end;
      Dispose(Dlg, Done);
    end;
  end;
```


