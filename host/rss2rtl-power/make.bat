@del /q build
@del /q dist
setup.py py2exe
@if not ERRORLEVEL 1 GOTO ok
@echo.
@echo *** FAILURE ***
@goto done
:ok
@echo.
@copy /Y rss2rtl-power.py dist
@copy /Y readme.txt dist
@echo *** Your application is built in dist/
:done
@pause
