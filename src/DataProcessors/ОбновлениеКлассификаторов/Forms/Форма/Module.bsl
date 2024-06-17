///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница        = Элементы.ГруппаРезультатыОбновления;
		Элементы.ДекорацияОписаниеРезультата.Заголовок =
			НСтр("ru = 'Использование обработки недоступно при работе в модели сервиса.'");
		Элементы.ДекорацияКартинкаРезультат.Картинка   = БиблиотекаКартинок.Ошибка32;
		Элементы.КнопкаНазад.Видимость                 = Ложь;
		Элементы.КнопкаДалее.Видимость                 = Ложь;
	Иначе
		УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	КонецЕсли;
	
	// Загрузка из файла в веб-клиенте не возможна.
	Если ОбщегоНазначения.ЭтоВебКлиент() Тогда
		ИнформацияОДоступныхОбновленияхИзСервиса();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РежимОбновленияПриИзменении(Элемент)
	
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлОбновленияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.Фильтр = НСтр("ru = 'Архив'") + "(*.zip)|*.zip";
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ФайлОбновленияНачалоВыбораЗавершение",
		ЭтотОбъект);
	
	ФайловаяСистемаКлиент.ПоказатьДиалогВыбора(
		ОписаниеОповещения,
		ДиалогВыбораФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОписаниеРезультатаОбработкаНавигационнойСсылки(
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "action:openLog" Тогда
		СтандартнаяОбработка = Ложь;
		Отбор = Новый Структура;
		Отбор.Вставить("Уровень", "Ошибка");
		Отбор.Вставить("СобытиеЖурналаРегистрации", РаботаСКлассификаторамиКлиент.ИмяСобытияЖурналаРегистрации());
		ЖурналРегистрацииКлиент.ОткрытьЖурналРегистрации(Отбор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьПоясненияПодключенияАвторизацияОбработкаНавигационнойСсылки(
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "action:openPortal" Тогда
		СтандартнаяОбработка = Ложь;
		ИнтернетПоддержкаПользователейКлиент.ОткрытьВебСтраницу(
			ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыСервисаLogin(
				,
				ИнтернетПоддержкаПользователейКлиент.НастройкиСоединенияССерверами()));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛогинПриИзменении(Элемент)
	
	СохранитьДанныеАутентификации = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	СохранитьДанныеАутентификации = Истина;
	ИнтернетПоддержкаПользователейКлиент.ПриИзмененииСекретныхДанных(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтернетПоддержкаПользователейКлиент.ОтобразитьСекретныеДанные(
		ЭтотОбъект,
		Элемент,
		"Пароль");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДанныеКлассификаторов

&НаКлиенте
Процедура ДанныеКлассификаторовПередНачаломДобавления(
		Элемент,
		Отказ,
		Копирование,
		Родитель,
		Группа,
		Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеКлассификаторовПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	ОчиститьСообщения();
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПодключениеКПорталу Тогда
		
		Результат = ИнтернетПоддержкаПользователейКлиентСервер.ПроверитьДанныеАутентификации(
			Новый Структура("Логин, Пароль",
			Логин, Пароль));
		
		Если Результат.Отказ Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				Результат.СообщениеОбОшибке,
				,
				Результат.Поле);
		КонецЕсли;
		
		Если Результат.Отказ Тогда
			Возврат;
		КонецЕсли;
		
		ПроверитьПодключениеКПорталу1СИТС();
		
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборРежимаОбновления Тогда
		Если РежимОбновления = РежимОбновленияЧерезИнтернет() Тогда
			ИнформацияОДоступныхОбновленияхИзСервиса();
		Иначе
			ИнформацияОДоступныхОбновленияхИзФайла();
		КонецЕсли;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборКлассификаторов Тогда
		Если РежимОбновления = РежимОбновленияЧерезИнтернет() Тогда
			НачатьОбновлениеКлассификаторовСервис();
		Иначе
			НачатьОбновлениеКлассификаторовИзФайла();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборРежимаОбновления;
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	Логин  = "";
	Пароль = "";
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	УстановитьОтметку(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьОтметку(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ФайлОбновленияНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено И ВыбранныеФайлы.Количество() <> 0 Тогда
		ФайлОбновления = ВыбранныеФайлы[0];
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьПодключениеКПорталу1СИТС()
	
	ПараметрыПолучения = ПодготовитьПараметрыПолученияИнформацииОбОбновлениях();
	
	Если ПараметрыПолучения.Идентификаторы.Количество() = 0 Тогда
		УстановитьОтображениеИнформацииОбОшибке(
			ЭтотОбъект,
			НСтр("ru = 'Отсутствуют классификаторы доступные для обновления.'"),
			Ложь,
			Ложь);
		УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
	// Получение информации из сервиса классификаторов.
	РезультатОперации = РаботаСКлассификаторами.СлужебнаяДоступныеОбновленияКлассификаторов(
		ПараметрыПолучения.Идентификаторы,
		Новый Структура("Логин, Пароль",
			Логин, Пароль));
	
	Если РезультатОперации.КодОшибки = "НеверныйЛогинИлиПароль" Тогда
		ОбщегоНазначения.СообщитьПользователю(
			РезультатОперации.СообщениеОбОшибке,
			,
			"Логин");
		Возврат;
	КонецЕсли;
	
	ЗаполнитьИнформациюОДоступныхОбновлениях(
		РезультатОперации,
		ПараметрыПолучения.ВерсииКлассификаторов);
	
КонецПроцедуры

&НаСервере
Процедура ИнформацияОДоступныхОбновленияхИзСервиса()
	
	Если Не ИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки() Тогда
		СохранитьДанныеАутентификации = Истина;
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПодключениеКПорталу;
		УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
	ПараметрыПолучения = ПодготовитьПараметрыПолученияИнформацииОбОбновлениях();
	
	Если ПараметрыПолучения.Идентификаторы.Количество() = 0 Тогда
		УстановитьОтображениеИнформацииОбОшибке(
			ЭтотОбъект,
			НСтр("ru = 'Отсутствуют классификаторы доступные для обновления.'"),
			Ложь,
			Ложь);
		УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
	// Получение информации из сервиса классификаторов.
	РезультатОперации = РаботаСКлассификаторами.СлужебнаяДоступныеОбновленияКлассификаторов(
		ПараметрыПолучения.Идентификаторы,
		Неопределено);
	ЗаполнитьИнформациюОДоступныхОбновлениях(
		РезультатОперации,
		ПараметрыПолучения.ВерсииКлассификаторов);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнформациюОДоступныхОбновлениях(РезультатОперации, ВерсииКлассификаторов)
	
		// Обработка ошибок операции.
	Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
		Если РезультатОперации.КодОшибки = "НеверныйЛогинИлиПароль" Тогда
			СохранитьДанныеАутентификации = Истина;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПодключениеКПорталу;
			УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
		Иначе
			// Если авторизация прошла успешно, необходимо очистить реквизиты формы.
			Если СохранитьДанныеАутентификации Тогда
				Логин = "";
				Пароль = "";
				СохранитьДанныеАутентификации = Ложь;
			КонецЕсли;
			УстановитьОтображениеИнформацииОбОшибке(
				ЭтотОбъект,
				РезультатОперации.СообщениеОбОшибке);
			УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	// Если авторизация прошла успешно, необходимо очистить реквизиты формы.
	Если СохранитьДанныеАутентификации Тогда
		
		// Запись данных.
		УстановитьПривилегированныйРежим(Истина);
		ИнтернетПоддержкаПользователей.СлужебнаяСохранитьДанныеАутентификации(
			Новый Структура(
				"Логин, Пароль",
				Логин,
				Пароль));
		УстановитьПривилегированныйРежим(Ложь);
		
		Логин = "";
		Пароль = "";
		СохранитьДанныеАутентификации = Ложь;
		
	КонецЕсли;
	
	// Заполнение таблицы с обновлениями.
	Для Каждого ОписаниеКлассификатора Из ВерсииКлассификаторов Цикл
		
		Для Каждого ОписаниеВерсии Из РезультатОперации.ДоступныеВерсии Цикл
			Если ОписаниеВерсии.Идентификатор = ОписаниеКлассификатора.Идентификатор Тогда
				
				СтрокаКлассификатора = ДанныеКлассификаторов.Добавить();
				ЗаполнитьЗначенияСвойств(
					СтрокаКлассификатора,
					ОписаниеКлассификатора,
					"Идентификатор, Наименование");
				
				СтрокаКлассификатора.КонтрольнаяСумма   = ОписаниеВерсии.ИдентификаторФайла.КонтрольнаяСумма;
				СтрокаКлассификатора.ИдентификаторФайла = ОписаниеВерсии.ИдентификаторФайла.ИдентификаторФайла;
				СтрокаКлассификатора.Версия             = ОписаниеВерсии.Версия;
				СтрокаКлассификатора.ОписаниеВерсии     = ОписаниеВерсии.ОписаниеВерсии;
				СтрокаКлассификатора.Размер             = ОписаниеВерсии.Размер;
				
				Если ОписаниеКлассификатора.Версия >= ОписаниеВерсии.Версия Тогда
					СтрокаКлассификатора.Версия        = ОписаниеКлассификатора.Версия;
					СтрокаКлассификатора.Наименование = ОбновлениеНеТребуется(ОписаниеКлассификатора.Наименование);
				Иначе
					СтрокаКлассификатора.ТребуетсяОбновление = Истина;
					СтрокаКлассификатора.Отметка             = Истина;
				КонецЕсли;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Если ДанныеКлассификаторов.Количество() <> 0 Тогда
		ДанныеКлассификаторов.Сортировать("Отметка Убыв, Наименование");
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборКлассификаторов;
		УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	Иначе
		УстановитьОтображениеИнформацииОбОшибке(
			ЭтотОбъект,
			НСтр("ru = 'Не найдены доступные обновления классификаторов.'"),
			Ложь,
			Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияОДоступныхОбновленияхИзФайла()
	
	ДанныеКлассификаторов.Очистить();
	
	Если Не ЗначениеЗаполнено(ФайлОбновления) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Не выбран файл обновления.'"),
			,
			"ФайлОбновления");
		Возврат;
	КонецЕсли;
	
	КомпонентыПути = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ФайлОбновления);
	Если КомпонентыПути.Расширение <> ".zip" Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Неверный формат файла.'"),
			,
			"ФайлОбновления");
		Возврат;
	КонецЕсли;
	
	ВерсииКлассификаторов = РаботаСКлассификаторамиКлиент.ВерсииКлассификаторовВФайле(
		ФайлОбновления);
	ИнформацияОДоступныхОбновленияхИзФайлаНаСервере(ВерсииКлассификаторов);
	
	Если ДанныеКлассификаторов.Количество() <> 0 Тогда
		ДанныеКлассификаторов.Сортировать("Отметка Убыв, Наименование");
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборКлассификаторов;
		УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	Иначе
		УстановитьОтображениеИнформацииОбОшибке(
			ЭтотОбъект,
			НСтр("ru = 'Не найдены доступные обновления классификаторов.'"),
			Ложь,
			Ложь);
	КонецЕсли;
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ИнформацияОДоступныхОбновленияхИзФайлаНаСервере(ВерсииКлассификаторов)
	
	// Начальное заполнение номера версии,
	// для новых классификаторов.
	ВерсииКлассификаторовИБ = РаботаСКлассификаторами.ДанныеКлассификаторовДляИнтерактивногоОбновления();
	Для каждого ОписаниеКлассификатора Из ВерсииКлассификаторов Цикл
		Если ОписаниеКлассификатора.Версия = 0 Тогда
			ОписаниеКлассификатора.Версия = РаботаСКлассификаторами.ОбработатьНачальнуюВерсиюКлассификатора(
				ОписаниеКлассификатора.Идентификатор);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ВерсияКлассификатора Из ВерсииКлассификаторов Цикл
		
		ТребуетсяОбновление       = Истина;
		КлассификаторИспользуется = Ложь;
		Для Каждого ВерсияКлассификатораИБ Из ВерсииКлассификаторовИБ Цикл
			Если ВерсияКлассификатораИБ.Идентификатор = ВерсияКлассификатора.Идентификатор Тогда
				КлассификаторИспользуется = Истина;
				Если ВерсияКлассификатораИБ.Версия >= ВерсияКлассификатора.Версия Тогда
					ТребуетсяОбновление = Ложь;
				КонецЕсли;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если КлассификаторИспользуется Тогда
			СтрокаЗагрузки = ДанныеКлассификаторов.Добавить();
			СтрокаЗагрузки.Отметка             = ТребуетсяОбновление;
			Если ТребуетсяОбновление Тогда
				СтрокаЗагрузки.Наименование = ВерсияКлассификатораИБ.Наименование;
			Иначе
				СтрокаЗагрузки.Наименование = ОбновлениеНеТребуется(ВерсияКлассификатораИБ.Наименование);
			КонецЕсли;
			СтрокаЗагрузки.Версия              = ВерсияКлассификатора.Версия;
			СтрокаЗагрузки.ТребуетсяОбновление = ТребуетсяОбновление;
			СтрокаЗагрузки.Идентификатор       = ВерсияКлассификатора.Идентификатор;
			СтрокаЗагрузки.ИдентификаторФайла  = ВерсияКлассификатора.Имя;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьОбновлениеКлассификаторовИзФайлаПослеЗагрузки(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныеФайлы = Неопределено Или ПомещенныеФайлы.Количество() = 0 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Файл с обновлениями не загружен.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания           = Ложь;
	
	РезультатВыполнения = ИнтерактивноеОбновлениеКлассификаторовИзФайла(
		ПомещенныеФайлы[0].Хранение);
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"НачатьОбновлениеКлассификаторовЗавершение",
		ЭтотОбъект);
		
	Если РезультатВыполнения.Статус = "Выполнено" Или РезультатВыполнения.Статус = "Ошибка" Тогда
		НачатьОбновлениеКлассификаторовЗавершение(РезультатВыполнения, Неопределено);
		Возврат;
	КонецЕсли;
	
	// Настройка страницы длительной операции.
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация;
	Элементы.ИндикаторОбновления.Видимость  = Ложь;
	Элементы.ДекорацияСостояние.Заголовок   = НСтр("ru = 'Обработка файлов классификатора на сервере.'");
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения,
		ОповещениеОЗавершении,
		ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция ИнтерактивноеОбновлениеКлассификаторовИзФайла(АдресФайла)
	
	Отбор = Новый Структура;
	Отбор.Вставить("Отметка", Истина);
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ДанныеФайла", ПолучитьИзВременногоХранилища(АдресФайла));
	ПараметрыПроцедуры.Вставить("ДанныеКлассификаторов", ДанныеКлассификаторов.Выгрузить(Отбор));
	УдалитьИзВременногоХранилища(АдресФайла);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ЭтотОбъект.УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Обработка файлов классификатора на сервере.'");
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"РаботаСКлассификаторами.ИнтерактивноеОбновлениеКлассификаторовИзФайла",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиенте
Процедура НачатьОбновлениеКлассификаторовСервис()
	
	ИндикаторОбновления = 0;
	ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения(
		"ОбновитьИндикаторЗагрузки",
		ЭтотОбъект);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания           = Ложь;
	ПараметрыОжидания.ОповещениеОПрогрессеВыполнения = ОповещениеОПрогрессеВыполнения;
	
	РезультатВыполнения = ИнтерактивноеОбновлениеКлассификаторовИзСервиса();
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"НачатьОбновлениеКлассификаторовЗавершение",
		ЭтотОбъект);
		
	Если РезультатВыполнения.Статус = "Выполнено" Или РезультатВыполнения.Статус = "Ошибка" Тогда
		НачатьОбновлениеКлассификаторовЗавершение(РезультатВыполнения, Неопределено);
		Возврат;
	КонецЕсли;
	
	// Настройка страницы длительной операции.
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация;
	Элементы.ИндикаторОбновления.Видимость = Истина;
	Элементы.ДекорацияСостояние.Заголовок  = НСтр("ru = 'Выполняется обновление классификаторов. Обновление может занять от
		|нескольких минут до нескольких часов в зависимости от размера обновления.'");
	
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения,
		ОповещениеОЗавершении,
		ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция ИнтерактивноеОбновлениеКлассификаторовИзСервиса()
	
	ДанныеКлассификаторовПодготовка = ДанныеКлассификаторов.Выгрузить();
	ДанныеКлассификаторовПодготовка.Колонки.Добавить("ДанныеФайла");
	СтрокиУдалить = Новый Массив;
	Для Каждого ОписаниеКлассификатора Из ДанныеКлассификаторовПодготовка Цикл
		Если Не ОписаниеКлассификатора.Отметка Тогда
			СтрокиУдалить.Добавить(ОписаниеКлассификатора);
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ОписаниеКлассификатора Из СтрокиУдалить Цикл
		ДанныеКлассификаторовПодготовка.Удалить(ОписаниеКлассификатора);
	КонецЦикла;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ДанныеКлассификаторов", ДанныеКлассификаторовПодготовка);
	ПараметрыПроцедуры.Вставить("РежимОбновления",       РежимОбновления);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Обновление данных классификаторов.'");
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"РаботаСКлассификаторами.ИнтерактивноеОбновлениеКлассификаторовИзСервиса",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиенте
Процедура НачатьОбновлениеКлассификаторовИзФайла()
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"НачатьОбновлениеКлассификаторовИзФайлаПослеЗагрузки",
		ЭтотОбъект);
	
	ОписаниеПередаваемогоФайла = Новый ОписаниеПередаваемогоФайла(ФайлОбновления);
	
	ФайлыОбновлений = Новый Массив;
	ФайлыОбновлений.Добавить(ОписаниеПередаваемогоФайла);
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.Интерактивно = Ложь;
	
	ФайловаяСистемаКлиент.ЗагрузитьФайлы(
		ОписаниеОповещения,
		ПараметрыЗагрузки,
		ФайлыОбновлений);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИндикаторЗагрузки(СтатусВыполнения, ДополнительныеПараметры) Экспорт
	
	Результат = ПрочитатьПрогресс(СтатусВыполнения.ИдентификаторЗадания);
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИндикаторОбновления = Результат.Процент;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПрочитатьПрогресс(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ПрочитатьПрогресс(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура НачатьОбновлениеКлассификаторовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		
		РезультатОперации = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
			УстановитьОтображениеИнформацииОбОшибке(
				ЭтотОбъект,
				РезультатОперации.СообщениеОбОшибке,
				Ложь,
				Ложь);
		Иначе
			УстановитьОтображениеУспешногоЗавершения(ЭтотОбъект);
		КонецЕсли;
		
		// Обновление открытых форм классификаторов.
		Идентификаторы = Новый Массив;
		Для Каждого СтрокаТаблицы Из ДанныеКлассификаторов Цикл
			Если СтрокаТаблицы.Отметка Тогда
				Идентификаторы.Добавить(СтрокаТаблицы.Идентификатор);
			КонецЕсли;
		КонецЦикла;
		
		Оповестить(
			РаботаСКлассификаторамиКлиент.ИмяСобытияОповещенияОЗагрузки(),
			Идентификаторы,
			ЭтотОбъект);
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ИнформацияОбОшибке = Результат.КраткоеПредставлениеОшибки;
		УстановитьОтображениеИнформацииОбОшибке(ЭтотОбъект, ИнформацияОбОшибке);
	КонецЕсли;
	
	УстановитьОтображениеЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеЭлементовФормы(Форма)
	
	Элементы = Форма.Элементы;
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборРежимаОбновления Тогда
		Элементы.КнопкаНазад.Видимость = Ложь;
		Элементы.КнопкаДалее.Видимость = Истина;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПодключениеКПорталу Тогда
		Элементы.КнопкаНазад.Видимость = Истина;
		Элементы.КнопкаДалее.Видимость = Истина;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВыборКлассификаторов Тогда
		Элементы.КнопкаНазад.Видимость = Истина;
		Элементы.КнопкаДалее.Видимость = Истина;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация Тогда
		Элементы.КнопкаНазад.Видимость = Ложь;
		Элементы.КнопкаДалее.Видимость = Ложь;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаРезультатыОбновления Тогда
		Элементы.КнопкаНазад.Видимость = Истина;
		Элементы.КнопкаДалее.Видимость = Ложь;
	КонецЕсли;
	
	Если Форма.РежимОбновления = 0 Тогда
		Элементы.ФайлОбновления.Доступность = Ложь;
	Иначе
		Элементы.ФайлОбновления.Доступность = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеИнформацииОбОшибке(
		Форма,
		ИнформацияОбОшибке,
		Ошибка = Истина,
		ОтображатьЖР = Истина)
	
	Если ОтображатьЖР Тогда
		ПредставлениеОшибки = ИнтернетПоддержкаПользователейКлиентСервер.ФорматированнаяСтрокаИзHTML(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1
					|
					|Подробную информацию см. в <a href = ""action:openLog"">Журнале регистрации</a>.'"),
				ИнформацияОбОшибке));
	Иначе
		ПредставлениеОшибки = ИнформацияОбОшибке;
	КонецЕсли;
	
	Форма.Элементы.ГруппаСтраницы.ТекущаяСтраница        = Форма.Элементы.ГруппаРезультатыОбновления;
	Форма.Элементы.ДекорацияОписаниеРезультата.Заголовок = ПредставлениеОшибки;
	Форма.Элементы.ДекорацияКартинкаРезультат.Картинка   = ?(
		Ошибка,
		БиблиотекаКартинок.Ошибка32,
		БиблиотекаКартинок.Предупреждение32);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеУспешногоЗавершения(Форма)
	
	Форма.Элементы.ГруппаСтраницы.ТекущаяСтраница        = Форма.Элементы.ГруппаРезультатыОбновления;
	Форма.Элементы.ДекорацияКартинкаРезультат.Картинка   = БиблиотекаКартинок.Успешно32;
	Форма.Элементы.ДекорацияОписаниеРезультата.Заголовок = НСтр("ru = 'Обновление классификаторов успешно завершено.'");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДанныеКлассификаторовВерсия.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДанныеКлассификаторовНаименование.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДанныеКлассификаторовОтметка.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДанныеКлассификаторов.ТребуетсяОбновление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра(
		"ЦветТекста",
		Метаданные.ЭлементыСтиля.ЦветНеАктивнойСтроки.Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтметку(Значение)
	
	Для Каждого СтрокаКлассификатора Из ДанныеКлассификаторов Цикл
		СтрокаКлассификатора.Отметка = Значение;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РежимОбновленияЧерезИнтернет()
	
	Возврат 0;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОбновлениеНеТребуется(Наименование)
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1 (обновление не требуется)'"),
		Наименование);
	
КонецФункции

&НаСервере
Функция ПодготовитьПараметрыПолученияИнформацииОбОбновлениях()
	
	ДанныеКлассификаторов.Очистить();
	
	ВерсииКлассификаторов = РаботаСКлассификаторами.ДанныеКлассификаторовДляИнтерактивногоОбновления();
	Идентификаторы = Новый Массив;
	
	Для Каждого ОписаниеКлассификатора Из ВерсииКлассификаторов Цикл
		Идентификаторы.Добавить(ОписаниеКлассификатора.Идентификатор);
	КонецЦикла;
	
	ПараметрыПолучения = Новый Структура;
	ПараметрыПолучения.Вставить("ВерсииКлассификаторов", ВерсииКлассификаторов);
	ПараметрыПолучения.Вставить("Идентификаторы",        Идентификаторы);
	
	Возврат ПараметрыПолучения;
	
КонецФункции

#КонецОбласти
