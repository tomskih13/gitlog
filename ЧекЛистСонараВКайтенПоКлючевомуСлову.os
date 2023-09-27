#Использовать "."

Перем Задачи;
Процедура ОтправитьВКайтенСтрокиСонараПоЗаданнойКарточкеИПоисковойСтроке(urlCard) Экспорт
	
	КарточкаКайтен			= Задачи.КарточкаКайтен(urlCard);
	Автор					= Задачи.РазработчикКарточки(КарточкаКайтен);	

	Если Не ЗначениеЗаполнено(Автор) Тогда
		ВызватьИсключение("В карточке кайтен не заполнен разработчик")
	КонецЕсли;

	ОписаниеЗадачи			= Задачи.ОписаниеЗадачи(КарточкаКайтен);
	КлючевоеСлово			= Задачи.КлючевоеСловоПоЗадаче(ОписаниеЗадачи);
	СписокФайловПоЗадаче 	= Задачи.СписокФайловПоЗадаче(КлючевоеСлово);
	СтрокиСонара 			= Задачи.СтрокиСонара(СписокФайловПоЗадаче, Автор);
	Задачи.ОтправитьЧекЛистОшибокВКарточку(КарточкаКайтен, СтрокиСонара);
	
КонецПроцедуры

Задачи = Новый gitlog();
Настройки 	= Задачи.ИницилизацияПеременных(АргументыКоманднойСтроки);
// ХешКоммита 	= Настройки.Получить("ХешКоммита"); // "b911c27cb049374f11ee4d580354045e";
urlCard		= Настройки.Получить("urlCard"); //"https://ekk2.kaiten.ru/18686764"
ОтправитьВКайтенСтрокиСонараПоЗаданнойКарточкеИПоисковойСтроке(urlCard);