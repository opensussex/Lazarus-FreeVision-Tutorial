//image image.png
(*
If you want to evaluate the double click on a ListBox, you must inherit the ListBox and insert a new HandleEvent.
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
  StdDlg,   // For file open
  MyDialog;

const
  cmDialog   = 1001;     // Show dialog

type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Status line
    procedure InitMenuBar; virtual;                    // Menu
    procedure HandleEvent(var Event: TEvent); virtual; // Event handler
    procedure OutOfMemory; virtual;                    // Called when memory overflows.
    procedure NewWindows(Titel: ShortString);
  end;

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;    // Rectangle for the status line position.
  begin

    // StatusBar
    GetExtent(R);
    R.A.Y := R.B.Y - 1;

    New(StatusLine,
      Init(R,
        NewStatusDef(0, $FFFF,
        NewStatusKey('~Alt+X~ Exit', kbAltX,  cmQuit,
        NewStatusKey('~F10~ Menu',   kbF10,   cmMenu,
        NewStatusKey('~F1~ Help',    kbF1,    cmHelp,
        StdStatusKeys(nil)))),nil)
      )
    );
  end;

  procedure TMyApp.InitMenuBar;
  var
    R: TRect;    // Rectangle for the menu line position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(
        NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)),
      NewSubMenu('~O~ption', hcNoContext, NewMenu(
        NewItem('Dia~l~og...', '', kbNoKey, cmDialog, hcNoContext, nil)), nil)))));
  end;

  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    MyDialog: PMyDialog;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmDialog: begin
          MyDialog := New(PMyDialog, Init);
          if ValidView(MyDialog) <> nil then begin
            Desktop^.ExecView(MyDialog);   // Dialog ausführen.
            Dispose(MyDialog, Done);       // Release dialog and memory.
          end;
        end
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


  procedure TMyApp.NewWindows(Titel: ShortString);
  var
    Win: PWindow;
    R: TRect;
  begin
    R.Assign(0, 0, 60, 20);
    Win := New(PWindow, Init(R, Titel, wnNoNumber));
    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end;
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
The dialog with the ListBox
*)
//includepascal mydialog.pas head

(*
Inheriting the ListBox.
If you are already inheriting, I have also inserted the destructor, which cleans up the list at the end.
*)
//includepascal mydialog.pas type

(*
The new HandleEvent of the new ListBox, which catches the double click and interprets it as [Ok].
*)
//includepascal mydialog.pas event

(*
Manually release the memory of the list.
*)
//includepascal mydialog.pas done

(*
The event handle of the dialog.
Here an [Ok] is simply processed on double click.
*)
//includepascal mydialog.pas handleevent

end.
