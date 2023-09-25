
chcp 65001

:: @echo off
:: Останавливаем службу агента сервера 1С Предприятия
set logfile="D:\Logs\stopstartlog.txt"
echo %date% %time% "Начало остановки службы агента сервера 1С Предприятия" >>%logfile%
net stop "1C:Enterprise 8.3 Server Agent (x86-64)" >>%logfile%
:: Пауза
echo %date% %time% "Начало паузы" >>%logfile%
timeout /t 10 /nobreak
echo %date% %time% "Конец паузы" >>%logfile%
:: Запускаем службу агента сервера 1С Предприятия
echo %date% %time% "Начало запуска службы агента сервера 1С Предприятия">>%logfile%
net start "1C:Enterprise 8.3 Server Agent (x86-64)" >>%logfile%

timeout /t 30 /nobreak