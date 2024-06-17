// @strict-types

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Основные процедуры и функции.

// Все методы доступные в API оперирует параметрами заданий. Возможность использования 
// конкретного параметра зависит от метода и, в некоторых случаях, значений других
// параметров. Подробнее об этом написано в описании конкретных методов.
// Описание параметров - см. НовыйПараметрыЗадания.

// Получает задания очереди по заданному отбору.
// Возможно получение неконсистентных данных.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  Отбор - Структура - значения, по которым требуется отбирать задания (объединяются по И). Возможные ключи структуры:
//            * ОбластьДанных - Число - область данных,
//            * ИмяМетода - Строка - имя метода,
//            * Идентификатор - УникальныйИдентификатор - идентификатор задания,
//            * СостояниеЗадания - ПеречислениеСсылка.СостоянияЗаданий - состояние задания,
//            * Ключ - Строка - ключ задания,
//            * Шаблон - СправочникСсылка.ШаблоныЗаданийОчереди - шаблон задания,
//            * Использование - Булево - использование задания.
//        - Массив Из Структура - описание:
//            * ВидСравнения - ВидСравнения - допустимыми значениями являются:
//                ВидСравнения.Равно, ВидСравнения.НеРавно - для сравнения со значением,
//                ВидСравнения.ВСписке, ВидСравнения.НеВСписке - для сравнения с массивом.
//            * Значение - Произвольный - значения сравнения  для видов сравнения Равно / НеРавно
//            			 - Массив -  для видов сравнения ВСписке и НеВСписке
//
// Возвращаемое значение:
//  ТаблицаЗначений - таблица найденных заданий. Колонки соответствуют параметрам заданий:
//	 * Идентификатор - СправочникСсылка.ОчередьЗаданий - ссылка на справочник.
//	 ...
//
Функция ПолучитьЗадания(Знач Отбор) Экспорт
КонецФункции

// Добавляет новое задание в очередь.
// В случае вызова в транзакции на задание устанавливается объектная блокировка.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры: 
//  ПараметрыЗадания - Структура - параметры добавляемого задания. Описание:
//  * ОбластьДанных - Число - номер области данных.
//  * Использование - Булево - признак использования.
//  * ЗапланированныйМоментЗапуска - Дата - момент запуска (ДатаВремя)
//  * ЭксклюзивноеВыполнение - Булево - признак эксклюзивного выполнения.
//  * ИмяМетода - Строка - имя метода для задания, обязательно для указания.
//  * Параметры - Массив - параметры метода.
//  * Ключ - Строка - ключ уникальности задания.
//  * ИнтервалПовтораПриАварийномЗавершении - Число - интервал повтора в секундах.
//  * Расписание - РасписаниеРегламентногоЗадания - расписания выполнения задания.
//  * КоличествоПовторовПриАварийномЗавершении - Число - количество повторов.
//
// Возвращаемое значение: 
//  СправочникСсылка.ОчередьЗаданий - идентификатор добавленного задания.
// 
Функция ДобавитьЗадание(ПараметрыЗадания) Экспорт
КонецФункции

// Изменяет задание с указанным идентификатором.
// В случае вызова в транзакции на задание устанавливается объектная блокировка.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры: 
//	Идентификатор - СправочникСсылка.ОчередьЗаданий - идентификатор задания.
//	ПараметрыЗадания - Структура - параметры, которые следует установить заданию, возможные ключи:
//						* Использование - Булево -
//						* ЗапланированныйМоментЗапуска - Дата -
//						* ЭксклюзивноеВыполнение - Булево - 
//						* ИмяМетода - Строка - 
//						* Параметры - Массив - 
//  					* Ключ - Строка - 
//						* ИнтервалПовтораПриАварийномЗавершении - Число - 
//						* Расписание - РасписаниеРегламентногоЗадания - 
//						* КоличествоПовторовПриАварийномЗавершении - Число - 
//   				- Структура - в случае если задание создано на основе шаблона, могут быть указаны только следующие ключи:
//						* Использование - Булево - 
//						* ЗапланированныйМоментЗапуска - Дата - 
//						* ЭксклюзивноеВыполнение - Булево - 
//						* ИнтервалПовтораПриАварийномЗавершении - Число - 
//						* Расписание - РасписаниеРегламентногоЗадания - 
//						* КоличествоПовторовПриАварийномЗавершении - Число - 
// 
Процедура ИзменитьЗадание(Идентификатор, ПараметрыЗадания) Экспорт
КонецПроцедуры

// Удаляет задание из очереди заданий.
// Удаление заданий с установленным шаблоном запрещено.
// В случае вызова в транзакции на задание устанавливается объектная блокировка.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  Идентификатор - СправочникСсылка.ОчередьЗаданий - идентификатор задания.
//
Процедура УдалитьЗадание(Идентификатор) Экспорт
КонецПроцедуры

// Возвращает шаблон задания очереди по имени предопределенного регламентного задания из которого он создан.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  Имя - Строка - имя предопределенного регламентного задания.
//
// Возвращаемое значение:
//  СправочникСсылка.ШаблоныЗаданийОчереди - шаблон задания.
//
Функция ШаблонПоИмени(Знач Имя) Экспорт
КонецФункции

// Возвращает текст ошибки при попытке выполнить одновременно два задания с одним ключом.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Возвращаемое значение:
//   Строка - текст исключения.
//
Функция ПолучитьТекстИсключенияДублированиеЗаданийСОдинаковымКлючом() Экспорт
КонецФункции

// Возвращает список шаблонов заданий очереди.
// @skip-warning ПустойМетод - особенность реализации.
//
// Возвращаемое значение:
//  Массив Из Строка - имена предопределенных неразделенных регламентных заданий, которые используются 
//           в качестве шаблонов для заданий очереди.
//
//
Функция ШаблоныЗаданийОчереди() Экспорт
КонецФункции

// Возвращает менеджер справочника ОчередьЗаданий.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Возвращаемое значение:
//	СправочникМенеджер.ОчередьЗаданий - менеджер справочника.
//
Функция СправочникОчередьЗаданий() Экспорт
КонецФункции

#КонецОбласти
