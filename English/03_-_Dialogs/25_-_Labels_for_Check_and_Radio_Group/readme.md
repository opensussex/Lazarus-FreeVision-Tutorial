# 03 - Dialogs
## 25 - Labels for Check and Radio Group

![image.png](image.png)

Label radio and check groups.

---
Add labels to check and radio group buttons.
This works almost the same as a normal label. The only difference is that instead of **nil** you pass the pointer to the group.

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


