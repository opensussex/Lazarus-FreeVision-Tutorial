//image image.png
(*
Ein Dialog zum öffnen und speichern von Dateien.
Der <b>PFileDialog</b>.
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Window area (TRect)
  Drivers,  // Hotkey
  Views,    // Event (cmQuit)
  MsgBox,   // MessageBox
  Menus,    // Status line
  StdDlg;   // Standard-Dialogs

const
  cmFileOpen = 1001;
  cmFileSave = 1002;
  cmFileHelp = 1003;
  cmAbout = 1010;

type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Status line
    procedure InitMenuBar; virtual;                    // Menu
    procedure HandleEvent(var Event: TEvent); virtual; // Event handler
  end;

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;     // Rectangle for the status line position.

  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;

    StatusLine := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Exit program', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F1~ Help', kbF1, cmHelp, nil))), nil)));

  end;

  procedure TMyApp.InitMenuBar;
  var
    R: TRect;     // Rectangle for the menu line position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(
        NewItem('~O~effnen...', 'F3', kbF3, cmFileOpen, hcNoContext,
        NewItem('Speichern ~u~nter...', '', kbNoKey,cmFileSave, hcNoContext,
        NewItem('Mit zusatz ~B~uttons...', '', kbNoKey,cmFileHelp, hcNoContext,
        NewLine(
        NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)))))),
      NewSubMenu('~H~elp', hcNoContext, NewMenu(
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil)))));

  end;

(*
Verschiedene Datei-Dialogs
*)
  //code+
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
          //code-
      end;
    end;
    ClearEvent(Event);
  end;


var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Initialize
  MyApp.Run;    // Execute
  MyApp.Done;   // Release
end.
