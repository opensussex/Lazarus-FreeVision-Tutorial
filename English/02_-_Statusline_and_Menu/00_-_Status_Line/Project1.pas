//image image.png
(*
Changing the status line.
The status line is used to display important information and hotkeys.
*)
//lineal
program Project1;

(*
Various units are needed for the status line.
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
If you want to change something, you must inherit from TApplication.
In this example, the status line is modified; to do this, you must override the procedure <b>InitStatusLine</b>.
*)
//code+
type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;
end;
//code.

(*
The new method for the status line.
<b>GetExtent(Rect);</b> returns the size of the window.
<b>A</b> is the top-left position and <b>B</b> is bottom-right.
To make the hotkey more visible, write it in <b>~xxx~</b>.
*)
  //code+
  procedure TMyApp.InitStatusLine;
  var
    R: TRect;           // Rectangle for the status line position.
  begin
    GetExtent(R);       // Returns the size/position of the App, normally 0, 0, 80, 24.
    R.A.Y := R.B.Y - 1; // Position of the status line, set to the bottom line of the App.

    StatusLine := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF, NewStatusKey('~Alt+X~ Exit program', kbAltX, cmQuit, nil), nil)));
  end;
  //code-

(*
For the new status line to be used, you must declare the descendant instead of <b>TApplication</b>.
*)
//code+
var
  MyApp: TMyApp;
//code-
(*
The execution remains the same.
*)
//code+
begin
  MyApp.Init;   // Initialize
  MyApp.Run;    // Execute
  MyApp.Done;   // Release
end.
//code-
