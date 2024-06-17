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

	Список.Параметры.УстановитьЗначениеПараметра("ТолькоСВнешнимДоступом", Параметры.ТолькоСВнешнимДоступом);
	
	// СтандартныеПодсистемы.Пользователи
	ВнешниеПользователи.НастроитьОтображениеСпискаВнешнихПользователей(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Пользователи

КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	// СтандартныеПодсистемы.Пользователи
	ВнешниеПользователи.СписокВнешнихПользователейПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки);
	// Конец СтандартныеПодсистемы.Пользователи

КонецПроцедуры

#КонецОбласти