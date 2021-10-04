# Windows Specific Implementations

## Setting the foreground window

In the `instanceStarted()` example in the `README` we demonstrated how an
application can bring it's primary instance window whenever a second copy
of the application is started.

On Windows the ability to bring the application windows to the foreground is
restricted, see [`AllowSetForegroundWindow()`][AllowSetForegroundWindow] for more
details.

The background process (the primary instance) can bring its windows to the
foreground if it is allowed by the current foreground process (the secondary
instance). To bypass this `SingleInstance` must be initialized with the
`allowSecondary` parameter set to `true` and the `options` parameter must
include `Mode::SecondaryNotification`, See `SingleInstance::Mode` for more
details.

Here is an example:

```cpp
if( inst.isSecondary() ) {
    // This API requires LIBS += User32.lib to be added to the project
    AllowSetForegroundWindow( DWORD( app.primaryPid() ) );
}

if( inst.isPrimary() ) {
    QObject::connect(
        &inst,
        &SingleInstance::instanceStarted,
        this,
        &App::instanceStarted
    );
}
```

```cpp
void App::instanceStarted() {
    QApplication::setActiveWindow( [window/widget to set to the foreground] );
}
```

[AllowSetForegroundWindow]: https://msdn.microsoft.com/en-us/library/windows/desktop/ms632668.aspx
