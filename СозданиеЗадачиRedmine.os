#Использовать "."

Перем Redmine; // экземпляр класса для работы с redmine

Процедура СоздатьЗадачуRedmine(ПараметрыСоздания)
	
	// 1. Разбираем url kaiten - получаем задачу и информацию в ней
	kaitenCard = Redmine.ДанныеЗадачиKaiten();
	// 2. Получаем дополнительные параметры для получения сведений по пользователям
	Redmine.ДополнитьДанныеЗадачиKaiten(kaitenCard);
	Возврат;
	// 3. Формируем данные задачи Redmine
	ДанныеЗадачиRedmine = Redmine.СформироватьДанныеЗадачи(ПараметрыСоздания, kaitenCard);
	
	Возврат; // TODO Удалить
	
	// 4. Отправляем запрос на создание в Redmine
	Redmine.ВыполнитьЗапросRedmine(ПараметрыСоздания.createUrl, "POST", ДанныеЗадачиRedmine);
	// 5. Получаем ответ и формируем данные для обновления задачи в kaiten
	// Найти задачу kaiten, обновить поле задачи redmine
	
КонецПроцедуры

Redmine	= Новый redmine();

// Входные параметры url kaiten задачи, файл конфига (или параметры по одному)
// 0. Разбираем параметры командной строки
ПараметрыСоздания = Redmine.Инициализировать(АргументыКоманднойСтроки);

// Общий алгоритм
СоздатьЗадачуRedmine(ПараметрыСоздания);