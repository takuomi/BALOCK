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

CALL :SETENV
FOR %%I IN (%BALOCK_PUBLIC_METHOD%) DO IF "%1"=="%%I" CALL :%* & EXIT /B
CALL :EXCEPTION - IllegalArgumentException: %*
EXIT /B

REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

REM SETENV
:SETENV
SET BALOCK_CLASS_NAME=LOGGER
SET BALOCK_PUBLIC_METHOD=LEVEL,INITFILE,FILENAME,INIT,TRACE,DEBUG,INFO,WARN,ERROR,FATAL,ECHO
GOTO :EOF

REM EXCEPTION
:EXCEPTION
ECHO BALOCK %BALOCK_CLASS_NAME%:%*
PAUSE
GOTO :EOF

REM LEVEL
:LEVEL
SET BALOCK_LOGGER_LOGLEVEL=
IF NOT "%1"=="" (
    IF %1 LEQ 6 (
        IF %1 GEQ 1 (
            SET BALOCK_LOGGER_LOGLEVEL=%1
        )
    ) ELSE (
        IF "%1"=="TRACE" (
            SET BALOCK_LOGGER_LOGLEVEL=1
        )
        IF "%1"=="DEBUG" (
            SET BALOCK_LOGGER_LOGLEVEL=2
        )
        IF "%1"=="INFO" (
            SET BALOCK_LOGGER_LOGLEVEL=3
        )
        IF "%1"=="WARN" (
            SET BALOCK_LOGGER_LOGLEVEL=4
        )
        IF "%1"=="ERROR" (
            SET BALOCK_LOGGER_LOGLEVEL=5
        )
        IF "%1"=="FATAL" (
            SET BALOCK_LOGGER_LOGLEVEL=6
        )
    )
) ELSE (
    CALL :EXCEPTION LEVEL IllegalArgumentException: %1
)
IF NOT DEFINED BALOCK_LOGGER_LOGLEVEL (
    CALL :EXCEPTION LEVEL IllegalArgumentException: %1
)
GOTO :EOF

REM INITFILE
:INITFILE
IF NOT "%BALOCK_LOGGER_LOGFILE%"=="" (
    TYPE nul 1>"%BALOCK_LOGGER_LOGFILE%"
) ELSE (
    CALL :EXCEPTION INITFILE IllegalArgumentException: %BALOCK_LOGGER_LOGFILE%
)
GOTO :EOF

REM FILENAME
:FILENAME
IF NOT %1=="" (
    SET BALOCK_LOGGER_LOGFILE=%1
) ELSE (
    CALL :EXCEPTION FILENAME IllegalArgumentException: %1
)
GOTO :EOF

REM INIT
:INIT
CALL :LEVEL %1
CALL :FILENAME %2
CALL :INITFILE
GOTO :EOF

REM OUT
:OUT
IF NOT "%BALOCK_LOGGER_ECHO%"=="OFF" (
    ECHO %DATE% %TIME% %*
)
IF NOT "%BALOCK_LOGGER_LOGFILE%"=="" (
    ECHO %DATE% %TIME% %* 1>>"%BALOCK_LOGGER_LOGFILE%" 2>&1
)
GOTO :EOF

REM TRACE
:TRACE
IF NOT DEFINED BALOCK_LOGGER_LOGLEVEL (
    CALL :EXCEPTION TRACE IllegalArgumentException: %1
) ELSE (
    IF %BALOCK_LOGGER_LOGLEVEL% LEQ 1 CALL :OUT TRACE %*
)
GOTO :EOF

REM DEBUG
:DEBUG
IF NOT DEFINED BALOCK_LOGGER_LOGLEVEL (
    CALL :EXCEPTION DEBUG IllegalArgumentException: %1
) ELSE (
    IF %BALOCK_LOGGER_LOGLEVEL% LEQ 2 CALL :OUT DEBUG %*
)
GOTO :EOF

REM INFO
:INFO
IF NOT DEFINED BALOCK_LOGGER_LOGLEVEL (
    CALL :EXCEPTION INFO IllegalArgumentException: %1
) ELSE (
    IF %BALOCK_LOGGER_LOGLEVEL% LEQ 3 CALL :OUT INFO  %*
)
GOTO :EOF

REM WARN
:WARN
IF NOT DEFINED BALOCK_LOGGER_LOGLEVEL (
    CALL :EXCEPTION WARN IllegalArgumentException: %1
) ELSE (
    IF %BALOCK_LOGGER_LOGLEVEL% LEQ 4 CALL :OUT WARN  %*
)
GOTO :EOF

REM ERROR
:ERROR
IF NOT DEFINED BALOCK_LOGGER_LOGLEVEL (
    CALL :EXCEPTION ERROR IllegalArgumentException: %1
) ELSE (
    IF %BALOCK_LOGGER_LOGLEVEL% LEQ 5 CALL :OUT ERROR %*)

GOTO :EOF

REM FATAL
:FATAL
IF NOT DEFINED BALOCK_LOGGER_LOGLEVEL (
    CALL :EXCEPTION FATAL IllegalArgumentException: %1
) ELSE (
    IF %BALOCK_LOGGER_LOGLEVEL% LEQ 6 CALL :OUT FATAL %*
)
GOTO :EOF

REM ECHO
:ECHO
SET BALOCK_LOGGER_ECHO=%*
GOTO :EOF
