////////////////////////////////////////////////////////////////////////////////
// Подсистема "Удаленное администрирование".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается при завершении сеанса средствами подсистемы ЗавершениеРаботыПользователей.
//
// Параметры:
//  ФормаВладелец - ФормаКлиентскогоПриложения - из которой выполняется завершение сеанса,
//  НомераСеансов - Число - номер сеанса, который будет завершен,
//  СтандартнаяОбработка - Булево - флаг выполнения стандартной обработки завершения сеанса
//    (подключение к агенту сервера через COM-соединение или сервер администрирования с
//    запросом параметров подключения к кластеру у текущего пользователя). Может быть
//    установлен в значение Ложь внутри обработчика события, в этом случае стандартная
//    обработка завершения сеанса выполняться не будет,
//  ОповещениеПослеЗавершенияСеанса - ОписаниеОповещения - описание оповещения, которое должно
//    быть вызвано после завершения сеанса (для автоматического обновления списка активных
//    пользователей). При установке значения параметра СтандартнаяОбработка равным Ложь,
//    после успешного завершения сеанса, для переданного описания оповещения должна быть
//    выполнена обработка с помощью метода ВыполнитьОбработкуОповещения (в качестве значения
//    параметра Результат следует передавать КодВозвратаДиалога.ОК при успешном завершении
//    сеанса). Параметр может быть опущен - в этом случае выполнять обработку оповещения не
//    следует.
//
Процедура ПриЗавершенииСеансов(ФормаВладелец, Знач НомераСеансов, СтандартнаяОбработка, Знач ОповещениеПослеЗавершенияСеанса = Неопределено) Экспорт
	
	Если ОбщегоНазначенияКлиент.РазделениеВключено() Тогда
		
		Если ОбщегоНазначенияКлиент.ДоступноИспользованиеРазделенныхДанных() Тогда
			
			СтандартнаяОбработка = Ложь;
			
			ПараметрыФормы = Новый Структура();
			ПараметрыФормы.Вставить("НомераСеансов", НомераСеансов);
			
			ОписаниеОповещения = Новый ОписаниеОповещения(
				"ПослеЗавершенияСеанса", ЭтотОбъект, Новый Структура("ОписаниеОповещения", ОповещениеПослеЗавершенияСеанса));
			
			ОткрытьФорму("ОбщаяФорма.ЗавершениеСеансовВМоделиСервиса",
				ПараметрыФормы,
				ФормаВладелец,
				НомераСеансов,
				,
				,
				ОписаниеОповещения,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Вызывается после завершения сеанса. Выполняет исходное описание оповещения от формы обработки
// АктивныеПользователи для обновления списка активных пользователей после завершения сеанса.
//
// Параметры:
//  Результат - Произвольный - не анализируется в данной процедуре. Должен быть передан в исходное описание оповещения,
//  Контекст - Структура - с полями:
//   * ОписаниеОповещения - ОписаниеОповещения - исходное описание оповещения.
//
Процедура ПослеЗавершенияСеанса(Результат, Контекст) Экспорт
	
	Если Контекст.ОписаниеОповещения <> Неопределено Тогда
		
		ВыполнитьОбработкуОповещения(Контекст.ОписаниеОповещения, Результат);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

