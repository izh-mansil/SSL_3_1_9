///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет макеты печатных форм, в которых поддерживается перевод на другие языки.
// 
// Параметры:
//  Макеты - Массив из ОбъектМетаданныхМакет
//
Процедура ПриОпределенииДоступныхДляПереводаМакетов(Макеты) Экспорт
	
	// _Демо начало примера
	Макеты.Добавить(Метаданные.Документы._ДемоСчетНаОплатуПокупателю.Макеты.ПФ_MXL_СчетЗаказ);
	// _Демо конец примера
	
КонецПроцедуры

#КонецОбласти
