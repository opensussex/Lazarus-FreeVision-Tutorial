//image image.png
(*
Here an About dialog is created, you can see well what labels can be used for.
*)
//lineal
program Project1;

uses
  SysUtils, // For file operations
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  Menus,    // Status line
  MsgBox,   // Messageboxen
  Dialogs;  // Dialoge

(*
The file in which the data for the dialog is located.
*)
//code+
const
  DialogFile = 'parameter.cfg';
  //code-

  cmAbout = 1001;     // Show about
  cmList = 1002;      // File list
  cmPara = 1003;      // Parameter

type
  TParameterData = record
    Druck,
    Schrift: longword;
    Hinweis: string[50];
  end;

(*
A new function.*has been added.
*)
  //code+
type
  TMyApp = object(TApplication)
    ParameterData: TParameterData;                     // Parameters for dialog.
    fParameterData: file of TParameterData;            // File handler for saving/loading dialog data.

    constructor Init;                                  // New constructor

    procedure InitStatusLine; virtual;                 // Status line
    procedure InitMenuBar; virtual;                    // Menu
    procedure HandleEvent(var Event: TEvent); virtual; // Event handler
    procedure OutOfMemory; virtual;                    // Called when memory overflows.

    procedure MyParameter;                             // New function for a dialog.
    procedure About;                                   // About dialog.
  end;
  //code-

  constructor TMyApp.Init;
  begin
    inherited Init;
    // Check if file exists.
    if FileExists(DialogFile) then begin
      // Load data from disk.
      AssignFile(fParameterData, DialogFile);
      Reset(fParameterData);
      Read(fParameterData, ParameterData);
      CloseFile(fParameterData);
      // Otherwise take default values.
    end else begin
      with ParameterData do begin
        Druck := %0101;
        Schrift := 2;
        Hinweis := 'Hello world !';
      end;
    end;
  end;

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

(*
Here About is called, wen im Menu About gewält wird.
*)
  //code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin
          About;   // About dialog aufrufen
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
  //code-

  procedure TMyApp.OutOfMemory;
  begin
    MessageBox('Not enough memory !', nil, mfError + mfOkButton);
  end;

  procedure TMyApp.MyParameter;
  var
    Dia: PDialog;
    R: TRect;
    dummy: word;
    Ptr: PView;
  begin
    R.Assign(0, 0, 35, 15);
    R.Move(23, 3);
    Dia := New(PDialog, Init(R, 'Parameter'));
    with Dia^ do begin

      // CheckBoxes
      R.Assign(2, 3, 18, 7);
      Ptr := New(PCheckBoxes, Init(R,
        NewSItem('~F~ile',
        NewSItem('~L~ine',
        NewSItem('D~a~te',
        NewSItem('~T~ime',
        nil))))));
      Insert(Ptr);
      // Label für CheckGroup.
      R.Assign(2, 2, 10, 3);
      Insert(New(PLabel, Init(R, 'Pr~i~nt', Ptr)));

      // RadioButtons
      R.Assign(21, 3, 33, 6);
      Ptr := New(PRadioButtonss, Init(R,
        NewSItem('~G~ross',
        NewSItem('~M~ittel',
        NewSItem('~K~lein',
        nil)))));
      Insert(Ptr);
      // Label für RadioGroup.
      R.Assign(20, 2, 31, 3);
      Insert(New(PLabel, Init(R, '~S~chrift', Ptr)));

      // Edit Zeile
      R.Assign(3, 10, 32, 11);
      Ptr := New(PInputLine, Init(R, 50));
      Insert(Ptr);
      // Label für Edit Zeile
      R.Assign(2, 9, 10, 10);
      Insert(New(PLabel, Init(R, '~N~ote', Ptr)));

      // Ok-Button
      R.Assign(7, 12, 17, 14);
      Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));

      // Schliessen-Button
      R.Assign(19, 12, 32, 14);
      Insert(new(PButton, Init(R, '~C~ancel', cmCancel, bfNormal)));
    end;
    if ValidView(Dia) <> nil then begin // Prüfen ob genügend Speicher.
      Dia^.SetData(ParameterData);      // Dialog mit den Werten laden.
      dummy := Desktop^.ExecView(Dia);  // Dialog ausführen.
      if dummy = cmOK then begin        // Wen Dialog mit Ok beenden, dann Daten vom Dialog in Record laden.
        Dia^.GetData(ParameterData);

        // Save data to disk.
        AssignFile(fParameterData, DialogFile);
        Rewrite(fParameterData);
        Write(fParameterData, ParameterData);
        CloseFile(fParameterData);
      end;

      Dispose(Dia, Done);               // Release dialog and memory.
    end;
  end;

(*
About dialog erstellen.
Mit <b>TRext.Grow(...</b> you can shrink and enlarge the rect.
Mit <b>#13</b> you can insert a line break.
Mit <b>#3</b> the text is centered horizontally in the rect.
Mit <b>#2</b> the text is right-aligned.

Mit <b>PLabel</b> you could also output text, but.*is better suited for fixed text.
*)
  //code+
  procedure TMyApp.About;
  var
    Dlg: PDialog;
    R: TRect;
  begin
    R.Assign(0, 0, 42, 11);
    R.Move(1, 1);
    Dlg := New(PDialog, Init(R, 'About'));
    with Dlg^ do begin
      Options := Options or ofCentered; // Center dialog

      // Insert StaticText.
      R.Assign(2, 2, 40, 8);
      Insert(New(PStaticText, Init(R,
        #13 +
        'Free Vison Tutorial 1.0' + #13 +
        '2017' + #13 +
        #3 + 'Centered' + #13 +
        #2 + 'Right')));
      R.Assign(16, 8, 26, 10);
      Insert(New(PButton, Init(R, '~O~K', cmOK, bfDefault)));
    end;
    if ValidView(Dlg) <> nil then begin
      Desktop^.ExecView(Dlg);           // Call modally, function result is not evaluated.
      Dispose(Dlg, Done);               // Release dialog.
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
