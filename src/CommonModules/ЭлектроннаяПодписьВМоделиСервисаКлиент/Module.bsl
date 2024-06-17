///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращаемое значение:
// 	Булево
//
Функция ИспользованиеВозможно() Экспорт
	
	Возврат СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента()["ИспользованиеЭлектроннойПодписиВМоделиСервисаВозможно"];
	
КонецФункции

// Процедура - Изменить настройки получения временных паролей
//
// Параметры:
//  Сертификат - Произвольный - сертификат
//  ОповещениеОЗавершении - ОписаниеОповещения - оповещение о завершении.
//  ПараметрыФормы - Структура - необязательный, содержит дополнительные параметры при открытии формы
//
Процедура ИзменитьНастройкиПолученияВременныхПаролей(Сертификат, 
													ОповещениеОЗавершении = Неопределено, 
													ПараметрыФормы = Неопределено) Экспорт
	Если ПараметрыФормы = Неопределено Тогда
		ПараметрыФормы = Новый Структура;
	КонецЕсли;
	
	ПараметрыФормы.Вставить("Сертификат", Сертификат);
	
	ОткрытьФорму(
		"ОбщаяФорма.НастройкиПолученияВременныхПаролей",
		ПараметрыФормы,,,,,
		ОповещениеОЗавершении);
	
КонецПроцедуры

// Процедура - Изменить способ подтверждения криптооперация
//
// Параметры:
//  Сертификат - Произвольный - сертификат
//  ОповещениеОЗавершении - ОписаниеОповещения - оповещение о завершении.
//  ПараметрыФормы - Структура - необязательный, содержит дополнительные параметры при открытии формы
//
Процедура ИзменитьСпособПодтвержденияКриптоопераций(Сертификат, 
													ОповещениеОЗавершении = Неопределено, 
													ПараметрыФормы = Неопределено) Экспорт
	
	Если ПараметрыФормы = Неопределено Тогда
		ПараметрыФормы = Новый Структура;
	КонецЕсли;
	
	ПараметрыФормы.Вставить("Сертификат", Сертификат);
	
	ОткрытьФорму(
		"ОбщаяФорма.НастройкаПодтвержденияКриптоопераций",
		ПараметрыФормы,,,,,
		ОповещениеОЗавершении);
	
КонецПроцедуры

// Процедура - Отключить подтверждения криптоопераций
//
// Параметры:
//  Сертификат - Произвольный - сертификат
//  ОповещениеОЗавершении - ОписаниеОповещения - оповещение о завершении.
//  ПараметрыФормы - Структура - необязательный, содержит дополнительные параметры при открытии формы
//
Процедура ОтключитьПодтвержденияКриптоопераций(Сертификат, 
												ОповещениеОЗавершении = Неопределено, 
												ПараметрыФормы = Неопределено) Экспорт
	
	Если ПараметрыФормы = Неопределено Тогда
		ПараметрыФормы = Новый Структура;
	КонецЕсли;
	
	ПараметрыФормы.Вставить("Сертификат", Сертификат);
	
	ОткрытьФорму(
		"ОбщаяФорма.ОтключениеПодтвержденияКриптоопераций",
		ПараметрыФормы,,,,,
		ОповещениеОЗавершении);
	
КонецПроцедуры

#КонецОбласти