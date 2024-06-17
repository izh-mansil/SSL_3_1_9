#Если МобильныйАвтономныйСервер Тогда
#Область СлужебныеПроцедурыИФункции

// Возвращаемое значение:
//	Структура:
//		* Принято - Число - ПринятоЗаписей .
//		* Отправлено - Число - ОтправленоЗаписей .
//
Функция ПринятоОтправленоНовыхЗаписей() Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("Принято", Константы._ДемоПринятоЗаписей.Получить());
	Результат.Вставить("Отправлено", Константы._ДемоОтправленоЗаписей.Получить());
	Возврат Результат;
	
КонецФункции

// Процедура выполняет синхронизацию данных с основной базой. через опубликованный ею веб-сервис
Процедура ВыполнитьОбменДанными() Экспорт
	
	НаименованиеУзла = НСтр("ru='Автономный узел'");
	
	ЦентральныйУзелОбмена = ПланыОбмена._ДемоМобильныйКлиент.НайтиПоКоду("001");
	Если ЦентральныйУзелОбмена.Пустая() Тогда
		
		НовыйУзел = ПланыОбмена._ДемоМобильныйКлиент.СоздатьУзел();
		НовыйУзел.Код = "001";
		НовыйУзел.Наименование = НСтр("ru='Центральный'");
		НовыйУзел.Записать();
		ЦентральныйУзелОбмена = НовыйУзел.Ссылка;
		
	КонецЕсли;
	
	Узел = ПланыОбмена._ДемоМобильныйКлиент.ЭтотУзел();
	// Инициализируем обмен, проверяем, есть ли нужный узел в плане обмена.
	КодУзла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Узел, "Код");
	СвойстваЦентральногоУзла = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЦентральныйУзелОбмена, "НомерПринятого,НомерОтправленного");
	НовыйКод = ОсновнойСервер._ДемоОбменМобильныйКлиентВызовСервера.НачатьСинхронизацию(КодУзла, НаименованиеУзла,
		СвойстваЦентральногоУзла.НомерПринятого, СвойстваЦентральногоУзла.НомерОтправленного);
	
	Если КодУзла <> НовыйКод Тогда

		НачатьТранзакцию();

		Попытка
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("ПланОбмена._ДемоМобильныйКлиент");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Узел);
			Блокировка.Заблокировать();

			ОбъектУзла = Узел.ПолучитьОбъект();
			ОбъектУзла.Код = НовыйКод;
			ОбъектУзла.Наименование = НаименованиеУзла;
			ОбъектУзла.Записать();
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось обновить код узла мобильной конфигурации по причине: 
				 |%1'"), ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ВызватьИсключение ТекстСообщения;
		КонецПопытки;

	КонецЕсли;

	Константы._ДемоОтправленоЗаписей.Установить(0);
	Константы._ДемоПринятоЗаписей.Установить(0);
	ДанныеОбмена = _ДемоОбменМобильныйКлиент.СформироватьПакетОбмена(ЦентральныйУзелОбмена);
	ДанныеОбмена = ОсновнойСервер._ДемоОбменМобильныйКлиентВызовСервера.ВыполнитьОбменДанными(КодУзла, ДанныеОбмена);
	_ДемоОбменМобильныйКлиент.ПринятьПакетОбмена(ЦентральныйУзелОбмена, ДанныеОбмена);

КонецПроцедуры

// Функция проверки завершенности фонового задания.
// Анализирует состояние фонового задания и информацию о возникших ошибках.
//
// Параметры:
//  Идентификатор - УникальныйИдентификатор - идентификатор фонового задания.
//  ТекстОшибки - Строка - параметр для возврата информации об ошибках.
//
// Возвращаемое значение:
//  Булево - Истина, если задание завершено
//
Функция ОбменДаннымиЗакончен(Знач Идентификатор, ТекстОшибки) Экспорт
	
	ТекстОшибки = "";
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
	Если Задание = Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	Если Задание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		Возврат Ложь;
	КонецЕсли;
	Если Задание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
		ТекстОшибки = Задание.ИнформацияОбОшибке.Описание;
	КонецЕсли;
	Возврат Истина;
	
КонецФункции

// Функция запускает фоновое задание для синхронизации данных.
//
// Возвращаемое значение:
//  УникальныйИдентификатор
//
Функция ВыполнитьОбменДаннымиВФоне() Экспорт
	
	Задание = ФоновыеЗадания.Выполнить("_ДемоОбменМобильныйКлиентАвтономныйВызовСервера.ВыполнитьОбменДанными",,, "Синхронизация");
	Возврат Задание.УникальныйИдентификатор;
	
КонецФункции

#КонецОбласти
#КонецЕсли

