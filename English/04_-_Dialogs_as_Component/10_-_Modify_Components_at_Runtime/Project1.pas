//image image.png
(*
This example shows, how to modify components at runtime.
A button is used for this, where the label increases with each click.
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
      case Event.Command of                        // About Dialog
        cmAbout: begin
          MyDialog := New(PMyDialog, Init);
          if ValidView(MyDialog) <> nil then begin // Check if enough memory.
            Desktop^.ExecView(MyDialog);           // Execute About dialog.
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
The dialog with the counter button.
*)
//includepascal mydialog.pas head

(*
If you want to modify a component at runtime, you must declare it, otherwise you can no longer access it.
Direkt mit <b>Insert(New(...</b> no longer works.
*)
//includepascal mydialog.pas type

(*
In the constructor, you can see, that you take the detour via.
<b>CounterButton</b> is needed for modification.
*)
//includepascal mydialog.pas init

(*
In the event handler, the number in the button is increased when pressed.
You can see why you need the, without it, you would have no access to <b>Titel</b>.
Important: when you change a component, you must redraw the component with, otherwise you won't see the changed value.
*)
//includepascal mydialog.pas handleevent

end.
