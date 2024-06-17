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
	Объект.УдалитьСозданные = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьДействие(Команда)
	ФоновоеЗадание = НачатьВыполнениеНаСервере();
	
	НастройкиОжидания                                = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	Обработчик = Новый ОписаниеОповещения("ПослеВыполнениеДействия", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ФоновоеЗадание, Обработчик, НастройкиОжидания);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция НачатьВыполнениеНаСервере()
	
	ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 Начало выполнения...'"), ТекущаяДатаСеанса()));
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("КоличествоКонтрагентов", Объект.КоличествоКонтрагентов);
	ПараметрыПроцедуры.Вставить("КоличествоБанковскихСчетовКонтрагента", Объект.КоличествоБанковскихСчетовКонтрагента);
	ПараметрыПроцедуры.Вставить("УдалитьСозданные", Объект.УдалитьСозданные);
		
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Демо: замер длительной операции'");
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("Обработки._ДемоЗамерДлительнойОперации.ВыполнитьДействие", 
		ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции
	
&НаКлиенте
Процедура ПослеВыполнениеДействия(ФоновоеЗадание, ДополнительныеПараметры) Экспорт
	
	Если ФоновоеЗадание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ФоновоеЗадание.Статус = "Выполнено" Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Действие выполнено.'"));	
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не удалось выполнить действие.'") + ФоновоеЗадание.КраткоеПредставлениеОшибки);
	КонецЕсли;
	
КонецПроцедуры
	
#КонецОбласти
