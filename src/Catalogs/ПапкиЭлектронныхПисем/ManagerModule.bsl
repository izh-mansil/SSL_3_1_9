///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Код");
	Результат.Добавить("Наименование");
	Результат.Добавить("ПредопределеннаяПапка");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Владелец)
	|	ИЛИ ЗначениеРазрешено(Владелец.ВладелецУчетнойЗаписи, ПустаяСсылка КАК Ложь)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиОбновления

// Регистрирует на плане обмена ОбновлениеИнформационнойБазы объекты,
// которые необходимо обновить на новую версию.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ТекстЗапроса ="
	|ВЫБРАТЬ
	|	ПапкиЭлектронныхПисем.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПапкиЭлектронныхПисем КАК ПапкиЭлектронныхПисем
	|ГДЕ
	|	ПапкиЭлектронныхПисем.ПредопределеннаяПапка
	|	И ПапкиЭлектронныхПисем.ТипПредопределеннойПапки = ЗНАЧЕНИЕ(Перечисление.ТипыПредопределенныхПапокПисем.ПустаяСсылка)
	|";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

// Обработчик обновления на версию 3.1.5.108:
// - заполняет реквизит "ТипПредопределеннойПапки" в справочнике "Папки электронных писем".
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Справочник.ПапкиЭлектронныхПисем";
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	СсылкиДляОбработки.Ссылка       КАК Ссылка,
	|	ТаблицаСправочника.Наименование КАК Наименование
	|ИЗ
	|	&ВТДокументыДляОбработки КАК СсылкиДляОбработки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПапкиЭлектронныхПисем КАК ТаблицаСправочника
	|		ПО ТаблицаСправочника.Ссылка = СсылкиДляОбработки.Ссылка";
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуСсылокДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта, МенеджерВременныхТаблиц);
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли; 
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ВТДокументыДляОбработки", Результат.ИмяВременнойТаблицы);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	ОбъектыДляОбработки = Запрос.Выполнить().Выбрать();
	
	Пока ОбъектыДляОбработки.Следующий() Цикл
		ПредставлениеСсылки = Строка(ОбъектыДляОбработки.Ссылка);
		НачатьТранзакцию();
		
		Попытка
			
			// Устанавливаем управляемую блокировку, чтобы провести ответственное чтение объекта.
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ОбъектыДляОбработки.Ссылка);
			
			Блокировка.Заблокировать();
			
			Объект = ОбъектыДляОбработки.Ссылка.ПолучитьОбъект();
			
			Если Объект = Неопределено Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ОбъектыДляОбработки.Ссылка);
			Иначе
				
				Если Объект.ПредопределеннаяПапка
					И Не ЗначениеЗаполнено(Объект.ТипПредопределеннойПапки) Тогда
					Объект.ТипПредопределеннойПапки = УправлениеЭлектроннойПочтой.ТипПредопределеннойПапкиПоИмени(ОбъектыДляОбработки.Наименование);
					ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
				Иначе
					ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ОбъектыДляОбработки.Ссылка);
				КонецЕсли;
				
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			МетаданныеОбъекта = ОбщегоНазначения.ОбъектМетаданныхПоПолномуИмени(ПолноеИмяОбъекта);
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать %1 %2 по причине: 
					|%3'"), 
				ПолноеИмяОбъекта, ПредставлениеСсылки, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеОбъекта,
				ОбъектыДляОбработки.Ссылка,
				ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
