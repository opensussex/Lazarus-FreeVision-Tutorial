# 06 - Lists and ListBoxes
## 15 - ListBox Sorted

![image.png](image.png)

Die ListBox kann auch sortiert sein.

---

---
**Unit with the new dialog.**
<br>
The dialog with the ListBox

```pascal
unit MyDialog;

```

Declare the Destructor, which releases the memory of the list.

```pascal
type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    ListBox: PListBox;
    StringCollection: PStringCollection;

    constructor Init;
    destructor Done; virtual;  // Because of memory leak in TList
    procedure HandleEvent(var Event: TEvent); virtual;
  end;

```

Generate components for the dialog.

```pascal
const
  cmTag = 1000;  // Local event constant

constructor TMyDialog.Init;
var
  R: TRect;
  ScrollBar: PScrollBar;
  i: Integer;
const
  Days: array [0..6] of shortstring = (
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

begin
  R.Assign(10, 5, 64, 17);
  inherited Init(R, 'ListBox Demo');

  // StringCollection
  StringCollection := new(PStringCollection, Init(5, 5));
  for i := 0 to Length(Days) - 1 do begin
    StringCollection^.Insert(NewStr(Days[i]));
  end;

  // ScrollBar for ListBox
  R.Assign(31, 2, 32, 7);
  ScrollBar := new(PScrollBar, Init(R));
  Insert(ScrollBar);

  // ListBox
  R.A.X := 5;
  Dec(R.B.X, 1);
  ListBox := new(PListBox, Init(R, 1, ScrollBar));
  ListBox^.NewList(StringCollection);
  Insert(ListBox);

  // Tag button
  R.Assign(5, 9, 18, 11);
  Insert(new(PButton, Init(R, '~T~ag', cmTag, bfNormal)));

  // Cancel button
  R.Move(15, 0);
  Insert(new(PButton, Init(R, '~C~ancel', cmCancel, bfNormal)));

  // Ok button
  R.Move(15, 0);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;

```

Manually release the memory of the list.

```pascal
destructor TMyDialog.Done;
begin
  Dispose(ListBox^.List, Done); // Release the list
  inherited Done;
end;

```

The event handle
When you click on, the focused entry of the ListBox is displayed.

```pascal
procedure TMyDialog.HandleEvent(var Event: TEvent);
begin
  case Event.What of
    evCommand: begin
      case Event.Command of
        cmOK: begin
          // do something
        end;
        cmTag: begin
          // Read entry with focus
          // And output
          MessageBox('Weekday: ' + PString(ListBox^.GetFocusedItem)^ + ' selected', nil, mfOKButton);
          // End event.
          ClearEvent(Event);
        end;
      end;
    end;
  end;
  inherited HandleEvent(Event);
end;

```


