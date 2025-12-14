//image image.png
(*
This example shows, how to send an event to another component.
In this case, an event is sent to the dialogs. A counter is then incremented in the dialogs.
*)
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

(*
Events for button clicks.
*)
//code+
const
  cmDia1   = 1001;
  cmDia2   = 1002;
  cmDiaAll = 1003;
//code-

type

  { TMyApp }

  TMyApp = object(TApplication)
    Dialog1, Dialog2: PMyDialog;
    constructor Init;

    procedure InitStatusLine; virtual;                 // Status line
    procedure InitMenuBar; virtual;                    // Menu
    procedure HandleEvent(var Event: TEvent); virtual; // Event handler
    procedure OutOfMemory; virtual;                    // Wird aufgerufen, wen Speicher überläuft.
  end;

(*
Here the 2 passive output dialogs are created, these are located in the object TMyDialog.
In addition, a dialog is created, that receives 3 buttons, which then send the commands to the other dialogs.
*)
//code+
  constructor TMyApp.Init;
  var
    R: TRect;
    Dia: PDialog;
  begin
    inherited init;

    // First passive dialog
    R.Assign(45, 2, 70, 9);
    Dialog1 := New(PMyDialog, Init(R, 'Dialog 1'));
    Dialog1^.SetState(sfDisabled, True);    // Set dialog to ReadOnly.
    if ValidView(Dialog1) <> nil then begin // Check if enough memory.
      Desktop^.Insert(Dialog1);
    end;

    // Second passive dialog
    R.Assign(45, 12, 70, 19);
    Dialog2 := New(PMyDialog, Init(R, 'Dialog 2'));
    Dialog2^.SetState(sfDisabled, True);
    if ValidView(Dialog2) <> nil then begin
      Desktop^.Insert(Dialog2);
    end;

    // Control dialog
    R.Assign(5, 5, 30, 20);
    Dia := New(PDialog, Init(R, 'Control'));

    with Dia^ do begin
      R.Assign(6, 2, 18, 4);
      Insert(new(PButton, Init(R, 'Dialog ~1~', cmDia1, bfNormal)));

      R.Move(0, 3);
      Insert(new(PButton, Init(R, 'Dialog ~2~', cmDia2, bfNormal)));

      R.Move(0, 3);
      Insert(new(PButton, Init(R, '~A~lle', cmDiaAll, bfNormal)));

      R.Move(0, 4);
      Insert(new(PButton, Init(R, 'E~x~it', cmQuit, bfNormal)));
    end;

    if ValidView(Dia) <> nil then begin
      Desktop^.Insert(Dia);
    end;
  end;
//code-

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;

    StatusLine := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Exit program', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu, nil)), nil)));
  end;

  procedure TMyApp.InitMenuBar;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(
        NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)),
      NewSubMenu('~O~ption', hcNoContext, NewMenu(
        NewItem('Dialog ~1~', '', kbNoKey, cmDia1, hcNoContext,
        NewItem('Dialog ~2~', '', kbNoKey, cmDia2, hcNoContext,
        NewItem('~A~lle', '', kbNoKey, cmDiaAll, hcNoContext, nil)))), nil)))));
  end;

(*
Here the commands are sent to the dialogs with.
If you specify the view of the dialog as the first parameter, only this dialog is addressed.
If you specify.*the commands are sent to all dialogs.
With the 4th parameter, you can also pass a pointer to an identifier,
which can be, for example, a string or a record, etc.
*)
//code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmDia1: begin
          Message(Dialog1, evBroadcast, cmCounterUp, nil); // Command Dialog 1
        end;
        cmDia2: begin
          Message(Dialog2, evBroadcast, cmCounterUp, nil); // Command Dialog 2
        end;
        cmDiaAll: begin
          Message(@Self, evBroadcast, cmCounterUp, nil);   // Command to all dialogs
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
<b>Unit with the new dialog.</b>
<br>
The dialog with the counter output.
*)
//includepascal mydialog.pas head

(*
Declaration of the object for passive dialogs.
*)
//includepascal mydialog.pas type

(*
In the constructor, an output line is created.
*)
//includepascal mydialog.pas init

(*
In the event handler, the command.*is received, sent with.
As proof, the number in the output line is increased by one.
*)
//includepascal mydialog.pas handleevent

end.
