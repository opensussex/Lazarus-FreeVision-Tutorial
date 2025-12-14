# 03 - Dialogs
## 30 - InputLine (Edit Line)

![image.png](image.png)

Insert an edit line.

---
Add an input line to the dialog.
The maximum length is specified in the third parameter.
With a label, you can describe what should be entered.

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
      // Label for CheckGroup.
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
      // Label for RadioGroup.
      R.Assign(21, 2, 30, 3);
      Insert(New(PLabel, Init(R, '~F~ont', View)));

      // InputLine
      R.Assign(2, 9, 33, 10);
      View := New(PInputLine, Init(R, 50));
      Insert(View);
      // Label for InputLine.
      R.Assign(2, 8, 10, 9);
      Insert(New(PLabel, Init(R, '~N~ote', View)));

      // OK button
      R.Assign(7, 12, 17, 14);
      Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));

      // Cancel button
      R.Assign(19, 12, 32, 14);
      Insert(new(PButton, Init(R, '~C~ancel', cmCancel, bfNormal)));
    end;
    dummy := Desktop^.ExecView(Dlg);
    Dispose(Dlg, Done);
  end;
```


