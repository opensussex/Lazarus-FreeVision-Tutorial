# 06 - Lists and ListBoxes
## 00 - StringCollection Unsorted

![image.png](image.png)

If the string list should remain unsorted, use **PUnSortedStrCollection**.
Only PCollection is not enough**, because this crashes at Dispose.

---

---
**Unit with the new dialog.**
<br>
The dialog with the UnSortedStrCollection.
Declaration of the dialog, nothing special.

```pascal
type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    constructor Init;
  end;

```

An UnSortedStrCollection is built und
as a demonstration, its content is written to a StaticText.

```pascal
constructor TMyDialog.Init;
var
  R: TRect;
  s: shortstring;
  i: Integer;
  StringCollection: PUnSortedStrCollection;

const
  Days: array [0..6] of shortstring = (
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

begin
  R.Assign(10, 5, 50, 19);
  inherited Init(R, 'StringCollection Demo');

  // StringCollection
  StringCollection := new(PUnSortedStrCollection, Init(5, 5));
  for i := 0 to Length(Days) - 1 do begin
    StringCollection^.Insert(NewStr(Days[i]));
  end;
  s := '';

  for i := 0 to StringCollection^.Count - 1 do begin
    s := s + PString(StringCollection^.At(i))^ + #13;
  end;

  Dispose(StringCollection, Done); // Release the list

  R.Assign(5, 2, 36, 12);
  Insert(new(PStaticText, Init(R, s)));

  // Ok-Button
  R.Assign(5, 11, 18, 13);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;

```


