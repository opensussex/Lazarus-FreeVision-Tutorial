# 03 - Dialogs
## 35 - Remember Dialog Values

![image.png](image.png)

Until now, the values in the dialog were always lost when you closed and reopened it.
For this reason, the values are now stored in a record.

---
The values of the dialog are stored in this record.
The order of the data in the record **must** be exactly the same as when creating the components, otherwise there will be a crash.
In Turbo-Pascal, a **Word** had to be used instead of **LongWord**, this is important when porting old applications.

```pascal
type
  TParameterData = record
    Druck,
    Schrift: longword;
    Hinweis: string[50];
  end;
```

Here the constructor is also inherited; this descendant is needed to load the dialog data with default values.

```pascal
type
  TMyApp = object(TApplication)
    ParameterData: TParameterData;                     // Data for parameter dialog
    constructor Init;                                  // New constructor

    procedure InitStatusLine; virtual;                 // Status line
    procedure InitMenuBar; virtual;                    // Menu
    procedure HandleEvent(var Event: TEvent); virtual; // Event handler

    procedure MyParameter;                             // New function for a dialog.
  end;
```

The constructor that loads the values for the dialog.
The data structure for radio buttons is simple. 0 is the first button, 1 the second, 2 the third, etc.

```pascal
  constructor TMyApp.Init;
  begin
    inherited Init;
    with ParameterData do begin
      Druck := $0F;
      Schrift := 1;
      Hinweis := 'Hello World';
    end;
  end;
```

With **SetData** the data is loaded into the dialog.
With **GetData** the data is read from the dialog.

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

      // CheckBoxes
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

      // RadioButton
      R.Assign(21, 3, 33, 6);
      View := New(PRadioButtons, Init(R,
        NewSItem('~P~rinter 1',
        NewSItem('Printer ~2~',
        NewSItem('Printer ~3~',
        nil)))));
      Insert(View);
      R.Assign(21, 2, 30, 3);
      Insert(New(PLabel, Init(R, '~F~ont', View)));

      // InputLine
      R.Assign(2, 9, 33, 10);
      View := New(PInputLine, Init(R, 50));
      Insert(View);
      R.Assign(2, 8, 10, 9);
      Insert(New(PLabel, Init(R, '~N~ote', View)));

      // OK button
      R.Assign(7, 12, 17, 14);
      Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));

      // Cancel button
      R.Assign(19, 12, 32, 14);
      Insert(new(PButton, Init(R, '~C~ancel', cmCancel, bfNormal)));

      SetData(ParameterData);
    end;
    dummy := Desktop^.ExecView(Dlg);
    if dummy <> cmCancel then begin
      Dlg^.GetData(ParameterData);
    end;
    Dispose(Dlg, Done);
  end;
```


