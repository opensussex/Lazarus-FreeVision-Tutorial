# 08 - EventHandle Outside Components
## 00 - Mouse Event

![image.png](image.png)

You can catch an event handle in the dialog/window, when you move/click the mouse.
There is nothing special in the main program for this, this all runs locally in the dialog/window.

---
In the main program, only the dialog is built, called and closed.

```pascal
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    MouseDialog: PMyMouse;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmMouseAktion: begin
          MouseDialog := New(PMyMouse, Init);
          if ValidView(MouseDialog) <> nil then begin // Check if enough memory.
            Desktop^.ExecView(MouseDialog);           // Execute mouse action dialog.
            Dispose(MouseDialog, Done);               // Release dialog and memory.
          end;
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;
```


---
**Unit with the mouse action dialog.**
<br>

```pascal
unit MyDialog;

```

In the object the.*are declared globally, because these are modified later during mouse actions.

```pascal
type
  PMyMouse = ^TMyMouse;
  TMyMouse = object(TDialog)
    EditMB,
    EditX, EditY: PInputLine;

    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;

```

A dialog with EditLine, Label and Button is built.
The only special thing there, the.*status is set to own inputs are undesirable there.

```pascal
constructor TMyMouse.Init;
var
  R: TRect;
begin
  R.Assign(0, 0, 42, 13);
  R.Move(23, 3);
  inherited Init(R, 'Mouse Action');

  // PosX
  R.Assign(25, 2, 30, 3);
  EditX := new(PInputLine, Init(R, 5));
  Insert(EditX);
  EditX^.State := sfDisabled or EditX^.State;    // ReadOnly
  R.Assign(5, 2, 20, 3);
  Insert(New(PLabel, Init(R, 'Mouse Position ~X~:', EditX)));

  // PosY
  R.Assign(25, 4, 30, 5);
  EditY := new(PInputLine, Init(R, 5));
  EditY^.State := sfDisabled or EditY^.State;    // ReadOnly
  Insert(EditY);
  R.Assign(5, 4, 20, 5);
  Insert(New(PLabel, Init(R, 'Mouse Position ~Y~:', EditY)));

  // Maus-Tasten
  R.Assign(25, 7, 32, 8);
  EditMB := new(PInputLine, Init(R, 7));
  EditMB^.State := sfDisabled or EditMB^.State;  // ReadOnly
  EditMB^.Data^:= 'up';                        // Initially the key is up.
  Insert(EditMB);
  R.Assign(5, 7, 20, 8);
  Insert(New(PLabel, Init(R, '~M~austaste:', EditMB)));

  // Ok-Button
  R.Assign(27, 10, 37, 12);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;

```

In the event handle you can see well, that the mouse actions are caught there.
The mouse data is output to the.

```pascal
procedure TMyMouse.HandleEvent(var Event: TEvent);
var
  Mouse : TPoint;
begin
  inherited HandleEvent(Event);

  case Event.What of
    evMouseDown: begin                 // Key was pressed.
      EditMB^.Data^:= 'down';
      EditMB^.Draw;
    end;
    evMouseUp: begin                   // Key was released.
      EditMB^.Data^:= 'up';
      EditMB^.Draw;
    end;
    evMouseMove: begin                 // Mouse was moved.
      MakeLocal (Event.Where, Mouse);  // Determine mouse position.
      EditX^.Data^:= IntToStr(Mouse.X);
      EditX^.Draw;
      EditY^.Data^:= IntToStr(Mouse.Y);
      EditY^.Draw;
    end;
  end;

end;

```


