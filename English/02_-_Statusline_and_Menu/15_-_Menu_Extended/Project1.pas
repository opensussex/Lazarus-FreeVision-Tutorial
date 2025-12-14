//image image.png
(*
Adding multiple menu items.
For clarity, this is also split.
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Window area (TRect)
  Drivers,  // Hotkey
  Views,    // Event (cmQuit)
  Menus;    // Status line

(*
For custom commands, you must define command codes.
It is recommended to use values > 1000 to avoid overlaps with standard codes.
*)
//code+
const
  cmList = 1002;      // File list
  cmAbout = 1001;     // Show about
  //code-

(*
For a menu, you must inherit <b>InitMenuBar</b>.
*)
  //code+
type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;   // Status line
    procedure InitMenuBar; virtual;      // Menu
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
You can also split menu entries via pointers.
Whether you nest or split is a matter of taste.
With <b>NewLine</b> you can insert a blank line.
It is recommended that if a dialog opens for a menu item, you write <b>...</b> after the label.
*)
  //code+
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;                          // Rectangle for the menu line position.

    M: PMenu;                          // Entire menu
    SM0, SM1,                          // Submenu
    M0_0, M0_1, M0_2, M1_0: PMenuItem; // Simple menu items

  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    M1_0 := NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil);
    SM1 := NewSubMenu('~H~elp', hcNoContext, NewMenu(M1_0), nil);

    M0_2 := NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil);
    M0_1 := NewLine(M0_2);
    M0_0 := NewItem('~L~ist', 'F2', kbF2, cmList, hcNoContext, M0_1);
    SM0 := NewSubMenu('~F~ile', hcNoContext, NewMenu(M0_0), SM1);

    M := NewMenu(SM0);

    MenuBar := New(PMenuBar, Init(R, M));
  end;
  //code-

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Initialize
  MyApp.Run;    // Execute
  MyApp.Done;   // Release
end.
