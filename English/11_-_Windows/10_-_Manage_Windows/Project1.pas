//image image.png
(*
Windows verwalten. Nun ist es möglich über das Menu Steuerkomandos für die Windowsverwaltung zu geben.
ZB. Zoom, verkleinern, Windowswechsel, Kaskade, etc.
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Windowsbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit), Window
  MsgBox,
  Editors,  // Messageboxen
  Dialogs,  // Dialoge
  Menus;    // Status line

const
  cmNewWin = 1001;
  cmRefresh = 1002;
type

  { TMyApp }

  TMyApp = object(TApplication)
    constructor Init;

    procedure InitStatusLine; virtual;
    procedure InitMenuBar; virtual;

    procedure HandleEvent(var Event: TEvent); virtual;
    procedure OutOfMemory; virtual;

    procedure NewWindows;
    procedure CloseAll;
  end;

  constructor TMyApp.Init;
  begin
    inherited Init;   // Der Vorfahre aufrufen.
    NewWindows;       // Windows erzeugen.
  end;

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;              // Rectangle for the status line position.
  begin
    GetExtent(R);          // Liefert die Grösse/Position der App, im Normalfall 0, 0, 80, 24.
    R.A.Y := R.B.Y - 1   ; // Position der Status line, auf unterste Zeile der App setzen.

    StatusLine := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Exit program', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F1~ Help', kbF1, cmHelp, nil))), nil)));
  end;

(*
Das Menu wurde um die Steuerbefehle für die Windowsverwatung ergänzt.
Die ausgeklammerten Kommandos müssen manuel gemacht werden.
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
        NewItem('~N~eu', 'F4', kbF4, cmNewWin, hcNoContext,
        NewLine(
        NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)))),
      NewSubMenu('~F~enster', hcNoContext, NewMenu(
        NewItem('~N~ebeneinander', '', kbNoKey, cmTile, hcNoContext,
        NewItem(#154'ber~l~append', '', kbNoKey, cmCascade, hcNoContext,
        NewItem('~A~lle schliessen', '', kbNoKey, cmCloseAll, hcNoContext,
        NewItem('Anzeige ~e~rneuern', '', kbNoKey, cmRefresh, hcNoContext,
        NewLine(
        NewItem('Gr'#148'sse/~P~osition', 'Ctrl+F5', kbCtrlF5, cmResize, hcNoContext,
        NewItem('Ver~g~'#148'ssern', 'F5', kbF5, cmZoom, hcNoContext,
        NewItem('~N~'#132'chstes', 'F6', kbF6, cmNext, hcNoContext,
        NewItem('~V~orheriges', 'Shift+F6', kbShiftF6, cmPrev, hcNoContext,
        NewLine(
        NewItem('~S~chliessen', 'Alt+F3', kbAltF3, cmClose, hcNoContext, Nil)))))))))))), nil)))));

  end;
  //code-

  procedure TMyApp.OutOfMemory;
  begin
    MessageBox('Zu wenig Arbeitsspeicher !', nil, mfError + mfOkButton);
  end;

(*
Beim Windows erzeugen, ist noch ein Counter hinzugekommen.
Wen man bei den Windows eine überlappend oder nebeneinader Darstellung will, muss man noch den Status <b>ofTileable</b> setzen.
*)
  //code+
  procedure TMyApp.NewWindows;
  var
    Win: PWindow;
    R: TRect;
  const
    WinCounter: integer = 0;                    // Zählt Windows
  begin
    R.Assign(0, 0, 60, 20);
    Inc(WinCounter);
    Win := New(PWindow, Init(R, 'Windows', WinCounter));
    Win^.Options := Win^.Options or ofTileable; // Für Tile und Cascade

    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end else begin
      Dec(WinCounter);
    end;
  end;
//code-
(*
Diese Procedure schliesst alle Windows im Desktop.
Dazu wird jedem Windows mit <b>ForEach</b> ein <b>cmClose</b>-Event gesendet.
*)
//code+
  procedure TMyApp.CloseAll;

    procedure SendClose(P: PView);
    begin
      Message(P, evCommand, cmClose, nil);
    end;

  begin
    Desktop^.ForEach(@SendClose);
  end;
//code-


(*
<b>cmNewWin</b> muss man selbst abarbeiten. <b>cmClose</b> für das Schliessen des Windows läuft im Hintergrund automatisch.
*)
//code+

  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmNewWin: begin
          NewWindows;    // Windows erzeugen.
        end;
        cmCloseAll:begin
          CloseAll;      // Schliesst alle Windows.
        end;
        cmRefresh: begin
          ReDraw;        // Anwendung neu zeichnen.
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;
  //code-

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Initialize
  MyApp.Run;    // Execute
  MyApp.Done;   // Release
end.
