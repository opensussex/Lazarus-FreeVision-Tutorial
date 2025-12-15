//image image.png
(*
Dialog um Buttons ergänzen.
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Window area (TRect)
  Drivers,  // Hotkey
  Views,    // Event (cmQuit)
  Menus,    // Status line
  Dialogs;  // Dialogs

const
  cmAbout = 1001;     // Show about
  cmPara = 1003;      // Parameter
  cmMenuEnlish = 1005;
  cmMenuGerman = 1006;

type

  { TMyApp }

  TMyApp = object(TApplication)
    constructor Init;
    procedure InitDeskTop; Virtual;
    procedure InitStatusLine; virtual;                 // Status line
    procedure InitMenuBar; virtual;                    // Menu
    procedure HandleEvent(var Event: TEvent); virtual; // Event handler

    procedure MyParameter;
    // New function for a dialog.
  private
    DesktopGer, DesktopEng: PDeskTop;
    menuGer, menuEng: PMenuView;
    StatusGer, StatusEng: PStatusLine;
  end;

  constructor TMyApp.Init;
  var
    R: TRect;              // Rectangle for the status line position.
  begin
    inherited Init;

    // Links
    R.Assign(4, 2, 38, 20);
    DesktopGer := New(PDesktop, Init(R));
    Insert(DesktopGer);

    R.Assign(4, 20, 38, 21);
    StatusGer := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Exit program', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menue', kbF10, cmMenu,
      NewStatusKey('~F1~ Help', kbF1, cmHelp, nil))), nil)));
    Insert(StatusGer);

    R.Assign(4, 1, 38, 2);
    menuGer := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(
        NewItem('~C~lose', 'Alt-F3', kbAltF3, cmClose, hcNoContext,
        NewLine(
        NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)))),
      NewSubMenu('~O~ptionen', hcNoContext, NewMenu(
        NewItem('~P~arameters...', '', kbF2, cmPara, hcNoContext,
        NewLine(
        NewItem('~D~eutsch', 'Alt-D', kbAltD, cmMenuGerman, hcNoContext,
        NewItem('~E~nglisch', 'Alt-E', kbAltE, cmMenuEnlish, hcNoContext, nil))))),
      NewSubMenu('~H~elp', hcNoContext, NewMenu(
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil))))));
    Insert(menuGer);

    MenuBar := menuGer;
    StatusLine := StatusGer;
    Desktop := DesktopGer;

    // Rechts
    R.Assign(44, 2, 78, 20);
    DesktopEng := New(PDesktop, Init(R));
    Insert(DesktopEng);

    R.Assign(44, 20, 78, 21);
    StatusEng := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Exit', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F1~ Help', kbF1, cmHelp, nil))), nil)));
    Insert(StatusEng);

    R.Assign(44, 1, 78, 2);
    menuEng := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(
        NewItem('~C~lose', 'Alt-F3', kbAltF3, cmClose, hcNoContext,
        NewLine(
        NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)))),
      NewSubMenu('~O~ptions', hcNoContext, NewMenu(
        NewItem('~P~arameterss...', '', kbF2, cmPara, hcNoContext,
        NewLine(
        NewItem('German', 'Alt-D', kbAltD, cmMenuGerman, hcNoContext,
        NewItem('English', 'Alt-E', kbAltE, cmMenuEnlish, hcNoContext, nil))))),
      NewSubMenu('~H~elp', hcNoContext, NewMenu(
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil))))));
    Insert(menuEng);

  end;

  procedure TMyApp.InitDeskTop;
  begin
    DeskTop := nil;
  end;

  procedure TMyApp.InitStatusLine;
  begin
    StatusLine := nil;
  end;

  procedure TMyApp.InitMenuBar;
  begin
    MenuBar := nil;
  end;

  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin
          Tile;
        end;
        cmMenuEnlish: begin
          Delete(MenuBar);
          MenuBar := menuEng;
          Insert(MenuBar);

          Delete(StatusLine);
          StatusLine := StatusEng;
          Insert(StatusLine);
        end;
        cmMenuGerman: begin
          Delete(MenuBar);
          MenuBar := menuGer;
          Insert(MenuBar);

          Delete(StatusLine);
          StatusLine := StatusGer;
          Insert(StatusLine);
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
Den Dialog mit Buttons ergänzen.
Mit <b>Insert</b> fügt man die Komponenten hinzug, in diesem Fall sind es die Buttons.
Mit bfDefault legt man den Default-Button fest, dieser wird mit <b>[Enter]</b> aktiviert.
bfNormal ist ein gewöhnlicher Button.
Der Dialog wird nun Modal geöffnet, somit können <b>keine</b> weiteren Dialogs geöffnet werden.
dummy hat den Wert, des Button der gedrückt wurde, dies entspricht dem <b>cmxxx</b> Wert.
Die Höhe der Buttons muss immer <b>2</b> sein, ansonsten gibt es eine fehlerhafte Darstellung.
*)
  //code+
  procedure TMyApp.MyParameter;
  var
    Dia: PDialog;
    R: TRect;
    dummy: word;
  begin
    R.Assign(0, 0, 35, 15);                    // Grösse des Dialogs.
    R.Move(23, 3);                             // Position des Dialogs.
    Dia := New(PDialog, Init(R, 'Parameter')); // Dialog erzeugen.
    with Dia^ do begin

      // Ok-Button
      R.Assign(7, 12, 17, 14);
      Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));

      // Schliessen-Button
      R.Assign(19, 12, 32, 14);
      Insert(new(PButton, Init(R, '~C~ancel', cmCancel, bfNormal)));
    end;
    dummy := Desktop^.ExecView(Dia);   // Dialog Modal öffnen.
    Dispose(Dia, Done);                // Release dialog and memory.
  end;
  //code-

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Initialize
  MyApp.Run;    // Execute
  MyApp.Done;   // Release
end.
