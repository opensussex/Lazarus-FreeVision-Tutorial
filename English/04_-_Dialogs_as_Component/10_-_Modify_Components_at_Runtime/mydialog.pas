//head+
unit MyDialog;
//head-

interface

uses
  App, Objects, Drivers, Views, MsgBox, Dialogs,
  SysUtils; // Für IntToStr und StrToInt.

//type+
type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    CounterButton: PButton; // Button with counter.
    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
//type-

implementation

//init+
const
  cmCounter = 1003;       // Used locally for the counter button.

constructor TMyDialog.Init;
var
  R: TRect;
begin
  R.Assign(0, 0, 42, 11);
  R.Move(23, 3);
  inherited Init(R, 'My Dialog');

  // StaticText
  R.Assign(5, 2, 41, 8);
  Insert(new(PStaticText, Init(R, 'Rechter Button z' + #132 + 'hlt Counter hoch')));

  // Button whose title is changed.
  R.Assign(19, 8, 32, 10);
  CounterButton := new(PButton, Init(R, '    ', cmCounter, bfNormal));
  CounterButton^.Title^ := '1';

  Insert(CounterButton);

  // Ok-Button
  R.Assign(7, 8, 17, 10);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;
//init-

//handleevent+
procedure TMyDialog.HandleEvent(var Event: TEvent);
var
  Counter: integer;
begin
  inherited HandleEvent(Event);

  case Event.What of
    evCommand: begin
      case Event.Command of
        cmCounter: begin
          Counter := StrToInt(CounterButton^.Title^); // Read button title.
          Inc(Counter);                               // Increase counter.
          if Counter > 9999 then begin                // Check for overflow, because only 4 characters available.
            Counter := 9999;
          end;
          CounterButton^.Title^ := IntToStr(Counter); // Pass new title to button.

          CounterButton^.Draw;                        // Redraw button.
          ClearEvent(Event);                          // End event.
        end;
      end;
    end;
  end;

end;
//handleevent-

end.
