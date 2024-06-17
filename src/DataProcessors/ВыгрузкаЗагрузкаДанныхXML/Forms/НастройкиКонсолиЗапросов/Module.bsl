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
	
	ВариантИспользованияКонсолиЗапросов = Параметры.ВариантИспользованияКонсолиЗапросов;
	ПутьКВнешнейКонсолиЗапросов = Параметры.ПутьКВнешнейКонсолиЗапросов;
	
	Элементы.ПутьКВнешнейКонсолиЗапросов.Доступность = (ВариантИспользованияКонсолиЗапросов = "Внешняя");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантИспользованияКонсолиЗапросовПриИзменении(Элемент)
	
	Элементы.ПутьКВнешнейКонсолиЗапросов.Доступность = (ВариантИспользованияКонсолиЗапросов = "Внешняя");
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКВнешнейКонсолиЗапросовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.ПроверятьСуществованиеФайла = Истина;
	Диалог.МножественныйВыбор = Ложь;
	Диалог.Фильтр = НСтр("ru = 'Внешние обработки (*.epf)|*.epf'");
	
	ОповещениеОВыборе = Новый ОписаниеОповещения("ПутьКВнешнейКонсолиЗапросовЗавершениеВыбора", ЭтотОбъект);
	Диалог.Показать(ОповещениеОВыборе);
	
КонецПроцедуры

&НаКлиенте
Процедура Подтвердить(Команда)
	
	НастройкиКонсолиЗапросов = Новый Структура;
	НастройкиКонсолиЗапросов.Вставить("ВариантИспользованияКонсолиЗапросов", ВариантИспользованияКонсолиЗапросов);
	НастройкиКонсолиЗапросов.Вставить("ПутьКВнешнейКонсолиЗапросов", ПутьКВнешнейКонсолиЗапросов);
	
	Закрыть(НастройкиКонсолиЗапросов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПутьКВнешнейКонсолиЗапросовЗавершениеВыбора(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПутьКВнешнейКонсолиЗапросов = ВыбранныеФайлы[0];
	
КонецПроцедуры

#КонецОбласти
