//image image.png
(*
You can catch an event handle in the dialog/window, when you move/click the mouse.
There is nothing special in the main program for this, this all runs locally in the dialog/window.
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
  cmKeyAktion = 1001;     // Show about

type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Status line
    procedure InitMenuBar; virtual;                    // Menu
    procedure HandleEvent(var Event: TEvent); virtual; // Event handler
    procedure OutOfMemory; virtual;                    // Called when memory overflows.
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
      NewStatusKey('~F1~ Tastenaktionen...', kbF1, cmKeyAktion, nil))), nil)));
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
        NewItem('~T~astenaktionen...', '', kbNoKey, cmKeyAktion, hcNoContext, nil)), nil)))));
  end;

(*
In the main program, only the dialog is built, called and closed.
*)
//code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    KeyDialog: PMyKey;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmKeyAktion: begin
          KeyDialog := New(PMyKey, Init);
          if ValidView(KeyDialog) <> nil then begin // Check if enough memory.
            Desktop^.ExecView(KeyDialog);           // Execute mouse action dialog.
            Dispose(KeyDialog, Done);               // Release dialog and memory.
          end;
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;
//code-

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
<b>Unit mit dem Keyboardaktions-Dialog.</b>
<br>
*)
//includepascal mydialog.pas head

(*
In the object the.*are declared globally, because these are modified later during mouse actions.
*)
//includepascal mydialog.pas type

(*
A dialog with EditLine, Label and Button is built.
The only special thing there, the.*status is set to own inputs are undesirable there.
*)
//includepascal mydialog.pas init

(*
Im EventHandle sieht man, das die Keyboard abgefangen wird. Es wird der Zeichencode und der Scancode ausgegeben.
In der untersten Zeile erscheint ein 3, wen die Shift-Taste mit gewissen anderen Tasten zB. Pfeil-Tasten gedrückt wird.
The keyboard data is output to the.
*)
//includepascal mydialog.pas handleevent

end.
