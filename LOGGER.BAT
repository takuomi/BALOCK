@ECHO OFF

REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

REM Copyright 2007 Takuomi Kagaya
REM 
REM Licensed under the Apache License, Version 2.0 (the "License");
REM you may not use this file except in compliance with the License.
REM You may obtain a copy of the License at
REM 
REM     http://www.apache.org/licenses/LICENSE-2.0
REM 
REM Unless required by applicable law or agreed to in writing, software
REM distributed under the License is distributed on an "AS IS" BASIS,
REM WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
REM See the License for the specific language governing permissions and
REM limitations under the License.

REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

REM BALOCK - Batch Logger Component Framework
REM   Logger Component
REM
REM Usage:
REM   CALL %BALOCK_LOGGER% INIT level filename
REM   CALL %BALOCK_LOGGER% LEVEL TRACE|DEBUG|INFO|WARN|ERROR|FATAL|level
REM   CALL %BALOCK_LOGGER% FILENAME filename
REM   CALL %BALOCK_LOGGER% INITFILE
REM   CALL %BALOCK_LOGGER% TRACE|DEBUG|INFO|WARN|ERROR|FATAL [text]
REM
REM       level  1|2|3|4|5|6
REM           1  TRACE
REM           2  DEBUG
REM           3  INFO
REM           4  WARN
REM           5  ERROR
REM           6  FATAL
REM    filename  Log file name
REM        text  Log text

REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

SETLOCAL
SET BALOCK_PUBLIC_LABEL=
SET BALOCK_PUBLIC_LABELS=LEVEL,INITFILE,FILENAME,INIT,TRACE,DEBUG,INFO,WARN,ERROR,FATAL,ECHO
FOR %%I IN (%BALOCK_PUBLIC_LABELS%) DO (
    IF "%~1"=="%%I" (
        SET BALOCK_PUBLIC_LABEL=TRUE
    )
)
IF NOT DEFINED BALOCK_PUBLIC_LABEL (
    ENDLOCAL
    CALL :EXCEPTION - IllegalArgumentException: %*
    EXIT /B
) ELSE (
    ENDLOCAL
    CALL :%* & EXIT /B
)

REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

REM EXCEPTION
:EXCEPTION
ECHO BALOCK LOGGER:%*
PAUSE
GOTO :EOF

REM LOG [private]
:LOG
IF NOT DEFINED BALOCK_LOGGER_LOGLEVEL (
    CALL :EXCEPTION "%~1" IllegalArgumentException: "%~1"
    REM CALL :EXCEPTION "%~1" LOGLEVEL NOT DEFINED
    GOTO :EOF
)
IF "%~1"=="TRACE" (
    IF %BALOCK_LOGGER_LOGLEVEL% GTR 1 GOTO :EOF
)
IF "%~1"=="DEBUG" (
    IF %BALOCK_LOGGER_LOGLEVEL% GTR 2 GOTO :EOF
)
IF "%~1"=="INFO" (
    IF %BALOCK_LOGGER_LOGLEVEL% GTR 3 GOTO :EOF
)
IF "%~1"=="WARN" (
    IF %BALOCK_LOGGER_LOGLEVEL% GTR 4 GOTO :EOF
)
IF "%~1"=="ERROR" (
    IF %BALOCK_LOGGER_LOGLEVEL% GTR 5 GOTO :EOF
)
IF "%~1"=="FATAL" (
    IF %BALOCK_LOGGER_LOGLEVEL% GTR 6 GOTO :EOF
)
IF NOT "%BALOCK_LOGGER_ECHO%"=="OFF" (
    ECHO %DATE% %TIME% %*
)
IF NOT DEFINED BALOCK_LOGGER_LOGFILE (
    GOTO :EOF
)
ECHO %DATE% %TIME% %* 1>>%BALOCK_LOGGER_LOGFILE% 2>&1
GOTO :EOF

REM TRACE
:TRACE
CALL :LOG TRACE %*
GOTO :EOF

REM DEBUG
:DEBUG
CALL :LOG DEBUG %*
GOTO :EOF

REM INFO
:INFO
CALL :LOG INFO  %*
GOTO :EOF

REM WARN
:WARN
CALL :LOG WARN  %*
GOTO :EOF

REM ERROR
:ERROR
CALL :LOG ERROR %*
GOTO :EOF

REM FATAL
:FATAL
CALL :LOG FATAL %*
GOTO :EOF

REM ECHO
:ECHO
SET BALOCK_LOGGER_ECHO=%*
GOTO :EOF

REM LEVEL
:LEVEL
IF DEFINED BALOCK_LOGGER_LOGLEVEL (
    CALL :DEBUG [LOGGER:LEVEL] LEVEL: "%~1"
)
SETLOCAL & SET /A _BALOCK_LOGGER_LOGLEVEL="%~1"
IF %_BALOCK_LOGGER_LOGLEVEL% LSS 1 (
    SET _BALOCK_LOGGER_LOGLEVEL=
) ELSE (
    IF %_BALOCK_LOGGER_LOGLEVEL% GTR 6 (
        SET _BALOCK_LOGGER_LOGLEVEL=
    )
)
IF "%~1"=="TRACE" (
    SET _BALOCK_LOGGER_LOGLEVEL=1
)
IF "%~1"=="DEBUG" (
    SET _BALOCK_LOGGER_LOGLEVEL=2
)
IF "%~1"=="INFO" (
    SET _BALOCK_LOGGER_LOGLEVEL=3
)
IF "%~1"=="WARN" (
    SET _BALOCK_LOGGER_LOGLEVEL=4
)
IF "%~1"=="ERROR" (
    SET _BALOCK_LOGGER_LOGLEVEL=5
)
IF "%~1"=="FATAL" (
    SET _BALOCK_LOGGER_LOGLEVEL=6
)
IF DEFINED _BALOCK_LOGGER_LOGLEVEL (
    ENDLOCAL & SET BALOCK_LOGGER_LOGLEVEL=%_BALOCK_LOGGER_LOGLEVEL%
) ELSE (
    ENDLOCAL & CALL :EXCEPTION LEVEL IllegalArgumentException: "%~1"
)
GOTO :EOF

REM FILENAME
:FILENAME
IF DEFINED BALOCK_LOGGER_LOGLEVEL (
    CALL :DEBUG [LOGGER:FILENAME] FILENAME: "%~1"
)
IF NOT "%~1"=="" (
    SET BALOCK_LOGGER_LOGFILE="%~1"
) ELSE (
    CALL :EXCEPTION FILENAME IllegalArgumentException: "%~1"
)
GOTO :EOF

REM INITFILE
:INITFILE
IF NOT DEFINED BALOCK_LOGGER_LOGFILE (
    CALL :EXCEPTION INITFILE IllegalArgumentException: %BALOCK_LOGGER_LOGFILE%
    GOTO :EOF
)
TYPE nul 1>%BALOCK_LOGGER_LOGFILE%
GOTO :EOF

REM INIT
:INIT
CALL :LEVEL "%~1"
CALL :FILENAME "%~2"
CALL :INITFILE
GOTO :EOF
