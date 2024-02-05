#Использовать 1connector
#Использовать json
#Использовать cmdline

Перем Redmine_URL; // URL redmine
Перем Redmine_APIKEY; // Redmine API key
Перем Kaiten_URL; // URL задачи kaiten
Перем Redmine_ProjectId; // ID проекта redmine

Функция Инициализировать(АргументыКоманднойСтроки) Экспорт
	
	Парсер = Новый ПарсерАргументовКоманднойСтроки();
	
	Парсер.ДобавитьИменованныйПараметр("--config"		, "Путь к файлу настроек");
	Парсер.ДобавитьИменованныйПараметр("--redmineurl"	, "URL redmine");
	Парсер.ДобавитьИменованныйПараметр("--apikey"		, "Redmine API key");
	Парсер.ДобавитьИменованныйПараметр("--kaitenurl"	, "URL задачи kaiten");
	Парсер.ДобавитьИменованныйПараметр("--rmprojectid"	, "ID проекта в redmine");

	Параметры = Парсер.Разобрать(АргументыКоманднойСтроки);
	Если Параметры.Получить("--config") = Неопределено Тогда
		Параметры.Вставить("--config", "redmine_config.json");
	КонецЕсли;
	
	Настройки			= ПолучитьНастройки(Параметры);
	Redmine_URL			= Настройки.Получить("Redmine_URL");
	Redmine_APIKEY		= Настройки.Получить("Redmine_APIKEY");
	Kaiten_URL			= Настройки.Получить("Kaiten_URL");
	Redmine_ProjectId	= Настройки.Получить("Redmine_ProjectId");

	Если Redmine_ProjectId = Неопределено Тогда
		Redmine_ProjectId = ПолучитьИДПроектаRedmine();
		Если Redmine_ProjectId = Неопределено Тогда
			ВызватьИсключение "Не определен ID проекта АСФЗД в redmine";
		КонецЕсли;
		Настройки.Вставить("Redmine_ProjectId", Redmine_ProjectId);
	КонецЕсли;

	Возврат Настройки;

КонецФункции

Функция ПолучитьИДПроектаRedmine(name = "АС ФЗД (поддержка и развитие)")
	
	id = Неопределено;

	RM_Projects_URL = Redmine_URL + "projects.json";
	Ответ = ВыполнитьЗапросRedmine(RM_Projects_URL, "GET");
	Проекты = Ответ.Получить("projects");

	Если Проекты = Неопределено Тогда
		Возврат id;
	КонецЕсли;

	Для Каждого Проект Из Проекты Цикл
		currentName = Проект.Получить("name");
		Если currentName = name Тогда
			id = Проект.Получить("id");
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Возврат id;

КонецФункции

Функция ПолучитьНастройки(Параметры)

	Настройки = Новый Структура();
		
	Если Параметры["--config"] = Неопределено Тогда
		// Значения по умолчанию необходимо задать
		Настройки.Вставить("Redmine_URL"		, Параметры["--redmineurl"]);
		Настройки.Вставить("Redmine_APIKEY"		, Параметры["--apikey"]);
		Настройки.Вставить("Kaiten_URL"			, Параметры["--kaitenurl"]);
	Иначе
		Настройки = ПолучитьНастройкиИзФайла(Параметры["--config"]);
	КонецЕсли;

	Для Каждого Строка Из Параметры Цикл
		Настройки.Вставить(Строка.Ключ, Строка.Значение);
	КонецЦикла;

	Возврат Настройки;

КонецФункции

Функция ВыполнитьЗапросRedmine(URL, ТипЗапроса, ПараметрыЗапроса = Неопределено)
	
	Если ПараметрыЗапроса = Неопределено Тогда
		ПараметрыЗапроса = Новый Структура;	
	КонецЕсли;
	ПараметрыЗапроса.Вставить("key", 	Redmine_APIKEY);
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type"	, "application/json");
	Заголовки.Вставить("Accept"			, "application/json");
		
	Попытка
		Если ТипЗапроса = "GET" Тогда
			Ответ = КоннекторHTTP.Get(URL, ПараметрыЗапроса, Новый Структура("Заголовки", Заголовки)).Json();
		ИначеЕсли ТипЗапроса = "POST" Тогда	
			Ответ = КоннекторHTTP.Post(URL, , ПараметрыЗапроса , Новый Структура("Заголовки", Заголовки)).Json();
		ИначеЕсли ТипЗапроса = "PATCH" Тогда	
			Ответ = КоннекторHTTP.Patch(URL, , Новый Структура("Заголовки, Json", Заголовки, ПараметрыЗапроса)).Json();	
		Иначе 
			ВызватьИсключение ("Некорректный тип Rest запроса");
		КонецЕсли;
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат Неопределено;
	КонецПопытки;
	
	Возврат Ответ;

КонецФункции

Функция ПолучитьНастройкиИзФайла(Знач ПутьКФайлуJSON)

	ЧтениеТекста = Новый ЧтениеТекста(ПутьКФайлуJSON, "UTF-8");
	СтрокаJSON = ЧтениеТекста.Прочитать();

	ПарсерJSON = Новый ПарсерJSON();
	Параметры = ПарсерJSON.ПрочитатьJSON(СтрокаJSON);

	Возврат Параметры;

КонецФункции

// Creating an issue
// POST /issues.[format]
// Parameters:

// issue - A hash of the issue attributes:
	// project_id
	// tracker_id
	// status_id
	// priority_id
	// subject
	// description
	// category_id
	// fixed_version_id - ID of the Target Versions (previously called 'Fixed Version' and still referred to as such in the API)
	// assigned_to_id - ID of the user to assign the issue to (currently no mechanism to assign by name)
	// parent_issue_id - ID of the parent issue
	// custom_fields - See Custom fields
	// watcher_user_ids - Array of user ids to add as watchers (since 2.3.0)
	// is_private - Use true or false to indicate whether the issue is private or not
	// estimated_hours - Number of hours estimated for issue

Функция СоздатьЗадачуRedmine(ПараметрыСоздания)
	
	id = Неопределено;

	// Проверка параметров

	ПараметрыЗапроса = Новый Структура("issue", Новый Структура());
	ПараметрыЗапроса.issue.Вставить();
	ПараметрыЗапроса.issue.Вставить();
	ПараметрыЗапроса.issue.Вставить();
	ПараметрыЗапроса.issue.Вставить();
	ПараметрыЗапроса.issue.Вставить();

	RM_Issues_URL = Redmine_URL + "issue.json";
	Ответ = ВыполнитьЗапросRedmine(RM_Issues_URL, "POST", ПараметрыЗапроса);
	Проекты = Ответ.Получить("projects");

	Если Проекты = Неопределено Тогда
		Возврат id;
	КонецЕсли;

	Для Каждого Проект Из Проекты Цикл
		currentName = Проект.Получить("name");
		Если currentName = name Тогда
			id = Проект.Получить("id");
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Возврат id;
	
КонецФункции