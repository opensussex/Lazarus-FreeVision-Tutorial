# 04 - Dialogs as Component
## 15 - Different Dialog Colors

![image.png](image.png)

You can assign different color schemes to a window/dialog.
By default, the following is used:

```pascal
Editor window : Blue
Dialog        : Gray
Help window   : Cyan
```


Without doing anything, windows/dialogs always come in the right color.
Modification only makes sense in special cases.

---
**Unit with the new dialog.**

With the 3 upper buttons, you can change the color scheme of the dialog.

```pascal
unit MyDialog;

```

Here 3 event constants have been added.

```pascal
type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    CounterButton: PButton; // Button with counter.
    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;

```

Building the dialog is nothing special.

```pascal
const
  cmBlue = 1006;
  cmCyan = 1007;
  cmGray = 1008;

constructor TMyDialog.Init;
var
  R: TRect;
begin
  R.Assign(0, 0, 42, 11);
  R.Move(23, 3);
  inherited Init(R, 'My Dialog');

  // StaticText
  R.Assign(5, 2, 41, 8);
  Insert(new(PStaticText, Init(R, 'Choose a color')));

  // Color
  R.Assign(7, 5, 15, 7);
  Insert(new(PButton, Init(R, 'blue', cmBlue, bfNormal)));
  R.Assign(17, 5, 25, 7);
  Insert(new(PButton, Init(R, 'cyan', cmCyan, bfNormal)));
  R.Assign(27, 5, 35, 7);
  Insert(new(PButton, Init(R, 'gray', cmGray, bfNormal)));

  // OK button
  R.Assign(7, 8, 17, 10);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;

```

Here the color schemes are changed using **Palette := dpxxx**.
Here too it is important to call **Draw**, this time not for a component but for the entire dialog.

```pascal
procedure TMyDialog.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);    // Call ancestor.

  case Event.What of
    evCommand: begin
      case Event.Command of
        cmBlue: begin
          Palette := dpBlueDialog; // Assign palette, here blue.
          Draw;                    // Redraw dialog.
          ClearEvent(Event);       // The event is complete.
        end;
        cmCyan: begin
          Palette := dpCyanDialog;
          Draw;
          ClearEvent(Event);
        end;
        cmGray: begin
          Palette := dpGrayDialog;
          Draw;
          ClearEvent(Event);
        end;
      end;
    end;
  end;

end;

```


