//image image.png
(*
Beim Desktophintergrund kann man ein beliebiges Hintergrund-Zeichen zuordnen. Als Default ist das Zeichen <b>#176</b>.
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  Menus,    // Status line
  MsgBox,   // Messageboxen
  Dialogs;  // Dialoge

const
  cmOption = 1003;      // Parameter

type
  TMyApp = object(TApplication)
    constructor Init;                                  // Neuer Constructor

    procedure InitStatusLine; virtual;                 // Status line
    procedure InitMenuBar; virtual;                    // Menu
    procedure HandleEvent(var Event: TEvent); virtual; // Event handler

    procedure MyOption;                                // New function for a dialog.
  end;

(*
Der Hintergrund fügt man ähnlich zu, wie ein Fenster/Dialog, dies geschieht auch mit <b>Insert</b>.
Mit <b>#3</b> füllt es den Hintergrund mit Herzen auf.
*)

//code+
  constructor TMyApp.Init;
  var
    R: TRect;
  begin
    inherited Init;                                      // Vorfahre aufrufen
    GetExtent(R);

    DeskTop^.Insert(New(PBackGround, Init(R, #3)));   // Hintergrund einfügen.
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
      NewStatusKey('~F1~ About...', kbF1, cmOption, nil))), nil)));
  end;

  procedure TMyApp.InitMenuBar;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(
        NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)),
      NewSubMenu('~O~ption', hcNoContext, NewMenu(
        NewItem('~P~arameters...', '', kbF2, cmOption, hcNoContext, nil)), nil)))));
  end;

  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmOption: begin
          MyOption;
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;

  procedure TMyApp.MyOption;
  var
    Dia: PDialog;
    R: TRect;
  begin
    R.Assign(0, 0, 35, 15);
    R.Move(23, 3);
    Dia := New(PDialog, Init(R, 'Parameter'));
    if ValidView(Dia) <> nil then begin // Prüfen ob genügend Speicher.
      Desktop^.ExecView(Dia);           // Dialog ausführen.
      Dispose(Dia, Done);               // Dialog und Speicher frei geben.
    end;
  end;

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Initialize
  MyApp.Run;    // Execute
  MyApp.Done;   // Release
end.
