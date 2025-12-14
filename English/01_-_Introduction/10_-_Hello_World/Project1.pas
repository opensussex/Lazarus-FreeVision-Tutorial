//image image.png
(*
A Hello World with Free-Vision.
The text is displayed in a message box.
*)
//lineal
//code+
program Project1;

uses
  App, MsgBox;
var
  MyApp: TApplication;

begin
  MyApp.Init;
  MessageBox('Hello World !', nil, mfOKButton);
  // MyApp.Run;   // If it should continue.
  MyApp.Done;
end.
//code-

