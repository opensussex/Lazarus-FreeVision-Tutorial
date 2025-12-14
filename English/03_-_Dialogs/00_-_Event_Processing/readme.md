# 03 - Dialogs
## 00 - Event Processing

![image.png](image.png)

Processing events from the status line and menu.

---
Commands to be processed.

```pascal
const
  cmAbout = 1001;     // Show about
  cmList = 1002;      // File list
```

The event handler is also a descendant.

```pascal
type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Status line
    procedure InitMenuBar; virtual;                    // Menu
    procedure HandleEvent(var Event: TEvent); virtual; // Event handler
  end;
```

Processing custom cmxxx commands.

```pascal
  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin    // Do something with cmAbout.
        end;
        cmList: begin     // Do something with cmList.
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;
```


