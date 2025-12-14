# 03 - Dialogs
## 45 - Save Dialog Values to Disk

![image.png](image.png)

So that the values of the dialog are preserved even after closing the application, we save the data to disk.
It is not checked whether writing is possible, etc.
If you want this, you would have to check with **IOResult**, etc.

---
Here **sysutils** is added; it is needed for **FileExists**.

```pascal
uses
  SysUtils, // For file operations
```

The file in which the data for the dialog is located.

```pascal
const
  DialogFile = 'parameter.cfg';
```

At the beginning, the data is loaded from disk if available, otherwise it is created.

```pascal
  constructor TMyApp.Init;
  begin
    inherited Init;
    // Check if file exists.
    if FileExists(DialogFile) then begin
      // Load data from disk.
      AssignFile(fParameterData, DialogFile);
      Reset(fParameterData);
      Read(fParameterData, ParameterData);
      CloseFile(fParameterData);
      // Otherwise take default values.
    end else begin
      with ParameterData do begin
        Druck := %0101;
        Schrift := 2;
        Hinweis := 'Hello world !';
      end;
    end;
  end;
```

The data is saved to disk when **OK** is pressed.

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

        // Save data to disk.
        AssignFile(fParameterData, DialogFile);
        Rewrite(fParameterData);
        Write(fParameterData, ParameterData);
        CloseFile(fParameterData);
      end;
      Dispose(Dlg, Done);
    end;
  end;
```


