//image image.png
(*
Bei der MessageBox, kann man die Grösse auch manuell festlegen.
Dazu muss man <b>MeassgeBoxRect(...)</b> verwenden.
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
  Dialogs;  // Dialogs

const
  cmAbout = 1001;     // Show about
  cmMyBotton = 1002;

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
        NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)),
      NewSubMenu('~H~elp', hcNoContext, NewMenu(
        NewItem('~M~anuelle Box...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil)))));

  end;

(*
Hier wird mir <b>R.Assign</b> die grösse der Box selbst festgelegt.
*)
  //code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    R: TRect;
    Dlg: PDialog;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin
          R.Assign(12, 3, 58, 20);  // Grösse der Box
          Dlg := New(PDialog, Init(R, 'Parameter'));
          with Dlg^ do begin

            // CheckBoxen
            R.Assign(4, 3, 18, 7);
            Insert(New(PCheckBoxes, Init(R, NewSItem('~F~ile', NewSItem('~Z~eile',
              NewSItem('D~a~tum', NewSItem('~Z~eit', nil)))))));

            // BackGround
            GetExtent(R);
            R.Grow(-1, -1);
//            Insert(New(PBackGround, Init(R, #3)));  // Hintergrund einfügen.

            // My-Button
            R.Assign(7, 12, 17, 14);
            Insert(new(PButton, Init(R, '~M~yButton', cmMyBotton, bfDefault)));

          end;


          R.Assign(22, 3, 42, 10);  // Grösse der Box
          MessageBoxRectDlg(Dlg, R, 'Ich bin eine vorgegebene Box', nil, mfInformation + mfYesButton + mfNoButton);
          Dispose(Dlg, Done);
        end;
        cmMyBotton: begin
          MessageBox('Eigener Button gedrückt', nil, mfInformation);

        end


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
