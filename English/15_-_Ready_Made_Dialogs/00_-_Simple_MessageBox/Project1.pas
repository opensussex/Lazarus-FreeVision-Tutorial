//image image.png
(*
Die einfachsten Dialoge sind die fertigen MessageBoxen.
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  MsgBox,   // MessageBox
  Menus;    // Status line

const
  cmAbout = 1001;     // Show about
  cmWarning = 1002;
  cmError = 1003;
  cmInfo = 1004;
  cmConformation = 1005;

type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Status line
    procedure InitMenuBar; virtual;                    // Menu
    procedure HandleEvent(var Event: TEvent); virtual; // Event handler
  end;

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;                 // Rectangle for the status line position.

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
    R: TRect;                          // Rectangle for the menu line position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(
        NewItem('~K~onformation...', 'F5', kbF2, cmConformation, hcNoContext,
        NewItem('~I~nfo...', 'F4', kbF2, cmInfo, hcNoContext,
        NewItem('~F~ehler...', 'F3', kbF2, cmError, hcNoContext,
        NewItem('~W~arnung...', 'F2', kbF2, cmWarning, hcNoContext,
        NewLine(
        NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil))))))),
      NewSubMenu('~H~elp', hcNoContext, NewMenu(
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil)))));

  end;

(*
Aufruf einer MessageBox.
*)
  //code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin
          MessageBox('Ich bin ein About !', nil, mfInformation + mfOkButton);
        end;
        cmWarning: begin
          MessageBox('Ich bin eine Warnung-Box', nil, mfWarning + mfOkButton);
        end;
        cmError: begin
          MessageBox('Ich bin eine Fehlermeldung', nil, mfError + mfOkButton);
        end;
        cmInfo: begin
          MessageBox('Ich bin eine Info-Box', nil, mfInformation + mfOkButton);
        end;
        cmConformation: begin
          MessageBox('Ich bin eine Info-Box', nil, mfConfirmation + mfOkButton);
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;
  //code-

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Initialize
  MyApp.Run;    // Execute
  MyApp.Done;   // Release
end.
