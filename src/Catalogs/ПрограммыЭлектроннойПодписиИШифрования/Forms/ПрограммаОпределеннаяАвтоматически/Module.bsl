///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтоПодчиненныйУзелРИБ = ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ();
	ЕстьПраваНаДобавлениеПрограммы = ПравоДоступа("Добавление", Метаданные.Справочники.ПрограммыЭлектроннойПодписиИШифрования);
	
	Если ЗначениеЗаполнено(Параметры.Программа) Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.Программа);
		
		Заголовок = Параметры.Программа.Представление;
		
		ПутьКПрограмме = Параметры.Программа.ПутьКПрограммеАвто;
		Элементы.ПутьКПрограмме.Видимость = ЗначениеЗаполнено(ПутьКПрограмме);
		
		ПутьКПрограммеНаСервере = Параметры.Программа.ПутьКПрограммеАвто;
		Элементы.ПутьКПрограммеНаСервере.Видимость = ЗначениеЗаполнено(ПутьКПрограммеНаСервере);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Изменить(Команда)

	ДобавитьВСправочник(ПредопределенноеЗначение(
		"Перечисление.РежимыИспользованияПрограммыЭлектроннойПодписи.Настроена"));

КонецПроцедуры

&НаКлиенте
Процедура Запретить(Команда)

	ДобавитьВСправочник(ПредопределенноеЗначение(
		"Перечисление.РежимыИспользованияПрограммыЭлектроннойПодписи.НеИспользуется"));

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДобавитьВСправочник(РежимИспользования)
	
	Если Не ЕстьПраваНаДобавлениеПрограммы Тогда

		ПоказатьПредупреждение( , НСтр("ru = 'Для изменения настроек программы обратитесь к администратору.'"));

	ИначеЕсли ЭтоПодчиненныйУзелРИБ Тогда

		ПоказатьПредупреждение( , НСтр("ru = 'Для изменения настроек программы необходимо добавить ее в справочник.
					 |Выполните добавление в главном узле информационной базы.'"));

	Иначе
	
		ПараметрыФормы = Новый Структура("Программа, РежимИспользования", Параметры.Программа, РежимИспользования);
		ОткрытьФорму("Справочник.ПрограммыЭлектроннойПодписиИШифрования.ФормаОбъекта", ПараметрыФормы,,,,,,
			РежимОткрытияОкнаФормы.Независимый);
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти