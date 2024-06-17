///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает пространство имен текущей (используемой вызывающим кодом) версии интерфейса сообщений.
//
// Возвращаемое значение:
//   Строка
//
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/1cFresh/ApplicationExtensions/Management/" + Версия();
	
КонецФункции

// Возвращает текущую (используемую вызывающим кодом) версию интерфейса сообщений.
//
// Возвращаемое значение:
//   Строка
//
Функция Версия() Экспорт
	
	Возврат "1.0.1.2";
	
КонецФункции

// Возвращает название программного интерфейса сообщений.
//
// Возвращаемое значение:
//   Строка
//
Функция ПрограммныйИнтерфейс() Экспорт
	
	Возврат "ApplicationExtensionsManagement";
	
КонецФункции

// Выполняет регистрацию обработчиков сообщений в качестве обработчиков каналов обмена сообщениями.
//
// Параметры:
//  МассивОбработчиков - Массив - общие модули или модули менеджеров.
//
Процедура ОбработчикиКаналовСообщений(Знач МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияУправленияДОИООбработчикСообщения_1_0_1_1);
	МассивОбработчиков.Добавить(СообщенияУправленияДОИООбработчикСообщения_1_0_1_2);
	
КонецПроцедуры

// Выполняет регистрацию обработчиков трансляции сообщений.
//
// Параметры:
//  МассивОбработчиков - Массив - общие модули или модули менеджеров.
//
Процедура ОбработчикиТрансляцииСообщений(Знач МассивОбработчиков) Экспорт
	
	
	
КонецПроцедуры

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/ApplicationExtensions/Management/a.b.c.d}InstallExtension
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO
//
Функция СообщениеУстановитьДополнительныйОтчетИлиОбработку(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "InstallExtension");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/ApplicationExtensions/Management/a.b.c.d}ExtensionCommandSettings
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO
//
Функция ТипНастройкиКомандыДополнительногоОтчетаИлиОбработки(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExtensionCommandSettings");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/ApplicationExtensions/Management/a.b.c.d}DeleteExtension
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO
//
Функция СообщениеУдалитьДополнительныйОтчетИлиОбработку(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "DeleteExtension");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/ApplicationExtensions/Management/a.b.c.d}DisableExtension
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO
//
Функция СообщениеОтключитьДополнительныйОтчетИлиОбработку(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "DisableExtension");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/ApplicationExtensions/Management/a.b.c.d}EnableExtension
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO
//
Функция СообщениеВключитьДополнительныйОтчетИлиОбработку(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "EnableExtension");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/ApplicationExtensions/Management/a.b.c.d}DropExtension
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO
//
Функция СообщениеОтозватьДополнительныйОтчетИлиОбработку(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "DropExtension");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/ApplicationExtensions/Management/a.b.c.d}SetExtensionSecurityProfile
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO
//
Функция СообщениеУстановитьРежимИсполненияДополнительногоОтчетаИлиОбработкиВОбластиДанных(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetExtensionSecurityProfile");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СоздатьТипСообщения(Знач ИспользуемыйПакет, Знач Тип)
	
	Если ИспользуемыйПакет = Неопределено Тогда
		ИспользуемыйПакет = Пакет();
	КонецЕсли;
	
	Возврат ФабрикаXDTO.Тип(ИспользуемыйПакет, Тип);
	
КонецФункции

#КонецОбласти