//image image.png
(*
Hints in the status line for menu items.
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
Constants for individual help items.
It's best to use hcxxx names.
*)
//code+
const
  cmList   = 1002;  // File list
  cmAbout  = 1001;  // Show about

  hcFile   = 10;
  hcClose  = 11;
  hcOption = 12;
  hcFormat = 13;
  hcEdit   = 14;
  hcHelp   = 15;
  hcAbout  = 16;
//code-

type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;   // Status line
    procedure InitMenuBar; virtual;      // Menu
  end;

(*
The hint line must be inherited.
*)
//code+
  PHintStatusLine = ^THintStatusLine;
  THintStatusLine = object(TStatusLine)
    function Hint(AHelpCtx : Word): ShortString; virtual;
  end;

  function THintStatusLine.Hint(AHelpCtx: Word): ShortString;
  begin
    case AHelpCtx of
      hcFile:   Hint := 'Manage files';
      hcClose:  Hint := 'Exit program';
      hcOption: Hint := 'Various options';
      hcFormat: Hint := 'Set format';
      hcEdit:   Hint := 'Editor options';
      hcHelp:   Hint := 'Help';
      hcAbout:  Hint := 'Developer info';
    else
      Hint := '';
    end;
  end;
// code-

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;

    StatusLine := New(PHintStatusLine, Init(R, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Exit program', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F1~ Help', kbF1, cmHelp, nil))), nil)));
  end;
(*
In the menu, the hcxxx constant must be passed.
*)
//code+
  procedure TMyApp.InitMenuBar;
  var
    R: TRect;                   // Rectangle for the menu line position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcFile, NewMenu(
        NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcClose, nil)),

      NewSubMenu('~O~ptions', hcOption, NewMenu(
        NewItem('~F~ormat', '', kbNoKey, cmAbout, hcFormat,
        NewItem('~E~ditor', '', kbNoKey, cmAbout, hcEdit, nil))),

      NewSubMenu('~H~elp', hcHelp, NewMenu(
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcAbout, nil)), nil)))));;
  end;
//code-

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Initialize
  MyApp.Run;    // Execute
  MyApp.Done;   // Release
end.
