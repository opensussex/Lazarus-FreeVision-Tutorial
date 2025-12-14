# 03 - Dialogs
## 20 - RadioButton

![image.png](image.png)

Add radio buttons to the dialog.

---
The menu has been slightly modified/extended.

```pascal
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;                          // Rectangle for the menu line position.

    M: PMenu;                          // Entire menu
    SM0, SM1, SM2,                     // Submenu
    M0_0, M0_2, M0_3, M0_4, M0_5,
    M1_0, M2_0: PMenuItem;             // Simple menu items

  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    M2_0 := NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil);
    SM2 := NewSubMenu('~H~elp', hcNoContext, NewMenu(M2_0), nil);

    M1_0 := NewItem('~P~arameters...', '', kbF2, cmPara, hcNoContext, nil);
    SM1 := NewSubMenu('~O~ptions', hcNoContext, NewMenu(M1_0), SM2);

    M0_5 := NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil);
    M0_4 := NewLine(M0_5);
    M0_3 := NewItem('~C~lose', 'Alt-F3', kbAltF3, cmClose, hcNoContext, M0_4);
    M0_2 := NewLine(M0_3);
    M0_0 := NewItem('~L~ist', 'F2', kbF2, cmList, hcNoContext, M0_2);
    SM0 := NewSubMenu('~F~ile', hcNoContext, NewMenu(M0_0), SM1);

    M := NewMenu(SM0);

    MenuBar := New(PMenuBar, Init(R, M));
  end;
```

Add radio buttons to the dialog; this works almost the same as with checkboxes.

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

      // RadioButtons
      R.Assign(20, 3, 33, 7);
      View := New(PRadioButtons, Init(R,
        NewSItem('~P~rinter 1',
        NewSItem('Printer ~2~',
        NewSItem('Printer ~3~',
        NewSItem('Printer ~4~',
        nil))))));
      Insert(View);

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


