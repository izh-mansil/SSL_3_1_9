///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается после выполнения обработчика ПриОткрытии формы печати документов (ОбщаяФорма.ПечатьДокументов).
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма ОбщаяФорма.ПечатьДокументов.
//
Процедура ПечатьДокументовПослеОткрытия(Форма) Экспорт
	
КонецПроцедуры

// Вызывается из обработчика Подключаемый_ОбработкаНавигационнойСсылки формы печати документов (ОбщаяФорма.ПечатьДокументов).
// Позволяет реализовать обработчик нажатия гиперссылки, которая добавлена в форму 
// с помощью УправлениеПечатьюПереопределяемый.ПечатьДокументовПриСозданииНаСервере.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения - форма ОбщаяФорма.ПечатьДокументов.
//  Элемент              - ПолеФормы - элемент формы, вызвавший данное событие.
//  НавигационнаяСсылкаФорматированнойСтроки - Строка - значение гиперссылки форматированной строки. Передается по ссылке.
//  СтандартнаяОбработка - Булево - признак выполнения стандартной (системной) обработки события. Если установить
//                                  значение Ложь, стандартная обработка события производиться не будет.
//
Процедура ПечатьДокументовОбработкаНавигационнойСсылки(Форма, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	// _Демо начало примера
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПерейтиВСписокМакетов" Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("РегистрСведений.ПользовательскиеМакетыПечати.Форма.МакетыПечатныхФорм");
	КонецЕсли;
	// _Демо конец примера
	
КонецПроцедуры

// Вызывается из обработчика Подключаемый_ВыполнитьКоманду формы печати документов (ОбщаяФорма.ПечатьДокументов).
// Позволяет реализовать клиентскую часть обработчика команды, которая добавлена в форму 
// с помощью УправлениеПечатьюПереопределяемый.ПечатьДокументовПриСозданииНаСервере.
//
// Параметры:
//  Форма                         - ФормаКлиентскогоПриложения - форма ОбщаяФорма.ПечатьДокументов.
//  Команда                       - КомандаФормы     - выполняемая команда.
//  ПродолжитьВыполнениеНаСервере - Булево - при установке значения Истина, выполнение обработчика будет продолжено в
//                                           серверном контексте в процедуре УправлениеПечатьюПереопределяемый.ПечатьДокументовПриВыполненииКоманды.
//  ДополнительныеПараметры       - Произвольный - параметры, которые необходимо передать в серверный контекст.
//
// Пример:
//  Если Команда.Имя = "МояКоманда" Тогда
//   НастройкаПечатнойФормы = УправлениеПечатьюКлиент.НастройкаТекущейПечатнойФормы(Форма);
//   
//   ДополнительныеПараметры = Новый Структура;
//   ДополнительныеПараметры.Вставить("ИмяКоманды", Команда.Имя);
//   ДополнительныеПараметры.Вставить("ИмяРеквизитаТабличногоДокумента", НастройкаПечатнойФормы.ИмяРеквизита);
//   ДополнительныеПараметры.Вставить("НазваниеПечатнойФормы", НастройкаПечатнойФормы.Название);
//   
//   ПродолжитьВыполнениеНаСервере = Истина;
//  КонецЕсли;
//
Процедура ПечатьДокументовВыполнитьКоманду(Форма, Команда, ПродолжитьВыполнениеНаСервере, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

// Вызывается из обработчика ОбработкаОповещения формы ПечатьДокументов.
// Позволяет реализовать обработчик внешнего события в форме.
//
// Параметры:
//  Форма      - ФормаКлиентскогоПриложения - форма ОбщаяФорма.ПечатьДокументов.
//  ИмяСобытия - Строка - идентификатор оповещения.
//  Параметр   - Произвольный - произвольный параметр оповещения.
//  Источник   - Произвольный - источник события.
//
Процедура ПечатьДокументовОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
КонецПроцедуры

#КонецОбласти
