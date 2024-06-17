///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗадачаБылаВыполнена = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Выполнена");
	Если Выполнена И ЗадачаБылаВыполнена <> Истина И НЕ РеквизитыАдресацииЗаполнены() Тогда
		
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Укажите исполнителя задачи.'"),,,
			"Объект.Исполнитель", Отказ);
		Возврат;
			
	КонецЕсли;
	
	Если СрокИсполнения <> '00010101' И ДатаНачала > СрокИсполнения Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Дата начала исполнения не должна превышать крайний срок.'"),,,
			"Объект.ДатаНачала", Отказ);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = ТекущаяДатаСеанса();

КонецПроцедуры


Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Ссылка.Пустая() Тогда
		ИсходныеРеквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, 
			"Выполнена, ПометкаУдаления, СостояниеБизнесПроцесса");
	Иначе
		ИсходныеРеквизиты = Новый Структура(
			"Выполнена, ПометкаУдаления, СостояниеБизнесПроцесса",
			Ложь, Ложь, Перечисления.СостоянияБизнесПроцессов.ПустаяСсылка());
	КонецЕсли;
		
	Если ИсходныеРеквизиты.ПометкаУдаления <> ПометкаУдаления Тогда
		БизнесПроцессыИЗадачиСервер.ПриПометкеУдаленияЗадачи(Ссылка, ПометкаУдаления);
	КонецЕсли;
	
	Если НЕ ИсходныеРеквизиты.Выполнена И Выполнена Тогда
		
		Если СостояниеБизнесПроцесса = Перечисления.СостоянияБизнесПроцессов.Остановлен Тогда
			ВызватьИсключение НСтр("ru = 'Нельзя выполнять задачи остановленных бизнес-процессов.'");
		КонецЕсли;
		
		// Если задача выполнена, то запишем в реквизит Исполнитель того
		// пользователя, который фактически выполнил задачу. Это нам потом
		// потребуется для отчетов. Такую запись делаем только в том
		// случае, если в базе было не выполнено, а в объекте стало выполнено.
		Если НЕ ЗначениеЗаполнено(Исполнитель) Тогда
			Исполнитель = Пользователи.АвторизованныйПользователь();
		КонецЕсли;
		Если ДатаИсполнения = Дата(1, 1, 1) Тогда
			ДатаИсполнения = ТекущаяДатаСеанса();
		КонецЕсли;
	ИначеЕсли НЕ ПометкаУдаления И ИсходныеРеквизиты.Выполнена И Выполнена Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Эта задача уже была выполнена ранее.'"),,,, Отказ);
			Возврат;
	КонецЕсли;
	
	Если Важность.Пустая() Тогда
		Важность = Перечисления.ВариантыВажностиЗадачи.Обычная;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СостояниеБизнесПроцесса) Тогда
		СостояниеБизнесПроцесса = Перечисления.СостоянияБизнесПроцессов.Активен;
	КонецЕсли;
	
	ПредметСтрокой = ОбщегоНазначения.ПредметСтрокой(Предмет);
	
	Если НЕ Ссылка.Пустая() И ИсходныеРеквизиты.СостояниеБизнесПроцесса <> СостояниеБизнесПроцесса Тогда
		УстановитьСостояниеПодчиненныхБизнесПроцессов(СостояниеБизнесПроцесса);
	КонецЕсли;
	
	Если Выполнена И Не ПринятаКИсполнению Тогда
		ПринятаКИсполнению = Истина;
		ДатаПринятияКИсполнению = ТекущаяДатаСеанса();
	КонецЕсли;
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УстановитьПривилегированныйРежим(Истина);
	ГруппаИсполнителейЗадач = БизнесПроцессыИЗадачиСервер.ГруппаИсполнителейЗадач(РольИсполнителя, 
		ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации);
	УстановитьПривилегированныйРежим(Ложь);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Заполнение реквизита ДатаПринятияКИсполнению.
	Если ПринятаКИсполнению И ДатаПринятияКИсполнению = Дата('00010101') Тогда
		ДатаПринятияКИсполнению = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ТолькоПроверка")
	   И ДополнительныеСвойства.ТолькоПроверка Тогда
		Выполнена = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ЗадачаОбъект.ЗадачаИсполнителя") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, 
			"БизнесПроцесс,ТочкаМаршрута,Наименование,Исполнитель,РольИсполнителя,ОсновнойОбъектАдресации," 
			+ "ДополнительныйОбъектАдресации,Важность,ДатаИсполнения,Автор,Описание,СрокИсполнения," 
			+ "ДатаНачала,РезультатВыполнения,Предмет");
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Важность) Тогда
		Важность = Перечисления.ВариантыВажностиЗадачи.Обычная;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СостояниеБизнесПроцесса) Тогда
		СостояниеБизнесПроцесса = Перечисления.СостоянияБизнесПроцессов.Активен;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьСостояниеПодчиненныхБизнесПроцессов(НовоеСостояние)
	
	НачатьТранзакцию();
	Попытка
		ПодчиненныеБизнесПроцессы = БизнесПроцессыИЗадачиСервер.БизнесПроцессыГлавнойЗадачи(Ссылка, Истина);
		Для Каждого ПодчиненныйБизнесПроцесс Из ПодчиненныеБизнесПроцессы Цикл
			БизнесПроцессОбъект = ПодчиненныйБизнесПроцесс.ПолучитьОбъект();
			БизнесПроцессОбъект.Заблокировать();
			БизнесПроцессОбъект.Состояние = НовоеСостояние;
			БизнесПроцессОбъект.Записать(); // АПК:1327 Блокировка установлена в БизнесПроцессыИЗадачиСервер.БизнесПроцессыГлавнойЗадачи.
		КонецЦикла;	
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Определяет, заполнены ли реквизиты адресации: исполнитель или роль исполнителя
// 
// Возвращаемое значение:
//  Булево - возвращает Истина, если в задаче указан исполнитель или роль исполнителя.
//
Функция РеквизитыАдресацииЗаполнены()
	
	Возврат ЗначениеЗаполнено(Исполнитель) ИЛИ НЕ РольИсполнителя.Пустая();

КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли