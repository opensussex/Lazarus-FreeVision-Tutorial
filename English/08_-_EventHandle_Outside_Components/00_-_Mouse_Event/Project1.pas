//image image.png
(*
Man kann einen EventHandle im Dialog/Fenster abfangen, wen man die Maus bewegt/klickt.
Im Hauptprogramm hat es dafür nichts besonders, dies alles läuft lokal im Dialog/Fenster ab.
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
  Dialogs,  // Dialoge
  MyDialog;

const
  cmMouseAktion = 1001;     // Show about

type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Status line
    procedure InitMenuBar; virtual;                    // Menu
    procedure HandleEvent(var Event: TEvent); virtual; // Event handler
    procedure OutOfMemory; virtual;                    // Wird aufgerufen, wen Speicher überläuft.
  end;

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;              // Rectangle for the status line position.
  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;

    StatusLine := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Exit program', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F1~ Mausaktionen...', kbF1, cmMouseAktion, nil))), nil)));
  end;

  procedure TMyApp.InitMenuBar;
  var
    R: TRect;                       // Rectangle for the menu line position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(
        NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)),
      NewSubMenu('~O~ption', hcNoContext, NewMenu(
        NewItem('~M~ausaktionen...', '', kbNoKey, cmMouseAktion, hcNoContext, nil)), nil)))));
  end;

(*
Im Hauptprogramm wird nur der Dialog gebaut, aufgerufe und geschlossen.
*)
//code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    MouseDialog: PMyMouse;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmMouseAktion: begin
          MouseDialog := New(PMyMouse, Init);
          if ValidView(MouseDialog) <> nil then begin // Prüfen ob genügend Speicher.
            Desktop^.ExecView(MouseDialog);           // Dialog Mausaktion ausführen.
            Dispose(MouseDialog, Done);               // Dialog und Speicher frei geben.
          end;
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;
//code-

  procedure TMyApp.OutOfMemory;
  begin
    MessageBox('Zu wenig Arbeitsspeicher !', nil, mfError + mfOkButton);
  end;

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Initialize
  MyApp.Run;    // Execute
  MyApp.Done;   // Release

//lineal
(*
<b>Unit mit dem Mausaktions-Dialog.</b>
<br>
*)
//includepascal mydialog.pas head

(*
In dem Object sind die <b>PEditLine</b> globel deklariert, da diese später bei Mausaktionen modifiziert werden.
*)
//includepascal mydialog.pas type

(*
Es wird ein Dialog mit EditLine, Label und Button gebaut.
Einzig besonderes dort, die <b>Editlline</b> wird der Status auf <b>ReadOnly</b> gesetzt eigene Eingaben sind dort unerwünscht.
*)
//includepascal mydialog.pas init

(*
Im EventHandle sieht man gut, das dort die Mausaktionen abgefangen werden.
Die Maus-Daten werden an die <b>EditLines</b> ausgegeben.
*)
//includepascal mydialog.pas handleevent

end.
