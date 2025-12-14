//image image.png
(*
You can assign different color schemes to a window/dialog.
By default, the following is used:
//code+
Editor window : Blau
Dialog         : Grau
Help window  : Cyan
//code-

Without doing anything, windows/dialogs always come in the right color.
Modification only makes sense in special cases.
*)
program Project1;

uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  Menus,    // Status line
  MsgBox,   // Messageboxen
  Dialogs,  // Dialoge
  MyDialog;

const
  cmAbout = 1001;     // Show about

type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Status line
    procedure InitMenuBar; virtual;                    // Menu
    procedure HandleEvent(var Event: TEvent); virtual; // Event handler
    procedure OutOfMemory; virtual;                    // Wird aufgerufen, wen Speicher überläuft.
  end;

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;              // Rectangle for the status line position.
  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;

    StatusLine := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Exit program', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F1~ About...', kbF1, cmAbout, nil))), nil)));
  end;

  procedure TMyApp.InitMenuBar;
  var
    R: TRect;                       // Rectangle for the menu line position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(
        NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)),
      NewSubMenu('~O~ption', hcNoContext, NewMenu(
        NewItem('Dia~l~og...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil)))));
  end;

  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    MyDialog: PMyDialog;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of                   // About Dialog
        cmAbout: begin
          MyDialog := New(PMyDialog, Init);
          if ValidView(MyDialog) <> nil then begin // Check if enough memory.
            Desktop^.ExecView(MyDialog);           // Dialog ausführen.
            Dispose(MyDialog, Done);               // Release dialog and memory.
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
<b>Unit with the new dialog.</b>
<br>
With the 3 upper buttons, you can change the color scheme of the dialog.
*)
//includepascal mydialog.pas head

(*
Here 3 event constants have been added.
*)
//includepascal mydialog.pas type

(*
Building the dialog is nothing special.
*)
//includepascal mydialog.pas init

(*
Here the color schemes are changed using.
Here too it is important to call, this time not for a component, but for the entire dialog.
*)
//includepascal mydialog.pas handleevent

end.
