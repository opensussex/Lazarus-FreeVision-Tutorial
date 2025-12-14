//image image.png
(*
There are ready-made items for the status line and menu, but I prefer to create the items myself.
The ready-made items are only in English.
The status line is textless; the only thing it brings are quick commands (cmQuit, cmMenu, cmClose, cmZoom, cmNext, cmPrev).
Except for <b>OS shell</b> and <b>Exit</b>, nothing happens.
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Window area (TRect)
  Drivers,  // Hotkey
  Views,    // Event (cmQuit)
  Menus;    // Status line

type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;   // Status line
    procedure InitMenuBar; virtual;      // Menu
  end;
(*
With <b>StdStatusKeys(...</b> a status line is created, but as described above, you don't see any text.
*)
//code+
  procedure TMyApp.InitStatusLine;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;

    StatusLine := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF, StdStatusKeys(nil), nil)));
  end;
//code-

(*
For the menu, there are 3 ready-made items for File, Edit, and Window, but in English.
*)
  //code+
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(
        StdFileMenuItems (nil)),
      NewSubMenu('~E~dit', hcNoContext, NewMenu(
         StdEditMenuItems (nil)),
      NewSubMenu('~W~indow', hcNoContext, NewMenu(
        StdWindowMenuItems(nil)), nil)))));;
  end;
  //code-

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Initialize
  MyApp.Run;    // Execute
  MyApp.Done;   // Release
end.
