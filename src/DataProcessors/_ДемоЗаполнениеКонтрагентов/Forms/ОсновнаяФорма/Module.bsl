///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// АПК:78-выкл дополнительная обработка

// Обработчик клиентской назначаемой команды.
//
// Параметры:
//   ИдентификаторКоманды - Строка - имя команды, как оно задано в функции СведенияОВнешнейОбработке модуля объекта.
//   ОбъектыНазначения - Массив - ссылки, для которых выполняется команда.
//
&НаКлиенте
Процедура ВыполнитьКоманду(ИдентификаторКоманды, ОбъектыНазначения) Экспорт
	
	Если ИдентификаторКоманды = "ЗаполнитьВсе" Тогда
		ЗаполнитьКонтрагентов(ОбъектыНазначения, Истина, Истина);
		ОбновитьКонтрагентовИЗакрыть();
	КонецЕсли;
	
КонецПроцедуры
// АПК:78-вкл

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Для Каждого ЭлементОбъектыНазначения Из Параметры.ОбъектыНазначения Цикл
		ОбъектыНазначения.Добавить(ЭлементОбъектыНазначения);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьПрефиксКНаименованию(Команда)
	СопровождающийТекст = НСтр("ru = 'Добавление префикса к реквизиту ""Наименование""'");
	
	ПараметрыКоманды = ДополнительныеОтчетыИОбработкиКлиент.ПараметрыВыполненияКомандыВФоне(Параметры.ДополнительнаяОбработкаСсылка);
	ПараметрыКоманды.ОбъектыНазначения = ОбъектыНазначения.ВыгрузитьЗначения();
	ПараметрыКоманды.СопровождающийТекст = СопровождающийТекст + "...";
	
	ПоказатьОповещениеПользователя(ПараметрыКоманды.СопровождающийТекст);
	
	Обработчик = Новый ОписаниеОповещения("ПослеЗавершенияДлительнойОперации", ЭтотОбъект, СопровождающийТекст);
	
	Если ЗначениеЗаполнено(Параметры.ДополнительнаяОбработкаСсылка) Тогда
		ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьКомандуВФоне(Параметры.ИдентификаторКоманды, ПараметрыКоманды, Обработчик);
	Иначе
		Операция = ВыполнитьКомандуНапрямую(ПараметрыКоманды);
		ВыполнитьОбработкуОповещения(Обработчик, Операция);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ВыполнитьКомандуНапрямую(ПараметрыКоманды)
	Операция = Новый Структура("Статус, КраткоеПредставлениеОшибки, ПодробноеПредставлениеОшибки");
	Попытка
		ДополнительныеОтчетыИОбработки.ВыполнитьКомандуИзФормыВнешнегоОбъекта(
			Параметры.ИдентификаторКоманды,
			ПараметрыКоманды,
			ЭтотОбъект);
		Операция.Статус = "Выполнено";
	Исключение
		Операция.КраткоеПредставлениеОшибки   = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		Операция.ПодробноеПредставлениеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	Возврат Операция;
КонецФункции

&НаСервере
Процедура ЗаполнитьКонтрагентов(ОбъектыНазначения, ЗаполнятьНаименование, ДобавлятьПрефикс)
	
	РеквизитФормыВЗначение("Объект").ЗаполнитьКонтрагентов(ОбъектыНазначения, ЗаполнятьНаименование, ДобавлятьПрефикс);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗавершенияДлительнойОперации(Операция, СопровождающийТекст) Экспорт
	ОбновитьКонтрагентовИЗакрыть();
	Если Операция.Статус = "Выполнено" Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Успешное завершение'"), , СопровождающийТекст, БиблиотекаКартинок.Успешно32);
	Иначе
		ПоказатьПредупреждение(, Операция.КраткоеПредставлениеОшибки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКонтрагентовИЗакрыть()
	Если ТипЗнч(ВладелецФормы) = Тип("ФормаКлиентскогоПриложения") И Не ВладелецФормы.Модифицированность Тогда
		Попытка
			ВладелецФормы.Прочитать();
		Исключение
			// Значит это форма списка.
		КонецПопытки;
	КонецЕсли;
	ОповеститьОбИзменении(Тип("СправочникСсылка._ДемоКонтрагенты"));
	Если Открыта() Тогда
		Закрыть();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
