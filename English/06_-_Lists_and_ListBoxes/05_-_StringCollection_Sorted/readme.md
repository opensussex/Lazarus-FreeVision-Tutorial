# 06 - Lists and ListBoxes
## 05 - StringCollection Sorted

![image.png](image.png)

Eine sortierte String-Liste
für eine sortierte Liste muss man **PStringCollection** oder **PStrCollection** verwenden.

---

---
**Unit with the new dialog.**
<br>
Der Dialog mit der **StringCollection**
Declaration of the dialog, nothing special.

```pascal
type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
    constructor Init;
  end;

```

Es wird eine **StringCollection** gebaut und
as a demonstration, its content is written to a StaticText.
Man sieht gut, das die Wochentage alphapetisch sortiert sind.

```pascal
constructor TMyDialog.Init;
var
  R: TRect;
  s: shortstring;
  i: Integer;
  StringCollection: PStringCollection;

const
  Days: array [0..6] of shortstring = (
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

begin
  R.Assign(10, 5, 50, 19);
  inherited Init(R, 'StringCollection Demo');

  // StringCollection
  StringCollection := new(PStringCollection, Init(5, 5));
  for i := 0 to Length(Days) - 1 do begin
    StringCollection^.Insert(NewStr(Days[i]));
  end;
  s := '';

  for i := 0 to StringCollection^.Count - 1 do begin
    s := s + PString(StringCollection^.At(i))^ + #13;
  end;

  Dispose(StringCollection, Done); // Die Liste freigeben

  R.Assign(5, 2, 36, 12);
  Insert(new(PStaticText, Init(R, s)));

  // Ok-Button
  R.Assign(5, 11, 18, 13);
  Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));
end;

```


