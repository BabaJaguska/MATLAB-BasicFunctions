
SETLOCAL ENABLEDELAYEDEXPANSION
Set "Pattern= "
Set "Replace=_"

For %%a in (*.mat) Do (
    Set "File=%%~a"
    Ren "%%a" "!File:%Pattern%=%Replace%!"
)

Pause&Exit