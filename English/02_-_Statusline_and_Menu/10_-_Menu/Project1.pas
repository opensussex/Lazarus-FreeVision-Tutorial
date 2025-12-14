//image image.png
(*
Adding a menu.
*)
//lineal
program Project1;

(*
The same units as for the status line are needed for the menu.
*)
//code+
uses
  App,      // TApplication
  Objects,  // Window area (TRect)
  Drivers,  // Hotkey
  Views,    // Event (cmQuit)
  Menus;    // Status line
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
    GetExtent(R);             // Returns the size/position of the App, normally 0, 0, 80, 24.
    R.A.Y := R.B.Y - 1;       // Position of the status line, set to the bottom line of the App.

    P3 := NewStatusKey('~F1~ Help', kbF1, cmHelp, nil);
    P2 := NewStatusKey('~F10~ Menu', kbF10, cmMenu, P3);
    P1 := NewStatusKey('~Alt+X~ Exit program', kbAltX, cmQuit, P2);
    P0 := NewStatusDef(0, $FFFF, P1, nil);

    StatusLine := New(PStatusLine, Init(R, P0));
  end;

(*
Creating the menu; the example has only a single menu item, Exit.
In the menu, the characters highlighted with <b>~x~</b> are not only visual but also functional.
To exit, you can also press <b>[Alt+f]</b>, <b>[e]</b>.
There are also direct hotkeys for menu items; in this example, <b>[Alt+x]</b> is for exit.
This coincidentally overlaps with <b>[Alt+x]</b> from the status line, but this doesn't matter.
The structure of menu creation is similar to the status line.
The last menu item always has a <b>nil</b>.
*)

  //code+
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;           // Rectangle for the menu line position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1; // Position of the menu, set to the top line of the App.

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(
      NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext,
      nil)), nil))));
  end;
  //code-

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Initialize
  MyApp.Run;    // Execute
  MyApp.Done;   // Release
end.
