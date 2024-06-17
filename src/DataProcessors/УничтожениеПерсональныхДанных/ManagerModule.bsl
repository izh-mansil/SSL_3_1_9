///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Создает акты об уничтожении персональных данных.
// 
// Параметры:
//  СубъектыИОрганизации - Массив из Структура:
//   * Субъект - ОпределяемыйТип.СубъектПерсональныхДанных
//   * Организация - ОпределяемыйТип.Организация
//  ДанныеЗаполнения - Структура:
//   * Организация - ОпределяемыйТип.Организация
//   * ПричинаУничтожения - Строка
//   * СпособУничтожения - Строка
//   * ОтветственныйЗаОбработкуПерсональныхДанных - СправочникСсылка.Пользователи
//
Процедура СоздатьАкты(СубъектыИОрганизации, ДанныеЗаполнения) Экспорт
	
	ТекущаяДата = ТекущаяДатаСеанса();
	ДанныеЗаполнения.Вставить("ЗаполнитьКатегорииДанных");
	
	КоличествоСубъектов = СубъектыИОрганизации.Количество();
	Если КоличествоСубъектов = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Номер = 1;
	
	Для Каждого СубъектИОрганизация Из СубъектыИОрганизации Цикл
		
		Субъект = СубъектИОрганизация.Субъект;
		
		Если Не ЗначениеЗаполнено(Субъект) Тогда
			Продолжить;
		КонецЕсли;
		
		ЗащитаПерсональныхДанных.ОбновитьСрокХраненияПерсональныхДанныхСубъекта(Субъект);
		
		СрокХранения = ЗащитаПерсональныхДанных.СрокХраненияПерсональныхДанныхСубъекта(Субъект);
		Если НачалоДня(ТекущаяДата) < СрокХранения Тогда
			ТекстСообщения =СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не истек срок хранения персональных данных для %1. Акт об уничтожении не сформирован.'"),
				Строка(Субъект));
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Продолжить;
		КонецЕсли;
		
		Попытка
			
			АктОбъект = Документы.АктОбУничтоженииПерсональныхДанных.СоздатьДокумент();
			АктОбъект.Дата = ТекущаяДата;
			АктОбъект.ДатаУничтожения = ТекущаяДата;
			АктОбъект.Субъект = Субъект;
			АктОбъект.ЗаполнитьТабличныеЧасти();
			АктОбъект.Заполнить(ДанныеЗаполнения);
			Если ЗначениеЗаполнено(СубъектИОрганизация.Организация) Тогда
				АктОбъект.Организация = СубъектИОрганизация.Организация;
			КонецЕсли;
			АктОбъект.Записать(РежимЗаписиДокумента.Проведение);
			
		Исключение
			
			ТекстОшибкиПодробно =СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось создать Акт об уничтожении персональных данных для %1 по причине:
					|%2'"), Строка(СубъектИОрганизация.Субъект),
					ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Создание акта об уничтожении персональных данных'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка, Метаданные.Документы.АктОбУничтоженииПерсональныхДанных, ,
				ТекстОшибкиПодробно);
				
			ТекстОшибкиКратко =СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось создать Акт об уничтожении персональных данных для %1 по причине:
				|%2'"), Строка(Субъект), ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибкиКратко);
			
		КонецПопытки;
		
		ПроцентВыполнения = Окр(Номер / КоличествоСубъектов * 100);
		ДлительныеОперации.СообщитьПрогресс(ПроцентВыполнения,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Формируются акты об уничтожении персональных данных: %1 из %2'"), 
			Строка(Номер), Строка(КоличествоСубъектов)));
		Номер = Номер + 1;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
