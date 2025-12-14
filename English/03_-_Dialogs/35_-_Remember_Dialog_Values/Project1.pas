//image image.png
(*
Until now, the values in the dialog were always lost, when you closed and reopened it.
For this reason, the values are now stored in a record.
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  Menus,    // Status line
  Dialogs;  // Dialoge

const
  cmAbout = 1001;     // Show about
  cmList = 1002;      // File list
  cmPara = 1003;      // Parameter

  (*
  The values of the dialog are stored in this record.
  The order of the data in the record <b>muss</b> genau gleich sein, wie bei der Erstellung der Komponenten, otherwise there will be a crash.
  Bei Turbo-Pascal musste ein <b>Word</b> anstelle von <b>LongWord</b> genommen werden, dies ist wichtig beim Portieren alter Anwendungen.
  *)
  //code+
type
  TParameterData = record
    Druck,
    Schrift: longword;
    Hinweis: string[50];
  end;
  //code-

(*
Hier wird noch der Constructor vererbt, diesen Nachkomme wird gebraucht um die Dialogdaten mit Standard Werte zu laden.
*)
  //code+
type
  TMyApp = object(TApplication)
    ParameterData: TParameterData;                     // Data for parameter dialog
    constructor Init;                                  // New constructor

    procedure InitStatusLine; virtual;                 // Status line
    procedure InitMenuBar; virtual;                    // Menu
    procedure HandleEvent(var Event: TEvent); virtual; // Event handler

    procedure MyParameter;                             // New function for a dialog.
  end;
  //code-

(*
The constructor that loads the values for the dialog.
The data structure for radio buttons is simple. 0 is the first button, 1 the second, 2 the third, usw.
Bei den Checkboxen macht man es am besten Binär. Im Beispiel werden der erste und dritte CheckBox gesetzt.
*)
  //code+
  constructor TMyApp.Init;
  begin
    inherited Init;     // Vorfahre aufrufen
    with ParameterData do begin
      Druck := %0101;
      Schrift := 2;
      Hinweis := 'Hello world';
    end;
  end;
  //code-

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;                 // Rectangle for the status line position.

    P0: PStatusDef;           // Pointer to entire entry.
    P1, P2, P3: PStatusItem;  // Pointer to individual hotkeys.
  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;

    P3 := NewStatusKey('~F1~ Help', kbF1, cmHelp, nil);
    P2 := NewStatusKey('~F10~ Menu', kbF10, cmMenu, P3);
    P1 := NewStatusKey('~Alt+X~ Exit program', kbAltX, cmQuit, P2);
    P0 := NewStatusDef(0, $FFFF, P1, nil);

    StatusLine := New(PStatusLine, Init(R, P0));
  end;

  procedure TMyApp.InitMenuBar;
  var
    R: TRect;                       // Rectangle for the menu line position.

    M: PMenu;                       // Entire menu
    SM0, SM1, SM2,                  // Submenu
    M0_0, M0_2, M0_3, M0_4, M0_5,
    M1_0, M2_0: PMenuItem;          // Simple menu items

  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    M2_0 := NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil);
    SM2 := NewSubMenu('~H~elp', hcNoContext, NewMenu(M2_0), nil);

    M1_0 := NewItem('~P~arameters...', '', kbF2, cmPara, hcNoContext, nil);
    SM1 := NewSubMenu('~O~ption', hcNoContext, NewMenu(M1_0), SM2);

    M0_5 := NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil);
    M0_4 := NewLine(M0_5);
    M0_3 := NewItem('~C~lose', 'Alt-F3', kbAltF3, cmClose, hcNoContext, M0_4);
    M0_2 := NewLine(M0_3);
    M0_0 := NewItem('~L~ist', 'F2', kbF2, cmList, hcNoContext, M0_2);
    SM0 := NewSubMenu('~F~ile', hcNoContext, NewMenu(M0_0), SM1);

    M := NewMenu(SM0);

    MenuBar := New(PMenuBar, Init(R, M));
  end;

  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin
        end;
        cmList: begin
        end;
        cmPara: begin
          MyParameter;
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;

(*
Der Dialog wird jetzt mit Werten geladen.
Dies macht man, sobald man fertig ist mit Komponenten ertstellen.
*)
  //code+
  procedure TMyApp.MyParameter;
  var
    Dlg: PDialog;
    R: TRect;
    dummy: word;
    View: PView;
  begin
    R.Assign(0, 0, 35, 15);
    R.Move(23, 3);
    Dlg := New(PDialog, Init(R, 'Parameter'));
    with Dlg^ do begin

      // CheckBoxes
      R.Assign(2, 3, 18, 7);
      View := New(PCheckBoxes, Init(R,
        NewSItem('~F~ile',
        NewSItem('~L~ine',
        NewSItem('D~a~te',
        NewSItem('~T~ime',
        nil))))));
      Insert(View);
      // Label für CheckGroup.
      R.Assign(2, 2, 10, 3);
      Insert(New(PLabel, Init(R, 'Pr~i~nt', View)));

      // RadioButtons
      R.Assign(21, 3, 33, 6);
      View := New(PRadioButtonss, Init(R,
        NewSItem('~G~ross',
        NewSItem('~M~ittel',
        NewSItem('~K~lein',
        nil)))));
      Insert(View);
      // Label für RadioGroup.
      R.Assign(20, 2, 31, 3);
      Insert(New(PLabel, Init(R, '~S~chrift', View)));

      // Edit Zeile
      R.Assign(3, 10, 32, 11);
      View := New(PInputLine, Init(R, 50));
      Insert(View);
      // Label für Edit Zeile
      R.Assign(2, 9, 10, 10);
      Insert(New(PLabel, Init(R, '~N~ote', View)));

      // Ok-Button
      R.Assign(7, 12, 17, 14);
      Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));

      // Schliessen-Button
      R.Assign(19, 12, 32, 14);
      Insert(new(PButton, Init(R, '~C~ancel', cmCancel, bfNormal)));
    end;
    Dlg^.SetData(ParameterData);      // Dialog mit den Werten laden.
    dummy := Desktop^.ExecView(Dlg);  // Dialog ausführen.
    if dummy = cmOK then begin        // Wen Dialog mit Ok beenden, dann Daten vom Dialog in Record laden.
      Dlg^.GetData(ParameterData);
    end;

    Dispose(Dlg, Done);               // Release dialog and memory.
  end;
  //code-
var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Initialize
  MyApp.Run;    // Execute
  MyApp.Done;   // Release
end.
