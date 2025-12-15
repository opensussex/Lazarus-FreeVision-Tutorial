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
    procedure InitStatusLine; virtual;                 // Status line
    procedure InitMenuBar; virtual;                    // Menu
    procedure HandleEvent(var Event: TEvent); virtual; // Event handler

    procedure MyParameter;
  private
    menuGer, menuEng: PMenuBox;
    StatusGer, StatusEng: PStatusLine;
  end;

  constructor TMyApp.Init;
  var
    R: TRect;              // Rectangle for the status line position.
  begin
    inherited Init;
    R.Assign(3, 3, 30, 20);

    menuGer := New(PMenuBox, Init(R, NewMenu(
      NewItem('~W~indows', 'Alt-W', kbAltW, cmAbout, hcNoContext,
      NewLine(
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
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil)))))),nil));

    menuEng := New(PMenuBox, Init(R, NewMenu(
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
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil)))),nil));

    Insert(menuGer);
    MenuBar := menuGer;
    Message(@Self, evCommand, cmMenu, nil);
  end;

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;                       // Rectangle for the menu line position.
  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;

    StatusGer := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Exit program', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menue', kbF10, cmMenu,
      NewStatusKey('~F1~ Help', kbF1, cmHelp, nil))), nil)));

    StatusEng := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Exit', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F1~ Help', kbF1, cmHelp, nil))), nil)));

    StatusLine := StatusGer;
  end;

  procedure TMyApp.InitMenuBar;
  begin
    MenuBar := nil;
  end;

  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    R: TRect;              // Rectangle for the status line position.

  begin
    GetExtent(R);

    R.A.Y := R.B.Y - 1;
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin
        end;
        cmMenuEnlish: begin

          // Menu tauschen
          Delete(MenuBar);          // Altes Menu entfernen
          MenuBar := menuEng;       // Neues Menu zuordnen
          Insert(MenuBar);          // Neues Menu einfügen

          // Status line tauschen
          Delete(StatusLine);       // Alte Status line entfernen
          StatusLine := StatusEng;  // Neue Status line zuordnen
          Insert(StatusLine);       // Neue Status line einfügen
        end;

        // Menu auf deutsch
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
      Message(@Self, evCommand, cmMenu, nil);
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
