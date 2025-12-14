# 03 - Dialogs
## 10 - Button

![image.png](image.png)

Add buttons to the dialog.

---
Add buttons to the dialog.
With **Insert** you add components, in this case the buttons.
With bfDefault you set the default button, which is activated with **[Enter]**.
bfNormal is a regular button.
The dialog is now opened modally, so **no** other dialogs can be opened.
dummy has the value of the button that was pressed, this corresponds to the **cmxxx** value.
The height of buttons must always be **2**, otherwise there will be incorrect display.

```pascal
  procedure TMyApp.MyParameter;
  var
    Dlg: PDialog;
    R: TRect;
    dummy: word;
  begin
    R.Assign(0, 0, 35, 15);                    // Size of the dialog.
    R.Move(23, 3);                             // Position of the dialog.
    Dlg := New(PDialog, Init(R, 'Parameter')); // Create dialog.
    with Dlg^ do begin

      // OK button
      R.Assign(7, 12, 17, 14);
      Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));

      // Cancel button
      R.Move(12, 0);
      Insert(new(PButton, Init(R, '~C~ancel', cmCancel, bfNormal)));
    end;
    dummy := Desktop^.ExecView(Dlg);   // Open dialog modally.
    Dispose(Dlg, Done);                // Release dialog and memory.
  end;
```


