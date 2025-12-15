# 15 - Ready Made Dialogs
## 20 - Datei Dialogs

![image.png](image.png)

Ein Dialog zum öffnen und speichern von Dateien.
Der **PFileDialog**.

---
Verschiedene Datei-Dialogs

```pascal
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    FileDialog: PFileDialog;
    FileName: shortstring;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmFileOpen: begin
          FileName := '*.*';
          New(FileDialog, Init(FileName, 'Datei '#148'ffnen', '~F~ilename', fdOpenButton, 1));
          if ExecuteDialog(FileDialog, @FileName) <> cmCancel then begin
            MessageBox('Es wurde "' + FileName + '" eingegeben', nil, mfOKButton);
          end;
        end;
        cmFileSave: begin
          FileName := '*.*';
          New(FileDialog, Init(FileName, 'Datei '#148'ffnen', '~F~ilename', fdOkButton, 1));
          if ExecuteDialog(FileDialog, @FileName) <> cmCancel then begin
            MessageBox('Es wurde "' + FileName + '" eingegeben', nil, mfOKButton);
          end;
        end;
        cmFileHelp: begin
          FileName := '*.*';
          New(FileDialog, Init(FileName, 'Datei '#148'ffnen', '~F~ilename', fdOkButton + fdOpenButton + fdReplaceButton + fdClearButton + fdHelpButton, 1));
          if ExecuteDialog(FileDialog, @FileName) <> cmCancel then begin
            MessageBox('Es wurde "' + FileName + '" eingegeben', nil, mfOKButton);
          end;
        end;
        else begin
          Exit;
        end;
```


