//image image.png
(*
In den vererbten Dialogen ist es möglich Buttons einubauen, welche lokal im Dialog eine Aktion ausführen.
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
    R: TRect;                       // Rectangle for the menu line position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(
        NewItem('~S~chliessen', 'Crt-F4', kbCtrlF4, cmClose, hcNoContext,
        NewLine(
        NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)))),
      NewSubMenu('~O~ption', hcNoContext, NewMenu(
        NewItem('Dia~l~og...', '', kbNoKey, cmAbout, hcNoContext,
        NewItem('Test', '', kbNoKey, 1003, hcNoContext, nil))), nil)))));
  end;

  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    MyDialog: PMyDialog;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of                   // About Dialog
        cmAbout: begin
          MyDialog := New(PMyDialog, Init);
//          if ValidView(MyDialog) <> nil then begin // Prüfen ob genügend Speicher.
//            Desktop^.ExecView(MyDialog);           // Dialog About ausführen.
//            Dispose(MyDialog, Done);               // Dialog und Speicher frei geben.
//          end;
          Desktop^.Insert(MyDialog);
        end;
          1003:        MessageBox('Ich bin eine Liste', nil, mfError + mfOkButton);
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;

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
Dort wird gezeigt, wie man Werte bei Komponenten zu Laufzeit lesen und schreiben kann.
Als Beispiel, wird die Zahl im Button bei jedem drücken um 1 erhöht.
*)
//includepascal mydialog.pas head

(*
Will man eine Komponente zur Laufzeit modifizieren, dann muss man sie deklarieren, ansonsten kann man nicht mehr auf sie zugreifen.
Direkt mit <b>Insert(New(...</b> geht nicht mehr.
*)
//includepascal mydialog.pas type

(*
Im Konstruktor sieht man, das man den Umweg über der <b>CounterButton</b> macht.
<b>CounterButton</b> wird für die Modifikation gebraucht.
*)
//includepascal mydialog.pas init

(*
Im EventHandle, wird die Zahl im Button beim Drücken erhöht.
Das sieht man, warum man den <b>CounterButton</b> braucht, ohne dem hätte man keinen Zugriff auf <b>Titel</b>.
Wichtig, wen man eine Komponente ändert, muss man mit <b>Draw</b> die Komponente neu zeichnen, ansonsten sieht man den geänderten Wert nicht.
*)
//includepascal mydialog.pas handleevent

end.
