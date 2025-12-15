//image image.png
(*
In diesem Beispiel wird ein kleines Gadgets geladen, welches eine <b>Uhr</b> anzeigt.
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Window area (TRect)
  Drivers,  // Hotkey
  Views,    // Event (cmQuit)
  Menus,    // Status line
  MsgBox,   // Message boxes
  Dialogs,  // Dialogs
  StdDlg,   // For file open
  Gadgets,
  MyDialog;

const
  cmDialog   = 1001;     // Show dialog
  cmFileTest = 1002;

type
  TMyApp = object(TApplication)
    Heap: PClockView;
    procedure InitStatusLine; virtual;                 // Status line
    procedure InitMenuBar; virtual;                    // Menu
    procedure HandleEvent(var Event: TEvent); virtual; // Event handler
    procedure OutOfMemory; virtual;                    // Called when memory overflows.

    procedure NewWindows(Titel: ShortString);

    procedure Idle; Virtual;
  end;

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;    // Rectangle for the status line position.
  begin

    // StatusBar
    GetExtent(R);
    R.B.X := R.B.X - 9;
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

    (*
    Erzeugt ein kleines Fenster rechts-down, welches die Uhr anzeigt.
    *)
    //code+
    GetExtent(R);
    R.A.X := R.B.X - 9;
    R.A.Y := R.B.Y - 1;
    Heap := New(PClockView, Init(R));
    Insert(Heap); 
    //code-
  end;

  procedure TMyApp.InitMenuBar;
  var
    R: TRect;    // Rectangle for the menu line position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(
        NewItem('~F~ile open', '', kbNoKey, cmFileTest, hcNoContext,
        NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil))),
      NewSubMenu('~O~ption', hcNoContext, NewMenu(
        NewItem('Dia~l~og...', '', kbNoKey, cmDialog, hcNoContext, nil)), nil)))));
  end;

(*
Den Dialog mit dem Speicher Leak aufrufen.
*)
//code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    MyDialog: PMyDialog;
    FileDialog: PFileDialog;
    FileName: ShortString;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        // Dialog mit der ListBox, welcher ein Speicher Leak hat.
        cmDialog: begin
          MyDialog := New(PMyDialog, Init);
          if ValidView(MyDialog) <> nil then begin
            Desktop^.ExecView(MyDialog);   // Dialog ausführen.
            Dispose(MyDialog, Done);       // Release dialog and memory.
          end;
        end;
        // Ein FileOpenDialog, bei dem alles in Ordnung ist.
        cmFileTest:begin
          FileName := '*.*';
          New(FileDialog, Init(FileName, 'Datei '#148'ffnen', '~F~ilename', fdOpenButton, 1));
          if ExecuteDialog(FileDialog, @FileName) <> cmCancel then begin
            NewWindows(FileName); // Neues Fenster mit der ausselecteden Datei.
          end;
        end
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

(*
Die Idle Routine, welche im Leerlauf den Heap prüft und anzeigt.
*)
//code+
  procedure TMyApp.Idle;

    function IsTileable(P: PView): Boolean;
    begin
      Result := (P^.Options and ofTileable <> 0) and (P^.State and sfVisible <> 0);
    end;

  begin
    inherited Idle;
    Heap^.Update;
    if Desktop^.FirstThat(@IsTileable) <> nil then begin
      EnableCommands([cmTile, cmCascade])
    end else begin
      DisableCommands([cmTile, cmCascade]);
    end;
  end;
//code-

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
Der Dialog mit dem dem Speicher Leak
*)
//includepascal mydialog.pas head

(*
Den <b>Destructor</b> deklarieren, welcher das <b>Speicher Leak</b> behebt.
*)
//includepascal mydialog.pas type

(*
Komponenten für den Dialog generieren.
*)
//includepascal mydialog.pas init

(*
Manuell den Speicher frei geben.
Man kann hier versuchsweise das Dispose ausklammern, dann sieht man,
das man eine Speicherleak bekommt.
*)
//includepascal mydialog.pas done

(*
Der EventHandle
*)
//includepascal mydialog.pas handleevent

end.
