//image image.png
(*
Will man bei einer <b>ListBox</b> den Doppelklick auswerten, muss man die ListBox vererben und einen neuen Handleevent einfügen.
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
  StdDlg,   // Für Datei öffnen
  MyDialog;

const
  cmDialog   = 1001;     // Dialog anzeigen

type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Status line
    procedure InitMenuBar; virtual;                    // Menu
    procedure HandleEvent(var Event: TEvent); virtual; // Event handler
    procedure OutOfMemory; virtual;                    // Wird aufgerufen, wen Speicher überläuft.
    procedure NewWindows(Titel: ShortString);
  end;

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;    // Rectangle for the status line position.
  begin

    // StatusBar
    GetExtent(R);
    R.A.Y := R.B.Y - 1;

    New(StatusLine,
      Init(R,
        NewStatusDef(0, $FFFF,
        NewStatusKey('~Alt+X~ Exit', kbAltX,  cmQuit,
        NewStatusKey('~F10~ Menu',   kbF10,   cmMenu,
        NewStatusKey('~F1~ Help',    kbF1,    cmHelp,
        StdStatusKeys(nil)))),nil)
      )
    );
  end;

  procedure TMyApp.InitMenuBar;
  var
    R: TRect;    // Rectangle for the menu line position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(
        NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)),
      NewSubMenu('~O~ption', hcNoContext, NewMenu(
        NewItem('Dia~l~og...', '', kbNoKey, cmDialog, hcNoContext, nil)), nil)))));
  end;

  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    MyDialog: PMyDialog;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmDialog: begin
          MyDialog := New(PMyDialog, Init);
          if ValidView(MyDialog) <> nil then begin
            Desktop^.ExecView(MyDialog);   // Dialog ausführen.
            Dispose(MyDialog, Done);       // Dialog und Speicher frei geben.
          end;
        end
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


  procedure TMyApp.NewWindows(Titel: ShortString);
  var
    Win: PWindow;
    R: TRect;
  begin
    R.Assign(0, 0, 60, 20);
    Win := New(PWindow, Init(R, Titel, wnNoNumber));
    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end;
  end;

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Initialize
  MyApp.Run;    // Execute
  MyApp.Done;   // Release

//lineal
(*
<b>Unit with the new dialog.</b>
<br>
The dialog with the ListBox
*)
//includepascal mydialog.pas head

(*
Das Vererben der ListBox.
Wen man schon vererbt, habe ich auch gleich den <b>Destructor</b> eingefügt, welcher am Schluss die Liste aufräumt.
*)
//includepascal mydialog.pas type

(*
Der neue <b>HandleEvent</b> der beuen ListBox, welcher den Doppelklick abfängt und ihn als [Ok] interprediert.
*)
//includepascal mydialog.pas event

(*
Manuell den Speicher der Liste frei geben.
*)
//includepascal mydialog.pas done

(*
Der EventHandle des Dialogs.
Hier wird einfach ein [Ok] bei dem Doppelklick abgearbeitet.
*)
//includepascal mydialog.pas handleevent

end.
