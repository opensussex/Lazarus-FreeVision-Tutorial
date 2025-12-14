//image image.png
(*
Erstes Memo-Windows.
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Windowsbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit), Window
  Menus;    // Status line

(*
Der Constructor wird vererbt, so das von Anfang an ein neues Windows erstellt wird.
*)
//code+
type
  TMyApp = object(TApplication)
    constructor Init;

    procedure InitStatusLine; virtual;
    procedure InitMenuBar; virtual;

    procedure NewWindows;
  end;
  //code-
  //code+
  constructor TMyApp.Init;
  begin
    inherited Init;   // Der Vorfahre aufrufen.
    NewWindows;       // Windows erzeugen.
  end;
  //code-

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;

    StatusLine := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Exit program', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F1~ Help', kbF1, cmHelp, nil))), nil)));
  end;

  procedure TMyApp.InitMenuBar;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(
      NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext,
      nil)), nil))));
  end;

(*
Neues Windows erzeugen. Windows werden in der Regel nicht modal geöffnet, da man meistens mehrere davon öffnen will.
*)
  //code+
  procedure TMyApp.NewWindows;
  var
    Win: PWindow;
    R: TRect;
  begin
    R.Assign(0, 0, 60, 20);
    Win := New(PWindow, Init(R, 'Windows', wnNoNumber));
    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end;
  end;
  //code-

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Initialize
  MyApp.Run;    // Execute
  MyApp.Done;   // Release
end.
