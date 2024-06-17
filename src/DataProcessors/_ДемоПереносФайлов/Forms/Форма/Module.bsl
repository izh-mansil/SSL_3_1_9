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
	
	ВладельцыФайлов = Новый Массив;
	
	СуффиксСправочника = РаботаСФайламиКлиентСервер.СуффиксСправочникаПрисоединенныеФайлы();
	ДлинаПрефикса      = СтрДлина(СуффиксСправочника);
	
	Для Каждого СправочникСФайлами Из Метаданные.Справочники Цикл
		Если СтрЗаканчиваетсяНа(СправочникСФайлами.Имя, СуффиксСправочника) Тогда
			КраткоеИмяВладельцаФайлов = Лев(СправочникСФайлами.Имя, СтрДлина(СправочникСФайлами.Имя) - ДлинаПрефикса);
			Если Метаданные.Справочники.Найти(КраткоеИмяВладельцаФайлов) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			ИмяТипа = "СправочникСсылка." + КраткоеИмяВладельцаФайлов;
			Если Метаданные.Справочники.Файлы.Реквизиты.ВладелецФайла.Тип.СодержитТип(Тип(ИмяТипа)) Тогда
				ВладельцыФайлов.Добавить("Справочник." + Лев(СправочникСФайлами.Имя, СтрДлина(СправочникСФайлами.Имя) - ДлинаПрефикса));
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ИмяОМ Из ВладельцыФайлов Цикл
		ВладелецФайлов = ОбщегоНазначения.ОбъектМетаданныхПоПолномуИмени(ИмяОМ);
		Элементы.ОбъектМетаданныхСФайлами.СписокВыбора.Добавить(ВладелецФайлов.ПолноеИмя(), ВладелецФайлов.Представление());
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбъектМетаданныхСФайламиПриИзменении(Элемент)
	
	ЗаполнитьТаблицуСсылок();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиФайлы(Команда)
	
	Если ПустаяСтрока(ОбъектМетаданныхСФайлами) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Укажите таблицу с файлами.'"),, "ОбъектМетаданныхСФайлами");
		Возврат;
	КонецЕсли;
	
	Результат = ПеренестиФайлыСервер();
	Если Результат > 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Файлы успешно перенесены (%1).'"), Результат);
	Иначе
		ТекстСообщения = НСтр("ru = 'Файлы не были перенесены. Нажмите ""Создать файлы для переноса"" и повторите перенос.'");
	КонецЕсли;
	ПоказатьПредупреждение(, ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьФайлыДляПереноса(Команда)
	
	Если ПустаяСтрока(ОбъектМетаданныхСФайлами) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Укажите объект метаданных с файлами.'"),, "ОбъектМетаданныхСФайлами");
		Возврат;
	КонецЕсли;
	
	Результат = СоздатьФайлыДляПереносаНаСервере();
	ЗаполнитьТаблицуСсылок();
	
	Если Результат > 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Файлы успешно созданы (%1).'"), Результат);
	Иначе
		ТекстСообщения = НСтр("ru = 'Файлы для переноса не были созданы.'");
	КонецЕсли;
	ПоказатьПредупреждение(, ТекстСообщения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуСсылок()
	
	ТаблицаСсылок.Очистить();
	ТаблицаСсылокЗначение = РеквизитФормыВЗначение("ТаблицаСсылок");
	МассивСсылок = РаботаСФайлами.СсылкиНаОбъектыСФайлами(ОбъектМетаданныхСФайлами);
	Для Каждого Ссылка Из МассивСсылок Цикл
		НоваяСтрока = ТаблицаСсылокЗначение.Добавить();
		НоваяСтрока.Ссылка = Ссылка;
	КонецЦикла;
	ЗначениеВРеквизитФормы(ТаблицаСсылокЗначение, "ТаблицаСсылок");
	
КонецПроцедуры

&НаСервере
Функция ПеренестиФайлыСервер()
	
	Результат = 0;
	Для Каждого Строка Из ТаблицаСсылок Цикл
		ПеренесенныеФайлы = РаботаСФайлами.СконвертироватьФайлыВПрисоединенные(Строка.Ссылка);
		Результат = ПеренесенныеФайлы.Количество() + Результат;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

// Копируем файлы из справочника "Демо: НоменклатураПрисоединенныеФайлы" в "Файлы".
&НаСервере
Функция СоздатьФайлыДляПереносаНаСервере()
	
	ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ПрисоединенныеФайлы.Автор КАК Автор,
		|	ПрисоединенныеФайлы.ВладелецФайла КАК ВладелецФайлов,
		|	ПрисоединенныеФайлы.Расширение КАК РасширениеБезТочки,
		|	ПрисоединенныеФайлы.Наименование КАК ИмяБезРасширения,
		|	ПрисоединенныеФайлы.ДатаМодификацииУниверсальная КАК ВремяИзмененияУниверсальное,
		|	ПрисоединенныеФайлы.Ссылка КАК Ссылка
		|ИЗ
		|	&ИмяТаблицы КАК ПрисоединенныеФайлы";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяТаблицы", 
		ОбъектМетаданныхСФайлами + РаботаСФайламиКлиентСервер.СуффиксСправочникаПрисоединенныеФайлы());
	Запрос = Новый Запрос(ТекстЗапроса);
	РезультатЗапроса = Запрос.Выполнить();
	
	ПрисоединенныеФайлы = РезультатЗапроса.Выбрать();
	Если ПрисоединенныеФайлы.Количество() = 0 Тогда
		Возврат 0;
	КонецЕсли;
	
	Результат = 0;
	Пока ПрисоединенныеФайлы.Следующий() Цикл
		
		ФайлИсточник = ПрисоединенныеФайлы.Ссылка; // СправочникСсылка
		
		НачатьТранзакцию();
		Попытка
			
			ФайлИсточникОбъект = ФайлИсточник.ПолучитьОбъект();
			
			СсылкаНового = Справочники.Файлы.ПолучитьСсылку();
			ФайлОбъект = Справочники.Файлы.СоздатьЭлемент();
			ФайлОбъект.УстановитьСсылкуНового(СсылкаНового);
			
			ЗаполнитьЗначенияСвойств(ФайлОбъект, ФайлИсточникОбъект, , "Владелец, Родитель, Код");
			
			ФайлОбъект.Заполнить(Неопределено);
			
			ФайлОбъект.Записать();
			
			Если ФайлОбъект.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе Тогда
				ДвоичныеДанные = РаботаСФайлами.ДвоичныеДанныеФайла(ФайлИсточникОбъект.Ссылка);
				
				МенеджерЗаписи = РегистрыСведений.ДвоичныеДанныеФайлов.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.Файл = СсылкаНового;
				МенеджерЗаписи.Прочитать();
				МенеджерЗаписи.Файл = СсылкаНового;
				МенеджерЗаписи.ДвоичныеДанныеФайла = Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных(9));
				МенеджерЗаписи.Записать();
				
			КонецЕсли;
			
			// Создаем тестовую версию.
			ДанныеФайла = РаботаСФайлами.ДанныеФайла(СсылкаНового);
			СведенияОФайле = РаботаСФайламиКлиентСервер.СведенияОФайле("ФайлСВерсией");
			СведенияОФайле.Размер = ДанныеФайла.Размер + 1; // для записи версии безусловно
			СведенияОФайле.АдресВременногоХранилищаФайла = ДанныеФайла.СсылкаНаДвоичныеДанныеФайла;
			СведенияОФайле.ИмяБезРасширения = ДанныеФайла.Наименование;
			СведенияОФайле.РасширениеБезТочки = ДанныеФайла.Расширение;
			СведенияОФайле.ВремяИзменения = ТекущаяДатаСеанса();
			СведенияОФайле.Кодировка = ДанныеФайла.Кодировка;
			СведенияОФайле.ХранитьВерсии = Истина;
			РаботаСФайламиСлужебный.ОбновитьВерсиюФайла(СсылкаНового, СведенияОФайле);
			
			Результат = Результат + 1;
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

#КонецОбласти
