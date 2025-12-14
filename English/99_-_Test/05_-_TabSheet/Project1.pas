//image image.png
(*
In den vererbten Dialogen ist es möglich Buttons einzubauen, welche lokal im Dialog eine Aktion ausführen.
Im Beispiel wir eine MessageBox aufgerufen.
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
  cmAbout = 1001;     // Show about

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
      NewStatusKey('~F1~ About...', kbF1, cmAbout, nil))), nil)));
  end;

  procedure TMyApp.InitMenuBar;
  var
    R: TRect;            // Rectangle for the menu line position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(
        NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)),
      NewSubMenu('~H~elp', hcNoContext, NewMenu(
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil)))));
  end;

(*
Im Hauptprogramm ändert sich nichts daran, dem ist egal, ob lokal noch etwas gemacht wird.
*)
//code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    AboutDialog: PMyAbout;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of                   // About Dialog
        cmAbout: begin
          AboutDialog := New(PMyAbout, Init);
          if ValidView(AboutDialog) <> nil then begin // Prüfen ob genügend Speicher.
            Desktop^.ExecView(AboutDialog);           // Dialog About ausführen.
            Dispose(AboutDialog, Done);               // Dialog und Speicher frei geben.
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
<b>Unit mit dem neuen Dialog.</b>
<br>
Dort sieht man gut, das es ein Button für lokale Ereignisse hat.
Wichtig ist, bei den Nummernvergabe, das sich dies nicht mit einem anderen Eventnummer überschneidet.
Vor allem dann, wen der Dialog nicht Modal geöffnet wird.
Ausser es ist gewünscht, wen man zB. über das Menu auf den Dialog zugreifen will.
*)
//includepascal mydialog.pas head

(*
Für den Dialog kommt noch ein HandleEvent hinzu.
*)
//includepascal mydialog.pas type

(*
Im Konstruktor wird der Dialog noch um den Button Msg-box ergänzt, welcher das lokale Ereigniss <b>cmMsg</b> abarbeitet.
*)
//includepascal mydialog.pas init

(*
Im neuen EventHandle, werden loake Ereigniss (cmMsg) abarbeitet.
Andere Ereignisse, zB. <b>cmOk</b> wird an das Hauptprogramm weiter gereicht, welches dann den Dialog auch schliesst.
*)
//includepascal mydialog.pas handleevent

end.
