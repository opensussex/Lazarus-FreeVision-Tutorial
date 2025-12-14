# 04 - Dialogs as Component
## 10 - Modify Components at Runtime

![image.png](image.png)

This example shows how to modify components at runtime.
A button is used for this, where the label increases with each click.

---
**Unit with the new dialog.**

The dialog with the counter button.

```pascal
unit MyDialog;

```

If you want to modify a component at runtime, you must declare it, otherwise you can no longer access it.
Directly with **Insert(New(...** no longer works.

```pascal
type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    CounterButton: PButton; // Button with counter.
    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;

```

In the constructor, you can see that you take the detour via **CounterButton**.
**CounterButton** is needed for modification.

```pascal
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
  Insert(new(PStaticText, Init(R, 'Right button counts up counter')));

  // Button whose title is changed.
  R.Assign(19, 8, 32, 10);
  CounterButton := new(PButton, Init(R, '    ', cmCounter, bfNormal));
  CounterButton^.Title^ := '1';

  Insert(CounterButton);

  // OK button
  R.Assign(7, 8, 17, 10);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;

```

In the event handler, the number in the button is increased when pressed.
You can see why you need the **CounterButton**; without it, you would have no access to **Title**.
Important: when you change a component, you must redraw the component with **Draw**, otherwise you won't see the changed value.

```pascal
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

```


