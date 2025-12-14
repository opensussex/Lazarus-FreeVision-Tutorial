# 01 - Introduction
## 05 - First Desktop

![image.png](image.png)

Minimal Free-Vision application

---
Program name, as is customary in Pascal.

```pascal
program Project1;
```

For Free-Vision to be possible at all, the unit **App** must be included.

```pascal
uses
  App;   // TApplication
```

Declaration for the Free-Vision application.

```pascal
var
  MyApp: TApplication;
```

The following three steps are always necessary for execution.

```pascal
begin
  MyApp.Init;   // Initialize
  MyApp.Run;    // Execute
  MyApp.Done;   // Release
end.
```


