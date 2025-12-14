//image image.png
(*
Processing events from the status line and menu.
*)
//lineal
program Project1;

(*
For dialogs, you must also include the unit <b>Dialogs</b>.
*)
//code+
uses
  App,      // TApplication
  Objects,  // Window area (TRect)
  Drivers,  // Hotkey
  Views,    // Event (cmQuit)
  Menus,    // Status line
  Dialogs;  // Dialogs
//code-

(*
Another command for calling the dialog.
*)
//code+
const
  cmAbout = 1001;     // Show about
  cmList = 1002;      // File list
  cmPara = 1003;      // Parameters
  //code-

(*
New functions are also added to the class.
Here a dialog for parameter input.
*)
  //code+
type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Status line
    procedure InitMenuBar; virtual;                    // Menu
    procedure HandleEvent(var Event: TEvent); virtual; // Event handler

    procedure MyParameter;                             // New function for a dialog.
  end;
  //code-

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;                 // Rectangle for the status line position.

    P0: PStatusDef;           // Pointer to entire entry.
    P1, P2, P3: PStatusItem;  // Pointer to individual hotkeys.
  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;

    P3 := NewStatusKey('~F1~ Help', kbF1, cmHelp, nil);
    P2 := NewStatusKey('~F10~ Menu', kbF10, cmMenu, P3);
    P1 := NewStatusKey('~Alt+X~ Exit program', kbAltX, cmQuit, P2);
    P0 := NewStatusDef(0, $FFFF, P1, nil);

    StatusLine := New(PStatusLine, Init(R, P0));
  end;

(*
The menu is extended with Parameters and Close.
*)
  //code+
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;                          // Rectangle for the menu line position.

    M: PMenu;                          // Entire menu
    SM0, SM1,                          // Submenu
    M0_0, M0_1, M0_2, M0_3, M0_4, M0_5,
    M1_0: PMenuItem;                   // Simple menu items

  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    M1_0 := NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil);
    SM1 := NewSubMenu('~H~elp', hcNoContext, NewMenu(M1_0), nil);

    M0_5 := NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil);
    M0_4 := NewLine(M0_5);
    M0_3 := NewItem('~C~lose', 'Alt-F3', kbAltF3, cmClose, hcNoContext, M0_4);
    M0_2 := NewLine(M0_3);
    M0_1 := NewItem('~P~arameters...', '', kbF2, cmPara, hcNoContext, M0_2);
    M0_0 := NewItem('~L~ist', 'F2', kbF2, cmList, hcNoContext, M0_1);
    SM0 := NewSubMenu('~F~ile', hcNoContext, NewMenu(M0_0), SM1);

    M := NewMenu(SM0);

    MenuBar := New(PMenuBar, Init(R, M));
  end;
  //code-

(*
Here a dialog is opened with the command <b>cmPara</b>.
*)
  //code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin
        end;
        cmList: begin
        end;
        cmPara: begin     // Open parameter dialog.
          MyParameter;
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;
  //code-

(*
Building an empty dialog.
Here too <b>TRect</b> is needed for the size.
This is needed for all components, whether button, etc.
*)
  //code+
  procedure TMyApp.MyParameter;
  var
    Dlg: PDialog;
    R: TRect;
  begin
    R.Assign(0, 0, 35, 15);                    // Size of the dialog.
    R.Move(23, 3);                             // Position of the dialog.
    Dlg := New(PDialog, Init(R, 'Parameter')); // Create dialog.
    Desktop^.Insert(Dlg);                      // Assign dialog to the app.
  end;
  //code-

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Initialize
  MyApp.Run;    // Execute
  MyApp.Done;   // Release
end.
