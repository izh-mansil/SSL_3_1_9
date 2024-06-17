///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

//@skip-check data-exchange-load
Процедура ПередЗаписью(Отказ, Замещение)
	
	КоличествоЗаписей = Количество();
	
	Для Сч = 1 По КоличествоЗаписей Цикл
		
		Индекс = КоличествоЗаписей - Сч;
		
		Если Не ЗначениеЗаполнено(ЭтотОбъект[Индекс].Ссылка) Тогда
			Удалить(Индекс);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли