
chcp 65001

@echo Дата, время: %date% %time% > "%~dp0logRedmine.txt"
"C:\Program Files (x86)\OneScript\bin\oscript.exe" "%~dp0СозданиеЗадачRedmine.os" ^
--kaitenURL="https://example.kaiten.ru" ^
--redmineURL="https://rm.redmine.ru" ^
--kaitenToken="dec9657c-1eb6-4f1f-bb69-053dd3d212fc" ^
--redmineAPIKEY="ccab5eb94dc455b4c16702769cf092346ac35a4a" ^
--config="%~dp0redmine_config.json" ^
--redmineUsers="%~dp0redmine_users.json" ^
--idCard="12345678" >> "%~dp0logRedmine.txt"