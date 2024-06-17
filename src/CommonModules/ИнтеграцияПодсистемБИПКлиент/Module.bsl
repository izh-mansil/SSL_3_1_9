///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ИнтеграцияПодсистемБИП.
//
// Клиентские процедуры и функции интеграции с БСП и БИП:
//  - Подписка на события БСП;
//  - Обработка событий БСП в подсистемах БИП;
//  - Определение списка возможных подписок в БИП;
//  - Вызов методов БСП, на которые выполнена подписка;
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.БазоваяФункциональность

// Обработка программных событий, возникающих в подсистемах БСП.
// Только для вызовов из библиотеки БСП в БИП.

// Определяет события, на которые подписана эта библиотека.
//
// Параметры:
//  Подписки - Структура - См. ИнтеграцияПодсистемБСПКлиент.СобытияБСП.
//
Процедура ПриОпределенииПодписокНаСобытияБСП(Подписки) Экспорт
	
	// Варианты отчетов
	Подписки.ПриОбработкеВыбораТабличногоДокумента = Истина;
	Подписки.ПриОбработкеРасшифровки = Истина;

	Подписки.ПослеНачалаРаботыСистемы = Истина;

КонецПроцедуры

#Область ВариантыОтчетов

// См. ОтчетыКлиентПереопределяемый.ОбработкаВыбораТабличногоДокумента.
//
Процедура ПриОбработкеВыбораТабличногоДокумента(ФормаОтчета, Элемент, Область, СтандартнаяОбработка) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СПАРКРиски") Тогда
		МодульСПАРКРискиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СПАРКРискиКлиент");
		МодульСПАРКРискиКлиент.ПриОбработкеВыбораТабличногоДокумента(
			ФормаОтчета,
			Элемент,
			Область,
			СтандартнаяОбработка);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СистемаБыстрыхПлатежей.СверкаВзаиморасчетовСБПc2b") Тогда
		МодульСверкаВзаиморасчетовСБПc2bКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СверкаВзаиморасчетовСБПc2bКлиент");
		МодульСверкаВзаиморасчетовСБПc2bКлиент.ПриОбработкеВыбораТабличногоДокумента(
			ФормаОтчета,
			Элемент,
			Область,
			СтандартнаяОбработка);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СистемаБыстрыхПлатежей.ПереводыСБПc2b") Тогда
		МодульПереводыСБПc2bКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПереводыСБПc2bКлиент");
		МодульПереводыСБПc2bКлиент.ПриОбработкеВыбораТабличногоДокумента(
			ФормаОтчета,
			Элемент,
			Область,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// См. ОтчетыКлиентПереопределяемый.ОбработкаРасшифровки.
//
Процедура ПриОбработкеРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СПАРКРиски") Тогда
		МодульСПАРКРискиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СПАРКРискиКлиент");
		МодульСПАРКРискиКлиент.ПриОбработкеРасшифровки(
			ФормаОтчета,
			Элемент,
			Расшифровка,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.БазоваяФункциональность

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область БазоваяФункциональность

// См. ИнтернетПоддержкаПользователейКлиентПереопределяемый.ОткрытьИнтернетСтраницу.
//
Процедура ОткрытьИнтернетСтраницу(АдресСтраницы, ЗаголовокОкна, СтандартнаяОбработка) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ОткрытьИнтернетСтраницу Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ОткрытьИнтернетСтраницу(
			АдресСтраницы,
			ЗаголовокОкна,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область БазоваяФункциональностьСБП

// См. СистемаБыстрыхПлатежейКлиентПереопределяемый.ПриОбработкеНавигационнойСсылкиДополнительнойИнформации.
//
Процедура ПриОбработкеНавигационнойСсылкиДополнительнойИнформации(
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ПриОбработкеНавигационнойСсылкиДополнительнойИнформации Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ПриОбработкеНавигационнойСсылкиДополнительнойИнформации(
			Элемент,
			НавигационнаяСсылкаФорматированнойСтроки,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПереводыСБПc2b

// См. ПереводыСБПc2bКлиентПереопределяемый.ПриЗаполненииПараметровСообщенияБезШаблонаСБП.
//
Процедура ПриЗаполненииПараметровСообщенияБезШаблонаСБП(ПараметрыСообщения, ПараметрыОперации) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ПриЗаполненииПараметровСообщенияБезШаблонаСБП Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ПриЗаполненииПараметровСообщенияБезШаблонаСБП(ПараметрыСообщения, ПараметрыОперации);
	КонецЕсли;
	
КонецПроцедуры

// См. ПереводыСБПc2bКлиентПереопределяемый.ПриОткрытииФормыQRКода.
//
Процедура ПриОткрытииФормыQRКода(
		Форма,
		ДанныеПлатежнойСсылки,
		ОповещениеПослеЗавершенияНастройкиФормы) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ПриОткрытииФормыQRКода Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ПриОткрытииФормыQRКода(
			Форма,
			ДанныеПлатежнойСсылки,
			ОповещениеПослеЗавершенияНастройкиФормы);
	КонецЕсли;
	
КонецПроцедуры

// См. ПереводыСБПc2bКлиентПереопределяемый.ПриЗакрытииФормыQRКода.
//
Процедура ПриЗакрытииФормыQRКода(Форма) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ПриЗакрытииФормыQRКода Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ПриЗакрытииФормыQRКода(Форма);
	КонецЕсли;
	
КонецПроцедуры

// См. ПереводыСБПc2bКлиентПереопределяемый.ПриОтображенииQRКода.
//
Процедура ПриОтображенииQRКода(ДанныеПлатежнойСсылки, Параметры) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ПриОтображенииQRКода Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ПриОтображенииQRКода(ДанныеПлатежнойСсылки, Параметры);
	КонецЕсли;
	
КонецПроцедуры

// См. ПереводыСБПc2bКлиентПереопределяемый.ПриОбработкеНажатияКоманды.
//
Процедура ПриОбработкеНажатияКоманды(Форма, Команда, ДанныеПлатежнойСсылки) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ПриОбработкеНажатияКоманды Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ПриОбработкеНажатияКоманды(
			Форма,
			Команда,
			ДанныеПлатежнойСсылки);
	КонецЕсли;
	
КонецПроцедуры

// См. ИнтеграцияСПлатежнымиСистемамиКлиентПереопределяемый.ПриЗакрытииФормыПодключенияСсылки.
//
Процедура ПриЗакрытииФормыПодключенияСсылки(Форма, ЗавершениеРаботы) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ПриЗакрытииФормыПодключенияСсылки Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ПриЗакрытииФормыПодключенияСсылки(
			Форма,
			ЗавершениеРаботы);
	КонецЕсли;
	
КонецПроцедуры

// См. ИнтеграцияСПлатежнымиСистемамиКлиентПереопределяемый.ПриОткрытииФормыПодключенияСсылки.
//
Процедура ПриОткрытииФормыПодключенияСсылки(Форма, Отказ) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ПриОткрытииФормыПодключенияСсылки Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ПриОткрытииФормыПодключенияСсылки(
			Форма,
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область МониторПортала1СИТС

// См. МониторПортала1СИТСКлиентПереопределяемый.ПередПолучениемДанныхМонитора.
//
Процедура ПередПолучениемДанныхМонитора(Форма) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ПередПолучениемДанныхМонитора Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ПередПолучениемДанныхМонитора(
			Форма);
	КонецЕсли;
	
КонецПроцедуры

// См. МониторПортала1СИТСКлиентПереопределяемый.ОбработатьКомандуВФормеМонитора.
//
Процедура ОбработатьКомандуВФормеМонитора(Форма, Команда) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ОбработатьКомандуВФормеМонитора Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ОбработатьКомандуВФормеМонитора(
			Форма,
			Команда);
	КонецЕсли;
	
КонецПроцедуры

// См. МониторПортала1СИТСКлиентПереопределяемый.ПриНажатииДекорацииВФормеМонитора.
//
Процедура ПриНажатииДекорацииВФормеМонитора(Форма, Элемент) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ПриНажатииДекорацииВФормеМонитора Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ПриНажатииДекорацииВФормеМонитора(
			Форма,
			Элемент);
	КонецЕсли;
	
КонецПроцедуры

// См. МониторПортала1СИТСКлиентПереопределяемый.ОбработатьНавигационнуюСсылкуВФормеМонитора.
//
Процедура ОбработатьНавигационнуюСсылкуВФормеМонитора(
	Форма,
	Элемент,
	НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ОбработатьНавигационнуюСсылкуВФормеМонитора Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ОбработатьНавигационнуюСсылкуВФормеМонитора(
			Форма,
			Элемент,
			НавигационнаяСсылкаФорматированнойСтроки,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// См. МониторПортала1СИТСКлиентПереопределяемый.ПриВыполненииОбработчикаОжиданияВФормеМонитора.
//
Процедура ПриВыполненииОбработчикаОжиданияВФормеМонитора(Форма) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ПриВыполненииОбработчикаОжиданияВФормеМонитора Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ПриВыполненииОбработчикаОжиданияВФормеМонитора(
			Форма);
	КонецЕсли;
	
КонецПроцедуры

// См. МониторПортала1СИТСКлиентПереопределяемый.ПриЗакрытииФормыМонитора.
//
Процедура ПриЗакрытииФормыМонитора(Форма, ЗавершениеРаботы) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ПриЗакрытииФормыМонитора Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ПриЗакрытииФормыМонитора(
			Форма,
			ЗавершениеРаботы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОнлайнОплаты

// См. ОнлайнОплатыКлиентПереопределяемый.ЭлементФормыНастроекПриИзменении.
//
Процедура ЭлементФормыНастроекПриИзменении(Контекст, Элемент) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ЭлементФормыНастроекПриИзменении Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ЭлементФормыНастроекПриИзменении(Контекст, Элемент);
	КонецЕсли;
	
КонецПроцедуры

// См. ОнлайнОплатыКлиентПереопределяемый.ЭлементФормыНастроекСоздание.
//
Процедура ЭлементФормыНастроекСоздание(Контекст, Элемент, СтандартнаяОбработка) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ЭлементФормыНастроекСоздание Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ЭлементФормыНастроекСоздание(Контекст, Элемент, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// См. ОнлайнОплатыКлиентПереопределяемый.ЭлементФормыНастроекНачалоВыбора.
//
Процедура ЭлементФормыНастроекНачалоВыбора(Контекст, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ЭлементФормыНастроекНачалоВыбора Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ЭлементФормыНастроекНачалоВыбора(
			Контекст,
			Элемент,
			ДанныеВыбора,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// См. ОнлайнОплатыКлиентПереопределяемый.ЭлементФормыНастроекОбработкаВыбора.
//
Процедура ЭлементФормыНастроекОбработкаВыбора(Контекст, Элемент, ВыбранноеЗначение, СтандартнаяОбработка) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ЭлементФормыНастроекОбработкаВыбора Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ЭлементФормыНастроекОбработкаВыбора(
			Контекст,
			Элемент,
			ВыбранноеЗначение,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// См. ОнлайнОплатыКлиентПереопределяемый.ЭлементФормыНастроекНажатие.
//
Процедура ЭлементФормыНастроекНажатие(Контекст, Элемент) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ЭлементФормыНастроекНажатие Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ЭлементФормыНастроекНажатие(Контекст, Элемент);
	КонецЕсли;
	
КонецПроцедуры

// См. ОнлайнОплатыКлиентПереопределяемый.КомандаФормыНастроекДействие.
//
Процедура КомандаФормыНастроекДействие(Контекст, Команда) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().КомандаФормыНастроекДействие Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.КомандаФормыНастроекДействие(Контекст, Команда);
	КонецЕсли;
	
КонецПроцедуры

// См. ОнлайнОплатыКлиентПереопределяемый.ЗаполнитьПараметрыСообщенияБезШаблона.
//
Процедура ЗаполнитьПараметрыСообщенияБезШаблона(ПараметрыСообщения) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ЗаполнитьПараметрыСообщенияБезШаблона Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ЗаполнитьПараметрыСообщенияБезШаблона(ПараметрыСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПолучениеОбновленийПрограммы

// См. ПолучениеОбновленийПрограммыКлиентПереопределяемый.ПриОпределенииНеобходимостиПоказаОповещенийОДоступныхОбновлениях.
//
Процедура ПриОпределенииНеобходимостиПоказаОповещенийОДоступныхОбновлениях(Использование) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ПриОпределенииНеобходимостиПоказаОповещенийОДоступныхОбновлениях Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ПриОпределенииНеобходимостиПоказаОповещенийОДоступныхОбновлениях(Использование);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СПАРКРиски

// См. СПАРКРискиКлиентПереопределяемый.ОбработкаНавигационнойСсылки.
//
Процедура ОбработкаНавигационнойСсылкиСПАРКРиски(
		Форма,
		ЭлементФормы,
		НавигационнаяСсылка,
		СтандартнаяОбработкаФормой,
		СтандартнаяОбработкаБиблиотекой) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ОбработкаНавигационнойСсылкиСПАРКРиски Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ОбработкаНавигационнойСсылкиСПАРКРиски(
			Форма,
			ЭлементФормы,
			НавигационнаяСсылка,
			СтандартнаяОбработкаФормой,
			СтандартнаяОбработкаБиблиотекой);
	КонецЕсли;
	
КонецПроцедуры

// См. СПАРКРискиКлиентПереопределяемый.ОбработкаОповещения.
//
Процедура ОбработкаОповещенияСПАРКРиски(
		Форма,
		КонтрагентОбъект,
		ИмяСобытия,
		Параметр,
		Источник,
		СтандартнаяОбработкаБиблиотекой) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ОбработкаОповещенияСПАРКРиски Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ОбработкаОповещенияСПАРКРиски(
			Форма,
			КонтрагентОбъект,
			ИмяСобытия,
			Параметр,
			Источник,
			СтандартнаяОбработкаБиблиотекой);
	КонецЕсли;
	
КонецПроцедуры

// См. СПАРКРискиКлиентПереопределяемый.ПереопределитьПараметрыПроверкиФоновыхЗаданий.
//
Процедура ПереопределитьПараметрыПроверкиФоновыхЗаданийСПАРКРиски(
		КоличествоПроверок,
		ИнтервалПроверки) Экспорт
	
	Если ИнтеграцияПодсистемБИПКлиентПовтИсп.ПодпискиБСП().ПереопределитьПараметрыПроверкиФоновыхЗаданийСПАРКРиски Тогда
		МодульИнтеграцияПодсистемБСПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБСПКлиент");
		МодульИнтеграцияПодсистемБСПКлиент.ПереопределитьПараметрыПроверкиФоновыхЗаданийСПАРКРиски(
			КоличествоПроверок,
			ИнтервалПроверки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область БазоваяФункциональностьБСП

// См. ОбщегоНазначенияКлиентПереопределяемый.ПослеНачалаРаботыСистемы.
//
Процедура ПослеНачалаРаботыСистемы() Экспорт

	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		МодульОбработкаНовостейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбработкаНовостейКлиент");
		МодульОбработкаНовостейКлиент.ПослеНачалаРаботыСистемы();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет события, на которые могут подписаться другие библиотеки.
//
// Возвращаемое значение:
//   События - Структура - Ключами свойств структуры являются имена событий, на которые
//             могут быть подписаны библиотеки.
//
Функция СобытияБИП() Экспорт
	
	События = Новый Структура;
	
	// Базовая функциональность БИП
	События.Вставить("ОткрытьИнтернетСтраницу", Ложь);
	
	// Монитор Портала 1С:ИТС
	События.Вставить("ПередПолучениемДанныхМонитора", Ложь);
	События.Вставить("ОбработатьКомандуВФормеМонитора", Ложь);
	События.Вставить("ПриОткрытииФормыНастроекИнтеграции", Ложь);
	События.Вставить("ОбработатьНавигационнуюСсылкуВФормеМонитора", Ложь);
	События.Вставить("ПриВыполненииОбработчикаОжиданияВФормеМонитора", Ложь);
	События.Вставить("ПриЗакрытииФормыМонитора", Ложь);
	
	// Онлайн оплаты
	События.Вставить("ЭлементФормыНастроекПриИзменении", Ложь);
	События.Вставить("ЭлементФормыНастроекСоздание", Ложь);
	События.Вставить("ЭлементФормыНастроекНачалоВыбора", Ложь);
	События.Вставить("ЭлементФормыНастроекОбработкаВыбора", Ложь);
	События.Вставить("ЭлементФормыНастроекНажатие", Ложь);
	События.Вставить("КомандаФормыНастроекДействие", Ложь);
	События.Вставить("ЗаполнитьПараметрыСообщенияБезШаблона", Ложь);
	
	// Получение обновления программы
	События.Вставить("ПриОпределенииНеобходимостиПоказаОповещенийОДоступныхОбновлениях", Ложь);
	
	// Базовая функциональность СБП
	События.Вставить("ПриОбработкеНавигационнойСсылкиДополнительнойИнформации", Ложь);
	
	// Переводы СБП (c2b)
	События.Вставить("ПриЗаполненииПараметровСообщенияБезШаблонаСБП", Ложь);
	События.Вставить("ПриОткрытииФормыQRКода", Ложь);
	События.Вставить("ПриОтображенииQRКода", Ложь);
	События.Вставить("ПриЗакрытииФормыQRКода", Ложь);
	События.Вставить("ПриОбработкеНажатияКоманды", Ложь);
	События.Вставить("ПриОткрытииФормыПодключенияСсылки", Ложь);
	События.Вставить("ПриЗакрытииФормыПодключенияСсылки", Ложь);
	
	// СПАРК Риски
	События.Вставить("ОбработкаНавигационнойСсылкиСПАРКРиски", Ложь);
	События.Вставить("ОбработкаОповещенияСПАРКРиски", Ложь);
	События.Вставить("ПереопределитьПараметрыПроверкиФоновыхЗаданийСПАРКРиски", Ложь);
	
	Возврат События;
	
КонецФункции

#КонецОбласти
