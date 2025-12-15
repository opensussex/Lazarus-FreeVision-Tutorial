//image image.png
(*
Mit <b>FormatStr</b> können Strings formatiert werden.
Dabei sind filgende Formatierungen möglich:
%c: Char
%s: String
%d: Ganzzahlen
%x: Hexadezimal
%#: Formatierungen
Bei Realzahlen muss man sich folgendermassen behelfen:
//code+
procedure Str(var X: TNumericType[:NumPlaces[:Decimals]];var S: String);
//code-
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Window area (TRect)
  Drivers,  // Hotkey
  Views,    // Event (cmQuit)
  Menus,    // Status line
  MsgBox,   // Message boxes
  Dialogs,  // Dialogs
  MyDialog;

const
  cmOption = 1001;

type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Status line
    procedure InitMenuBar; virtual;                    // Menu
    procedure HandleEvent(var Event: TEvent); virtual; // Event handler
    procedure OutOfMemory; virtual;                    // Called when memory overflows.
  end;

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;

    StatusLine := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Exit program', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F4~ String Format Demo...', kbF4, cmOption, nil))), nil)));
  end;

  procedure TMyApp.InitMenuBar;
  var
    R: TRect;

  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(
        NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)),
      NewSubMenu('~O~ption', hcNoContext, NewMenu(
        NewItem('~S~tring Format Demo...', 'F4', kbF4, cmOption, hcNoContext, nil)), nil)))));
  end;

  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    AboutDialog: PMyDialog;

  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of                   // About Dialog
        cmOption: begin
          AboutDialog := New(PMyDialog, Init);
          if ValidView(AboutDialog) <> nil then begin // Check if enough memory.
            Desktop^.ExecView(AboutDialog);           // Dialog About ausführen.
            Dispose(AboutDialog, Done);               // Release dialog and memory.
          end;
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;

  procedure TMyApp.OutOfMemory;
  begin
    MessageBox('Zu wenig Arbeitsspeicher !', nil, mfError + mfOkButton);
  end;

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Initialize
  MyApp.Run;    // Execute
  MyApp.Done;   // Release

//lineal
(*
*)
//includepascal mydialog.pas head

(*
Deklaration des Dialogs.
*)
//includepascal mydialog.pas type

(*
Bei Integern ist es wichtig, das man diese als <b>PtrInt</b> deklariert.
*)
//includepascal mydialog.pas init

(*
Hier sieht man, die Formatierung mit <b>FormatStr</b>.
*)
//includepascal mydialog.pas draw

end.
