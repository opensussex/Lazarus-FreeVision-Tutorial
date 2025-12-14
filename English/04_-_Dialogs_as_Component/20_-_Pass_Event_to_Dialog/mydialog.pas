//head+
unit MyDialog;
//head-

interface

uses
  App, Objects, Drivers, Views, MsgBox, Dialogs,
  SysUtils; // Für IntToStr und StrToInt.

const
  cmCounterUp = 1010; // Muss gloabal sein

//type+
type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
  var
    CounterInputLine: PInputLine; // Output line for the counter.

    constructor Init(var Bounds: TRect; ATitle: TTitleStr);
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
//type-

implementation

//init+
constructor TMyDialog.Init(var Bounds: TRect; ATitle: TTitleStr);
var
  R: TRect;
begin
  inherited Init(Bounds, ATitle);

  R.Assign(5, 2, 10, 3);
  CounterInputLine := new(PInputLine, Init(R, 20));
  CounterInputLine^.Data^ := '0';
  Insert(CounterInputLine);
end;
//init-

//handleevent+
procedure TMyDialog.HandleEvent(var Event: TEvent);
var
  Counter: integer;
begin
  inherited HandleEvent(Event);

  case Event.What of
    evBroadcast: begin
      case Event.Command of
        cmCounterUp: begin                              // cmCounterUp was sent with Message.
          Counter := StrToInt(CounterInputLine^.Data^); // Read output line.
          Inc(Counter);                                 // Increase counter.
          CounterInputLine^.Data^ := IntToStr(Counter); // Output new number.
          CounterInputLine^.Draw;                       // Update output line.
        end;
      end;
    end;
  end;

end;
//handleevent-

end.
