@echo off
echo ============================
echo Setting up Flutter + Java project
echo ============================

REM ----- Flutter setup -----
echo.
echo Cleaning Flutter build...
cd frontend\hfg\flutter_application_1
flutter clean
flutter pub get

REM ----- Backend setup -----
echo.
echo Setting up Java backend...
cd ..\..\backend
REM If using Maven
mvn clean install

echo.
echo ============================
echo Setup complete!
echo ============================
pause