#Область ПрограммныйИнтерфейс

// Возвращает текущую (используемую вызывающим кодом) версию интерфейса сообщений.
// @skip-warning ПустойМетод - особенность реализации.
// Возвращаемое значение:
//	Строка - 
Функция Версия() Экспорт
КонецФункции

// Возвращает пространство имен текущей (используемой вызывающим кодом) версии интерфейса сообщений.
// @skip-warning ПустойМетод - особенность реализации.
// Возвращаемое значение:
//	Строка - 
Функция Пакет() Экспорт
КонецФункции

// Возвращает название программного интерфейса сообщений.
// @skip-warning ПустойМетод - особенность реализации.
// Возвращаемое значение:
//	Строка - 
Функция ПрограммныйИнтерфейс() Экспорт
КонецФункции

// Выполняет регистрацию обработчиков сообщений в качестве обработчиков каналов обмена сообщениями.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  МассивОбработчиков - Массив - массив обработчиков.
//
Процедура ОбработчикиКаналовСообщений(Знач МассивОбработчиков) Экспорт
КонецПроцедуры

// Выполняет регистрацию обработчиков трансляции сообщений.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  МассивОбработчиков - Массив - массив обработчиков.
//
Процедура ОбработчикиТрансляцииСообщений(Знач МассивОбработчиков) Экспорт
КонецПроцедуры

#КонецОбласти