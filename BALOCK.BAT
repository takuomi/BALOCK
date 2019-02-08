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
REM   BALOCK Loader
REM
REM Usage:
REM   CALL %BALOCK_HOME%\BALOCK.BAT

REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

IF NOT "%CMDEXTVERSION%"=="2" ECHO CMDEXTVERSION MISMATCH
IF NOT "%CMDEXTVERSION%"=="2" EXIT /B 1

GOTO :MAIN

REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

:NOT_EXIST
    ECHO BALOCK: NOT EXIST OF %*
    PAUSE
GOTO :EOF

REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

:MAIN

IF NOT DEFINED BALOCK_HOME SET BALOCK_HOME=.

REM BALOCK_LOGGER
IF EXIST %BALOCK_HOME%\LOGGER.BAT (
    SET BALOCK_LOGGER=%BALOCK_HOME%\LOGGER.BAT
) ELSE (
    CALL :NOT_EXIST %BALOCK_HOME%\LOGGER.BAT
)

REM BALOCK_EXECUTOR
IF EXIST %BALOCK_HOME%\EXECUTOR.BAT (
    SET BALOCK_EXECUTOR=%BALOCK_HOME%\EXECUTOR.BAT
) ELSE (
    CALL :NOT_EXIST %BALOCK_HOME%\EXECUTOR.BAT
)
