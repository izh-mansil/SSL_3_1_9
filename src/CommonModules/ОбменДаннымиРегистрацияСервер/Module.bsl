///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ВыборочнаяРегистрацияДанных

// Возвращает идентификатор режима выборочной регистрации, при котором данная функциональность отключена,
// т.е. все записываемые объекты считаются измененными.
//
// Возвращаемое значение:
//  Строка - идентификатор режима выборочной регистрации "Отключен".
//
Функция РежимВыборочнойРегистрацииОтключен() Экспорт
	
	Возврат "Отключен";
	
КонецФункции

// Возвращает идентификатор режима выборочной регистрации, при котором изменение объекта проверяется по
// свойству "Модифицированность" объекта информационной базы.
//
// Возвращаемое значение:
//  Строка - идентификатор режима выборочной регистрации "Модифицированность".
//
Функция РежимВыборочнойРегистрацииМодифицированность() Экспорт
	
	Возврат "Модифицированность";
	
КонецФункции

// Возвращает идентификатор режима выборочной регистрации, при котором изменение объекта проверяется
// сравнением значений реквизитов до и после записи. Список реквизитов готовиться по свойствам объектов,
// описанных в правилах конвертации.
// Режим поддерживается только для планов обменов УОП (см. документацию its.1c.ru).
//
// Возвращаемое значение:
//  Строка - идентификатор режима выборочной регистрации "СогласноПравиламXML".
//
Функция РежимВыборочнойРегистрацииСогласноПравиламXML() Экспорт
	
	Возврат "СогласноПравиламXML";
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ВыборочнаяРегистрацияДанных

Функция ИнициализацияТаблицыПравилВыборочнойРегистрацииОбъектов() Экспорт
	
	ОписаниеТипаЧисло = Новый ОписаниеТипов("Число");
	ОписаниеТипаСтрока = Новый ОписаниеТипов("Строка");
	ОписаниеТипаСтруктура = Новый ОписаниеТипов("Структура");
	
	ТаблицаРезультат = Новый ТаблицаЗначений;
	
	ТаблицаРезультат.Колонки.Добавить("Порядок",                        ОписаниеТипаЧисло);
	ТаблицаРезультат.Колонки.Добавить("ИмяОбъекта",                     ОписаниеТипаСтрока);
	ТаблицаРезультат.Колонки.Добавить("ТипОбъектаСтрокой",              ОписаниеТипаСтрока);
	ТаблицаРезультат.Колонки.Добавить("ИмяПланаОбмена",                 ОписаниеТипаСтрока);
	ТаблицаРезультат.Колонки.Добавить("ИмяТабличнойЧасти",              ОписаниеТипаСтрока);
	ТаблицаРезультат.Колонки.Добавить("РеквизитыРегистрации",           ОписаниеТипаСтрока);
	ТаблицаРезультат.Колонки.Добавить("СтруктураРеквизитовРегистрации", ОписаниеТипаСтруктура);
	
	ТаблицаРезультат.Индексы.Добавить("ИмяОбъекта, ТипОбъектаСтрокой, ИмяПланаОбмена, ИмяТабличнойЧасти");
	
	Возврат ТаблицаРезультат;
	
КонецФункции

Функция НовыеПараметрыВыборочнойРегистрацииДанныхПланаОбмена(ИмяПланаОбмена) Экспорт
	
	Если ОбменДаннымиПовтИсп.ЭтоПланОбменаРаспределеннойИнформационнойБазы(ИмяПланаОбмена) Тогда
		
		Возврат Новый Структура;
		
	КонецЕсли;
	
	ПараметрыВыборочнойРегистрации = Новый Структура;
	ПараметрыВыборочнойРегистрации.Вставить("ЭтоПланОбменаXDTO", Ложь);
	ПараметрыВыборочнойРегистрации.Вставить("ТаблицаРеквизитовРегистрации", Неопределено);
	
	ПередФормированиемНовыхПараметровВыборочнойРегистрацииОбъектов(ПараметрыВыборочнойРегистрации, ИмяПланаОбмена);
	
	Возврат ПараметрыВыборочнойРегистрации;
	
КонецФункции

Функция ОбъектМодифицированДляПланаОбмена(Источник, ОбъектМетаданных, ИмяПланаОбмена, РежимЗаписи, ЗарегистрироватьОбъектКВыгрузке) Экспорт
	
	Попытка
		
		ОбъектМодифицирован = ОбъектМодифицирован(Источник, ОбъектМетаданных, ИмяПланаОбмена, РежимЗаписи, ЗарегистрироватьОбъектКВыгрузке);
		
	Исключение
		
		СтрокаШаблона = НСтр("ru = 'Ошибка определения модифицированности объекта: %1'", ОбщегоНазначения.КодОсновногоЯзыка());
		ВызватьИсключение СтрШаблон(СтрокаШаблона, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
	Возврат ОбъектМодифицирован;
	
КонецФункции

Функция ОпределитьИзмененияВерсийОбъекта(Объект, СтрокаТаблицыРеквизитовРегистрации) Экспорт
	
	Если ПустаяСтрока(СтрокаТаблицыРеквизитовРегистрации.ИмяТабличнойЧасти) Тогда // реквизиты Шапки объекта
		
		ТаблицаРеквизитовРегистрацииВерсияОбъектаДоИзменения = РеквизитыРегистрацииШапкиДоИзменения(Объект, СтрокаТаблицыРеквизитовРегистрации);
		
		ТаблицаРеквизитовРегистрацииВерсияОбъектаПослеИзменения = РеквизитыРегистрацииШапкиПослеИзменения(Объект, СтрокаТаблицыРеквизитовРегистрации);
		
	Иначе // реквизиты ТЧ объекта
		
		// Проверка, что это ТЧ объекта, а не таблица регистра.
		Если Объект.Метаданные().ТабличныеЧасти.Найти(СтрокаТаблицыРеквизитовРегистрации.ИмяТабличнойЧасти) = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
		
		ТаблицаРеквизитовРегистрацииВерсияОбъектаДоИзменения = РеквизитыРегистрацииТабличнойЧастиДоИзменения(Объект, СтрокаТаблицыРеквизитовРегистрации);
		
		ТаблицаРеквизитовРегистрацииВерсияОбъектаПослеИзменения = РеквизитыРегистрацииТабличнойЧастиПослеИзменения(Объект, СтрокаТаблицыРеквизитовРегистрации);
		
	КонецЕсли;
	
	Возврат Не ТаблицыРеквизитовРегистрацииОдинаковые(ТаблицаРеквизитовРегистрацииВерсияОбъектаДоИзменения, ТаблицаРеквизитовРегистрацииВерсияОбъектаПослеИзменения, СтрокаТаблицыРеквизитовРегистрации);
	
КонецФункции

#КонецОбласти

Функция ИмяСобытияПравилаРегистрации() Экспорт
	
	Возврат НСтр("ru = 'Обмен данными.Правила регистрации объектов'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ВыборочнаяРегистрацияДанных

Функция ЗначениеМодифицированностиИзПКС(Источник, ИмяПланаОбмена, ОбъектМетаданных, ТаблицаРеквизитовРегистрации)
	
	Если ТипЗнч(ТаблицаРеквизитовРегистрации) <> Тип("ТаблицаЗначений") Тогда
		
		// Если нет таблицы реквизитов выборочной регистрации, то считаем, что фильтра нет
		Возврат Истина;
		
	КонецЕсли;
	
	ИмяОбъекта = ОбъектМетаданных.ПолноеИмя();
	
	РеквизитыВыборочнойРегистрацииОбъекта = РеквизитыВыборочнойРегистрацииОбъекта(ТаблицаРеквизитовРегистрации, ИмяОбъекта, ИмяПланаОбмена);
	Если РеквизитыВыборочнойРегистрацииОбъекта.Количество() = 0 Тогда
		
		// Если в таблице нет строк с реквизитами, которые описывают правила ВРО, то считаем, что фильтра нет,
		// объект модифицирован всегда.
		Возврат Истина;
		
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из РеквизитыВыборочнойРегистрацииОбъекта Цикл
		
		ЕстьИзмененияВерсийОбъектов = ОпределитьИзмененияВерсийОбъекта(Источник, СтрокаТаблицы);
		Если ЕстьИзмененияВерсийОбъектов Тогда
			
			Возврат Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Если дошли до конца, то объект не изменился по реквизитам регистрации. Регистрация на узлах не нужна.
	Возврат Ложь;
	
КонецФункции

Функция ЗначениеСвойстваМодифицированностьОбъектаИБ(Источник)
	
	Попытка
		
		Возврат Источник.Модифицированность();
		
	Исключение
		
		Возврат Истина;
		
	КонецПопытки;
	
КонецФункции

Функция ИзмененоПроведениеДокумента(Источник, РежимЗаписи)
	
	Возврат (Источник.Проведен И РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения)
	 ИЛИ (НЕ Источник.Проведен И РежимЗаписи = РежимЗаписиДокумента.Проведение);
	
КонецФункции

Функция ИнициализацияТаблицыОбщихРеквизитов()
	
	ТаблицаОбщихРеквизитов = Новый ТаблицаЗначений;
	ТаблицаОбщихРеквизитов.Колонки.Добавить("ОбщийРеквизит");
	ТаблицаОбщихРеквизитов.Колонки.Добавить("ОбъектМетаданных");
	
	ТаблицаОбщихРеквизитов.Индексы.Добавить("ОбщийРеквизит, ОбъектМетаданных");
	
	Возврат ТаблицаОбщихРеквизитов;
	
КонецФункции

Функция МетаданныеТабличнойЧастиРеквизитовРегистрацииОбъектов(МетаданныеТекущегоОбъекта, ИмяИскомойТабличнойЧасти)
	
	МетаТест = Новый Структура("ТабличныеЧасти, СтандартныеТабличныеЧасти, Движения");
	ЗаполнитьЗначенияСвойств(МетаТест, МетаданныеТекущегоОбъекта);
	МетаТаблицы = Новый Массив;
	
	ИмяКандидата = ВРег(ИмяИскомойТабличнойЧасти);
	
	Для Каждого КлючЗначение Из МетаТест Цикл
		МетаКоллекцияТаблиц = КлючЗначение.Значение; // КоллекцияОбъектовМетаданных, КоллекцияЗначенийСвойстваОбъектаМетаданных, ОписанияСтандартныхТабличныхЧастей
		Если МетаКоллекцияТаблиц <> Неопределено Тогда
			
			Для Каждого МетаТаблица Из МетаКоллекцияТаблиц Цикл
				Если ВРег(МетаТаблица.Имя) = ИмяКандидата Тогда
					МетаТаблицы.Добавить(МетаТаблица);
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
	КонецЦикла;
	Если МетаТаблицы.Количество() > 0 Тогда
		Возврат МетаТаблицы;
	КонецЕсли;

	Возврат Неопределено;
	
КонецФункции

Функция ОбъектМодифицирован(Источник, ОбъектМетаданных, ИмяПланаОбмена, РежимЗаписи, ЗарегистрироватьОбъектКВыгрузке)
	
	Если ЗарегистрироватьОбъектКВыгрузке
		ИЛИ Источник.ЭтоНовый()
		ИЛИ Источник.ОбменДанными.Загрузка Тогда
		
		// Регистрируем изменения всегда
		// - для наборов записей регистров,
		// - при физическом удалении объектов,
		// - для новых объектов,
		// - для объектов записанных по обмену данными.
		Возврат Истина;
		
	ИначеЕсли РежимЗаписи <> Неопределено
		И ИзмененоПроведениеДокумента(Источник, РежимЗаписи) Тогда
		
		// Если изменен признак документа "Проведен", то считаем документ измененным.
		Возврат Истина;
		
	КонецЕсли;
	
	РежимВыборочнойРегистрации = ОбменДаннымиРегистрацияПовтИсп.РежимВыборочнойРегистрацииДанныхПланаОбмена(ИмяПланаОбмена);
	Если РежимВыборочнойРегистрации = РежимВыборочнойРегистрацииОтключен() Тогда
		
		// Для плана обмена не используется выборочная регистрация
		Возврат Истина;
		
	ИначеЕсли РежимВыборочнойРегистрации = РежимВыборочнойРегистрацииМодифицированность() Тогда
		
		Возврат ЗначениеСвойстваМодифицированностьОбъектаИБ(Источник);
		
	Иначе
		
		ПараметрыВыборочнойРегистрации = ОбменДаннымиРегистрацияПовтИсп.ПараметрыВыборочнойРегистрацииПоИмениПланаОбмена(ИмяПланаОбмена);
		Если ТипЗнч(ПараметрыВыборочнойРегистрации) = Тип("Структура") Тогда
			
			Возврат ЗначениеМодифицированностиИзПКС(Источник, ИмяПланаОбмена, ОбъектМетаданных, ПараметрыВыборочнойРегистрации.ТаблицаРеквизитовРегистрации);
			
		Иначе
			
			// Сформируем новые параметры выборочной регистрации и запишем в регистр сведений.
			
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Заглушка на случай, если параметры временной регистрации есть, но в них нет обязательного поля.
	// Такого быть не должно, но если случиться, то будем считать, выборочную регистрацию пройденной.
	Возврат Истина;
	
КонецФункции

Функция РеквизитНайденВТабличнойЧастиРеквизитовРегистрацииОбъектов(МетаданныеТаблицы, ИмяИскомогоРеквизита)
	
	МетаТест = Новый Структура;
	МетаТест.Вставить("Реквизиты", Неопределено);
	МетаТест.Вставить("СтандартныеРеквизиты", Неопределено);
	МетаТест.Вставить("Измерения", Неопределено);
	МетаТест.Вставить("Ресурсы", Неопределено);
	ЗаполнитьЗначенияСвойств(МетаТест, МетаданныеТаблицы);
	
	ИмяКандидата = ВРег(ИмяИскомогоРеквизита);
	Корреспонденция = Ложь;
	Если ТипЗнч(МетаданныеТаблицы) = Тип("ОбъектМетаданных") И ОбщегоНазначения.ЭтоРегистрБухгалтерии(МетаданныеТаблицы) Тогда
		Корреспонденция = МетаданныеТаблицы.Корреспонденция;
		// Субконто Дт и Кт отсутствуют в измерениях, их не проверить.
		// Счет - стандартный реквизит без признака баланса.
		Если ИмяКандидата = "СУБКОНТОДТ" Или ИмяКандидата = "СУБКОНТОКТ"
			Или ИмяКандидата = "СЧЕТДТ" Или ИмяКандидата = "СЧЕТКТ" Тогда
			Возврат Истина;
		КонецЕсли;
		
		// Необходимо учесть планы обмена без Корреспонденции, свойства Субконто и Счет
		Если Корреспонденция = Ложь Тогда
			
			Если ИмяКандидата = "СУБКОНТО"
				Или ИмяКандидата = "СЧЕТ" Тогда
				Возврат Истина;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Для Каждого КлючЗначение Из МетаТест Цикл
		МетаКоллекцияРеквизитов = КлючЗначение.Значение; // КоллекцияОбъектовМетаданных, ОписанияСтандартныхРеквизитов
		
		Если МетаКоллекцияРеквизитов <> Неопределено Тогда
			
			Для Каждого МетаРеквизит Из МетаКоллекцияРеквизитов Цикл
				
				Если ВРег(МетаРеквизит.Имя) = ИмяКандидата Тогда
					Возврат Истина;
				КонецЕсли;
				
				Если (КлючЗначение.Ключ = "Измерения" Или КлючЗначение.Ключ = "Ресурсы") И Корреспонденция И НЕ МетаРеквизит.Балансовый Тогда
					Если ВРег(МетаРеквизит.Имя) + "ДТ" = ИмяКандидата
						Или ВРег(МетаРеквизит.Имя) + "КТ" = ИмяКандидата Тогда
						Возврат Истина;
					КонецЕсли;
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция РеквизитыВыборочнойРегистрацииОбъекта(ТаблицаРеквизитовРегистрации, ИмяОбъекта, ИмяПланаОбмена)
	
	Если ТаблицаРеквизитовРегистрации.Количество() = 0 Тогда
		
		Возврат ТаблицаРеквизитовРегистрации;
		
	КонецЕсли;
	
	Отбор = Новый Структура;
	Отбор.Вставить("ИмяПланаОбмена", ИмяПланаОбмена);
	Отбор.Вставить("ИмяОбъекта",     ИмяОбъекта);
	
	ТаблицаРеквизитовВыборочнойРегистрации = ТаблицаРеквизитовРегистрации.Скопировать(Отбор);
	ТаблицаРеквизитовВыборочнойРегистрации.Сортировать("Порядок Возр");
	
	Возврат ТаблицаРеквизитовВыборочнойРегистрации;
	
КонецФункции

Функция РеквизитыРегистрацииШапкиДоИзменения(Объект, СтрокаТаблицыРеквизитовРегистрации)
	
	ШаблонТекстаЗапроса =
	"ВЫБРАТЬ
	|	&РеквизитыРегистрации
	|ИЗ
	|	&ИмяТаблицыМетаданных КАК ТекущийОбъект
	|ГДЕ
	|	ТекущийОбъект.Ссылка = &Ссылка";
	
	ТекстЗапроса = СтрЗаменить(ШаблонТекстаЗапроса, "&РеквизитыРегистрации", СтрокаТаблицыРеквизитовРегистрации.РеквизитыРегистрации);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяТаблицыМетаданных", СтрокаТаблицыРеквизитовРегистрации.ИмяОбъекта);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция РеквизитыРегистрацииТабличнойЧастиДоИзменения(Объект, СтрокаТаблицыРеквизитовРегистрации)
	
	ШаблонТекстаЗапроса = 
	"ВЫБРАТЬ
	|	&РеквизитыРегистрации
	|ИЗ
	|	&ИмяТаблицыМетаданных КАК ТекущийОбъектИмяТабличнойЧасти
	|ГДЕ
	|	ТекущийОбъектИмяТабличнойЧасти.Ссылка = &Ссылка";
	
	СтрокаЗамены = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1.%2", СтрокаТаблицыРеквизитовРегистрации.ИмяОбъекта, СтрокаТаблицыРеквизитовРегистрации.ИмяТабличнойЧасти);
	
	ТекстЗапроса = СтрЗаменить(ШаблонТекстаЗапроса, "&РеквизитыРегистрации", СтрокаТаблицыРеквизитовРегистрации.РеквизитыРегистрации);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяТаблицыМетаданных", СтрокаЗамены);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция РеквизитыРегистрацииШапкиПослеИзменения(Объект, СтрокаТаблицыРеквизитовРегистрации)
	
	СтруктураРеквизитовРегистрации = СтрокаТаблицыРеквизитовРегистрации.СтруктураРеквизитовРегистрации;
	
	ТаблицаРеквизитовРегистрации = Новый ТаблицаЗначений;
	
	Для Каждого РеквизитРегистрации Из СтруктураРеквизитовРегистрации Цикл
		
		ТаблицаРеквизитовРегистрации.Колонки.Добавить(РеквизитРегистрации.Ключ);
		
	КонецЦикла;
	
	СтрокаТаблицы = ТаблицаРеквизитовРегистрации.Добавить();
	
	Для Каждого РеквизитРегистрации Из СтруктураРеквизитовРегистрации Цикл
		
		СтрокаТаблицы[РеквизитРегистрации.Ключ] = Объект[РеквизитРегистрации.Ключ];
		
	КонецЦикла;
	
	Возврат ТаблицаРеквизитовРегистрации;
КонецФункции

Функция РеквизитыРегистрацииТабличнойЧастиПослеИзменения(Объект, СтрокаТаблицыРеквизитовРегистрации)
	
	ТаблицаРеквизитовРегистрации = Объект[СтрокаТаблицыРеквизитовРегистрации.ИмяТабличнойЧасти].Выгрузить(, СтрокаТаблицыРеквизитовРегистрации.РеквизитыРегистрации);
	
	Возврат ТаблицаРеквизитовРегистрации;
	
КонецФункции

Функция ТаблицыРеквизитовРегистрацииОдинаковые(Таблица1, Таблица2, СтрокаТаблицыРеквизитовРегистрации)
	
	Таблица1.Колонки.Добавить("ИтераторТаблицыРеквизитовРегистрации");
	Таблица1.ЗаполнитьЗначения(+1, "ИтераторТаблицыРеквизитовРегистрации");
	
	Таблица2.Колонки.Добавить("ИтераторТаблицыРеквизитовРегистрации");
	Таблица2.ЗаполнитьЗначения(-1, "ИтераторТаблицыРеквизитовРегистрации");
	
	ТаблицаРезультат = Таблица1.Скопировать();
	
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(Таблица2, ТаблицаРезультат);
	
	ТаблицаРезультат.Свернуть(СтрокаТаблицыРеквизитовРегистрации.РеквизитыРегистрации, "ИтераторТаблицыРеквизитовРегистрации");
	
	КоличествоОдинаковыхСтрок = ТаблицаРезультат.НайтиСтроки(Новый Структура ("ИтераторТаблицыРеквизитовРегистрации", 0)).Количество();
	
	КоличествоСтрокТаблицы = ТаблицаРезультат.Количество();
	
	Возврат КоличествоОдинаковыхСтрок = КоличествоСтрокТаблицы;
	
КонецФункции

Функция ЭтоОбщийРеквизит(ОбщийРеквизит, ИмяОМД, ТаблицаОбщихРеквизитов)
	
	ПараметрыПоиска = Новый Структура("ОбщийРеквизит, ОбъектМетаданных", ОбщийРеквизит, ИмяОМД);
	НайденныеЗначения = ТаблицаОбщихРеквизитов.НайтиСтроки(ПараметрыПоиска);
	
	Если НайденныеЗначения.Количество() > 0 Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Процедура ВыполнитьПроверкуРеквизитовРегистрацииОбъектов(ТаблицаРеквизитовРегистрации)
	
	Для Каждого СтрокаТаблицы Из ТаблицаРеквизитовРегистрации Цикл
		
		Попытка
			ТипОбъекта = Тип(СтрокаТаблицы.ТипОбъектаСтрокой);
		Исключение
			
			СтрокаСообщения = НСтр("ru = 'Тип объекта не определен: %1'", ОбщегоНазначения.КодОсновногоЯзыка());
			СтрокаСообщения = СтрШаблон(СтрокаСообщения, СтрокаТаблицы.ТипОбъектаСтрокой);
			ЗаписатьВПротоколВыполнения(СтрокаСообщения);
			Продолжить;
			
		КонецПопытки;
		
		ОбъектМД = Метаданные.НайтиПоТипу(ТипОбъекта);
		
		// Проверку выполняем только для ссылочных типов.
		Если Не ОбщегоНазначения.ЭтоОбъектСсылочногоТипа(ОбъектМД) Тогда
			Продолжить;
		КонецЕсли;
		
		ТаблицаОбщихРеквизитов = ИнициализацияТаблицыОбщихРеквизитов();
		ЗаполнитьТаблицуОбщихРеквизитов(ТаблицаОбщихРеквизитов);
		
		Если ПустаяСтрока(СтрокаТаблицы.ИмяТабличнойЧасти) Тогда // реквизиты шапки
			
			Для Каждого Реквизит Из СтрокаТаблицы.СтруктураРеквизитовРегистрации Цикл
				
				Если ОбщегоНазначения.ЭтоЗадача(ОбъектМД) Тогда
					
					Если Не (ОбъектМД.Реквизиты.Найти(Реквизит.Ключ) <> Неопределено
						Или  ОбъектМД.РеквизитыАдресации.Найти(Реквизит.Ключ) <> Неопределено
						Или  ОбменДаннымиСервер.ЭтоСтандартныйРеквизит(ОбъектМД.СтандартныеРеквизиты, Реквизит.Ключ)
						Или  ЭтоОбщийРеквизит(Реквизит.Ключ, ОбъектМД.ПолноеИмя(), ТаблицаОбщихРеквизитов)) Тогда
						
						СтрокаСообщения = НСтр("ru = 'Неправильно указаны реквизиты шапки объекта ""%1"". Реквизит ""%2"" не существует.'");
						СтрокаСообщения = СтрШаблон(СтрокаСообщения, Строка(ОбъектМД), Реквизит.Ключ);
						ЗаписатьВПротоколВыполнения(СтрокаСообщения);
						
					КонецЕсли;
					
				ИначеЕсли ОбщегоНазначения.ЭтоПланСчетов(ОбъектМД) Тогда
					
					Если Не (ОбъектМД.Реквизиты.Найти(Реквизит.Ключ) <> Неопределено
						Или  ОбъектМД.ПризнакиУчета.Найти(Реквизит.Ключ) <> Неопределено
						Или  ОбменДаннымиСервер.ЭтоСтандартныйРеквизит(ОбъектМД.СтандартныеРеквизиты, Реквизит.Ключ)
						Или  ЭтоОбщийРеквизит(Реквизит.Ключ, ОбъектМД.ПолноеИмя(), ТаблицаОбщихРеквизитов)) Тогда
						
						СтрокаСообщения = НСтр("ru = 'Неправильно указаны реквизиты шапки объекта ""%1"". Реквизит ""%2"" не существует.'");
						СтрокаСообщения = СтрШаблон(СтрокаСообщения, Строка(ОбъектМД), Реквизит.Ключ);
						ЗаписатьВПротоколВыполнения(СтрокаСообщения);
						
					КонецЕсли;
					
				Иначе
					
					Если Не (ОбъектМД.Реквизиты.Найти(Реквизит.Ключ) <> Неопределено
						Или  ОбменДаннымиСервер.ЭтоСтандартныйРеквизит(ОбъектМД.СтандартныеРеквизиты, Реквизит.Ключ)
						Или  ЭтоОбщийРеквизит(Реквизит.Ключ, ОбъектМД.ПолноеИмя(), ТаблицаОбщихРеквизитов)) Тогда
						
						СтрокаСообщения = НСтр("ru = 'Неправильно указаны реквизиты шапки объекта ""%1"". Реквизит ""%2"" не существует.'");
						СтрокаСообщения = СтрШаблон(СтрокаСообщения, Строка(ОбъектМД), Реквизит.Ключ);
						ЗаписатьВПротоколВыполнения(СтрокаСообщения);
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЦикла;
			
		Иначе
			
			// Табличная часть, стандартная табличная часть, движения.
			МетаТаблицы = МетаданныеТабличнойЧастиРеквизитовРегистрацииОбъектов(ОбъектМД, СтрокаТаблицы.ИмяТабличнойЧасти);
			Если МетаТаблицы = Неопределено Тогда
				
				СтрокаСообщения = НСтр("ru = 'Табличная часть (стандартная табличная часть, движения) ""%1"" объекта ""%2"" не существует.'");
				ЗаписатьВПротоколВыполнения(СтрШаблон(СтрокаСообщения, СтрокаТаблицы.ИмяТабличнойЧасти, ОбъектМД));
				Продолжить;
				
			КонецЕсли;
			
			// Пробуем найти каждый реквизит хоть где-нибудь.
			Для Каждого Реквизит Из СтрокаТаблицы.СтруктураРеквизитовРегистрации Цикл
				
				РеквизитНайден = Ложь;
				Для Каждого МетаТаблица Из МетаТаблицы Цикл
					РеквизитНайден = РеквизитНайденВТабличнойЧастиРеквизитовРегистрацииОбъектов(МетаТаблица, Реквизит.Ключ);
					Если РеквизитНайден Тогда
						Прервать;
					КонецЕсли;
				КонецЦикла;
				
				Если Не РеквизитНайден Тогда
					
					СтрокаСообщения = НСтр("ru = 'Реквизит ""%3"" не существует в табличной части (стандартной табличной части, движениях) ""%1"" объекта ""%2"".'");
					ЗаписатьВПротоколВыполнения(СтрШаблон(СтрокаСообщения, СтрокаТаблицы.ИмяТабличнойЧасти, ОбъектМД, Реквизит.Ключ));
					Прервать;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДополнитьТаблицуРеквизитовРегистрации(МассивСтрок, ТаблицаРеквизитовРегистрации)
	
	СтрокаТаблицы = ТаблицаРеквизитовРегистрации.Добавить();
	
	СтруктураРезультат = Новый Структура;
	РеквизитыРегистрацииСтрокой = "";
	
	Для Каждого СтрокаТаблицыРезультат Из МассивСтрок Цикл
		
		СтруктураРеквизитовРегистрации = СтрокаТаблицыРезультат.СтруктураРеквизитовРегистрации;
		Для Каждого РеквизитРегистрации Из СтруктураРеквизитовРегистрации Цикл
			
			СтруктураРезультат.Вставить(РеквизитРегистрации.Ключ);
			РеквизитыРегистрацииСтрокой = РеквизитыРегистрацииСтрокой + РеквизитРегистрации.Ключ + ", ";
			
		КонецЦикла;
		
	КонецЦикла;
	
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(РеквизитыРегистрацииСтрокой, 2);
	
	СтрокаТаблицы.Порядок                        = МассивСтрок[0].Порядок;
	СтрокаТаблицы.ИмяОбъекта                     = МассивСтрок[0].ИмяОбъекта;
	СтрокаТаблицы.ТипОбъектаСтрокой              = МассивСтрок[0].ТипОбъектаСтрокой;
	СтрокаТаблицы.ИмяТабличнойЧасти              = МассивСтрок[0].ИмяТабличнойЧасти;
	СтрокаТаблицы.СтруктураРеквизитовРегистрации = СтруктураРезультат;
	СтрокаТаблицы.РеквизитыРегистрации           = РеквизитыРегистрацииСтрокой;
	
КонецПроцедуры

Процедура ДобавитьСтрокуТаблицыВыборочнойРегистрации(ТипОбъектаСтрокой, ИмяОбъекта, ИмяТабличнойЧасти, Порядок, ТаблицаСвойств, ТаблицаРезультат)
	
	СтруктураРеквизитовРегистрации = Новый Структура;
	
	МассивСтрокПКС = ТаблицаСвойств.НайтиСтроки(Новый Структура("ЭтоГруппа", Ложь));
	Для Каждого ПКС Из МассивСтрокПКС Цикл
		
		ИсточникПКС = ПКС.Источник;
		
		// Проверка на недопустимые символы в строке.
		Если ПустаяСтрока(ИсточникПКС)
			Или Лев(ИсточникПКС, 1) = "{" Тогда
			
			Продолжить;
		КонецЕсли;
		
		Попытка
			СтруктураРеквизитовРегистрации.Вставить(ИсточникПКС);
		Исключение
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен данными.Загрузка правил конвертации'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,,, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
	КонецЦикла;
	
	СтрокаТаблицыРезультат = ТаблицаРезультат.Добавить();
	
	СтрокаТаблицыРезультат.Порядок                        = Порядок;
	СтрокаТаблицыРезультат.ИмяОбъекта                     = ИмяОбъекта;
	СтрокаТаблицыРезультат.ТипОбъектаСтрокой              = ТипОбъектаСтрокой;
	СтрокаТаблицыРезультат.ИмяТабличнойЧасти              = ИмяТабличнойЧасти;
	СтрокаТаблицыРезультат.СтруктураРеквизитовРегистрации = СтруктураРеквизитовРегистрации; 
	
КонецПроцедуры

Процедура ЗаписатьВПротоколВыполнения(ТекстОшибки)
	
	ОбработкаОбъект = Обработки.КонвертацияОбъектовИнформационныхБаз.Создать();
	ОбработкаОбъект.ЗаписатьВПротоколВыполнения(ТекстОшибки);
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыВыборочнойРегистрацииПоКоллекцииПКО(ПараметрыВыборочнойРегистрации, ИмяПланаОбмена, ТаблицаПравилКонвертации)
	
	Если ТаблицаПравилКонвертации.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТаблицаРеквизитовРегистрации = ИнициализацияТаблицыПравилВыборочнойРегистрацииОбъектов();
	ТаблицаРезультат             = ИнициализацияТаблицыПравилВыборочнойРегистрацииОбъектов();
	
	Для каждого ПКО Из ТаблицаПравилКонвертации Цикл
		
		ЗаполнитьТаблицуРеквизитовРегистрацииОбъектовПоПравилу(ПКО, ТаблицаРезультат);
		
	КонецЦикла;
		
	ТаблицаРезультатГруппировка = ТаблицаРезультат.Скопировать();
	ТаблицаРезультатГруппировка.Свернуть("ИмяОбъекта, ИмяТабличнойЧасти");
	
	// Получаем итоговую таблицу с учетом сгруппированных строк предварительной таблицы.
	Для Каждого СтрокаТаблицы Из ТаблицаРезультатГруппировка Цикл
		
		Отбор = Новый Структура("ИмяОбъекта, ИмяТабличнойЧасти", СтрокаТаблицы.ИмяОбъекта, СтрокаТаблицы.ИмяТабличнойЧасти);
		МассивСтрокТаблицыРезультат = ТаблицаРезультат.НайтиСтроки(Отбор);
		ДополнитьТаблицуРеквизитовРегистрации(МассивСтрокТаблицыРезультат, ТаблицаРеквизитовРегистрации);
		
	КонецЦикла;
	
	УдалитьСтрокиСОшибкамиТаблицыРеквизитовРегистрации(ТаблицаРеквизитовРегистрации);
	ВыполнитьПроверкуРеквизитовРегистрацииОбъектов(ТаблицаРеквизитовРегистрации);
	
	// Колонка ИмяПланаОбмена сохранена для обратной совместимости
	ТаблицаРеквизитовРегистрации.ЗаполнитьЗначения(ИмяПланаОбмена, "ИмяПланаОбмена");
	
	ПараметрыВыборочнойРегистрации.ТаблицаРеквизитовРегистрации = ТаблицаРеквизитовРегистрации;
	
КонецПроцедуры

Процедура ЗаполнитьТаблицуРеквизитовРегистрацииОбъектовПоПравилу(ПКО, ТаблицаРезультат)
	
	ИмяОбъекта        = СтрЗаменить(ПКО.ТипИсточника, "Ссылка", "");
	ТипОбъектаСтрокой = ПКО.ТипИсточника;
	
	// Заполняем таблицу реквизитами шапки (свойства).
	ДобавитьСтрокуТаблицыВыборочнойРегистрации(ТипОбъектаСтрокой, ИмяОбъекта, "", -50, ПКО.Свойства, ТаблицаРезультат);
	
	// Заполняем таблицу реквизитами шапки (свойства поиска).
	ДобавитьСтрокуТаблицыВыборочнойРегистрации(ТипОбъектаСтрокой, ИмяОбъекта, "", -50, ПКО.СвойстваПоиска, ТаблицаРезультат);
	
	// Заполняем таблицу реквизитами шапки (свойства отключенные).
	ДобавитьСтрокуТаблицыВыборочнойРегистрации(ТипОбъектаСтрокой, ИмяОбъекта, "", -50, ПКО.СвойстваОтключенные, ТаблицаРезультат);
	
	// табличные части правила
	МассивПКГС = ПКО.Свойства.НайтиСтроки(Новый Структура("ЭтоГруппа", Истина));
	
	Для Каждого ПКГС Из МассивПКГС Цикл
		
		// Заполняем таблицу реквизитами табличной части.
		ДобавитьСтрокуТаблицыВыборочнойРегистрации(ТипОбъектаСтрокой, ИмяОбъекта, ПКГС.Источник, ПКГС.Порядок, ПКГС.ПравилаГруппы, ТаблицаРезультат);
		
		// Заполняем таблицу реквизитами табличной части (отключенные).
		ДобавитьСтрокуТаблицыВыборочнойРегистрации(ТипОбъектаСтрокой, ИмяОбъекта, ПКГС.Источник, ПКГС.Порядок, ПКГС.ПравилаГруппыОтключенные, ТаблицаРезультат);
		
	КонецЦикла;
	
	// Табличные части правила (отключенные).
	МассивПКГС = ПКО.СвойстваОтключенные.НайтиСтроки(Новый Структура("ЭтоГруппа", Истина));
	
	Для Каждого ПКГС Из МассивПКГС Цикл
		
		// Заполняем таблицу реквизитами табличной части.
		ДобавитьСтрокуТаблицыВыборочнойРегистрации(ТипОбъектаСтрокой, ИмяОбъекта, ПКГС.Источник, ПКГС.Порядок, ПКГС.ПравилаГруппы, ТаблицаРезультат);
		
		// Заполняем таблицу реквизитами табличной части (отключенные).
		ДобавитьСтрокуТаблицыВыборочнойРегистрации(ТипОбъектаСтрокой, ИмяОбъекта, ПКГС.Источник, ПКГС.Порядок, ПКГС.ПравилаГруппыОтключенные, ТаблицаРезультат);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьТаблицуОбщихРеквизитов(ТаблицаОбщихРеквизитов)
	
	Если Метаданные.ОбщиеРеквизиты.Количество() <> 0 Тогда
		
		АвтоиспользованиеОбщегоРеквизита = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Авто;
		ИспользованиеОбщегоРеквизита = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Использовать;
		
		Для Каждого ОбщийРеквизит Из Метаданные.ОбщиеРеквизиты Цикл
			
			Если ОбщийРеквизит.ИспользованиеРазделенияДанных = Неопределено Тогда
				
				Автоиспользование = (ОбщийРеквизит.Автоиспользование = Метаданные.СвойстваОбъектов.АвтоИспользованиеОбщегоРеквизита.Использовать);
				
				Для Каждого Элемент Из ОбщийРеквизит.Состав Цикл
					
					Если Элемент.Использование = ИспользованиеОбщегоРеквизита
						Или (Элемент.Использование = АвтоиспользованиеОбщегоРеквизита И Автоиспользование) Тогда
						
						НоваяСтрока = ТаблицаОбщихРеквизитов.Добавить();
						НоваяСтрока.ОбщийРеквизит = ОбщийРеквизит.Имя;
						НоваяСтрока.ОбъектМетаданных = Элемент.Метаданные.ПолноеИмя();
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередФормированиемНовыхПараметровВыборочнойРегистрацииОбъектов(ПараметрыВыборочнойРегистрации, ИмяПланаОбмена)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбменДаннымиСервер.ЭтоПланОбменаXDTO(ИмяПланаОбмена) Тогда
		
		ПараметрыВыборочнойРегистрации.ЭтоПланОбменаXDTO = Истина;
		
	Иначе
		
		ПараметрыВыборочнойРегистрации.ЭтоПланОбменаXDTO = Ложь;
		
		РежимВыборочнойРегистрации = ОбменДаннымиРегистрацияПовтИсп.РежимВыборочнойРегистрацииДанныхПланаОбмена(ИмяПланаОбмена);
		
		// Обход правил конвертации и заполнение параметра "ТаблицаРеквизитовРегистрации" необходим только в том случае,
		// если в настройках плана обмена установлен режим выборочной регистрации "СогласноПравиламXML".
		Если РежимВыборочнойРегистрации = РежимВыборочнойРегистрацииСогласноПравиламXML() Тогда
			
			ПравилаЗачитанные = РегистрыСведений.ПравилаДляОбменаДанными.ЗачитанныеПравилаКонвертацииОбъектов(ИмяПланаОбмена);
			Если ТипЗнч(ПравилаЗачитанные) = Тип("ХранилищеЗначения") Тогда
				
				СтруктураЗачитанныхПравил = ПравилаЗачитанные.Получить();
				Если СтруктураЗачитанныхПравил.Свойство("ТаблицаПравилКонвертации")
					И ТипЗнч(СтруктураЗачитанныхПравил.ТаблицаПравилКонвертации) = Тип("ТаблицаЗначений") Тогда
					
					ЗаполнитьРеквизитыВыборочнойРегистрацииПоКоллекцииПКО(ПараметрыВыборочнойРегистрации, ИмяПланаОбмена, СтруктураЗачитанныхПравил.ТаблицаПравилКонвертации);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьСтрокиСОшибкамиТаблицыРеквизитовРегистрации(ТаблицаРеквизитовРегистрации)
	
	КоличествоЭлементовКоллекции = ТаблицаРеквизитовРегистрации.Количество();
	
	Для ОбратныйИндекс = 1 По КоличествоЭлементовКоллекции Цикл
		
		СтрокаТаблицы = ТаблицаРеквизитовРегистрации[КоличествоЭлементовКоллекции - ОбратныйИндекс];
		
		// Если нет реквизитов регистрации, то удаляем строку.
		Если ПустаяСтрока(СтрокаТаблицы.РеквизитыРегистрации) Тогда
			
			ТаблицаРеквизитовРегистрации.Удалить(СтрокаТаблицы);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
