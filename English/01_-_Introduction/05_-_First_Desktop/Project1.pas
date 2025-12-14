//image image.png

(*
Minimal Free-Vision application
*)
//lineal
(*
Program name, as is customary in Pascal.
*)
//code+
program Project1;
//code-

(*
For Free-Vision to be possible at all, the unit <b>App</b> must be included.
*)
//code+
uses
  App;   // TApplication
//code-

(*
Declaration for the Free-Vision application.
*)
//code+
var
  MyApp: TApplication;
//code-

(*
The following three steps are always necessary for execution.
*)
  //code+
begin
  MyApp.Init;   // Initialize
  MyApp.Run;    // Execute
  MyApp.Done;   // Release
end.
//code-

