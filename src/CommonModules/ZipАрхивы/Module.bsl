#Область СлужебныйПрограммныйИнтерфейс

// Параметры:
// 	ИмяФайла - Строка
// 	
// Возвращаемое значение:
// 	Структура - Описание:
// * ИмяФайла - Строка
// * Размер - Число
// * РазмерКаталога - Число
// * Файлы - Массив Из см. ПрочитатьЗаписьКаталога
// * Поток - ФайловыйПоток
//
Функция Создать(ИмяФайла) Экспорт
	
	Инфо = Новый Файл(ИмяФайла);
	Если Инфо.Существует() Тогда
		УдалитьФайлы(ИмяФайла);
	КонецЕсли;
	
	Архив = Новый Структура;
	Архив.Вставить("ИмяФайла", ИмяФайла);
	Архив.Вставить("Поток", ФайловыеПотоки.ОткрытьДляЗаписи(ИмяФайла));
	Архив.Вставить("Файлы", Новый Массив);
	Архив.Вставить("РазмерКаталога", 0);
	Архив.Вставить("Размер", 0);
	
	Возврат Архив;
	
КонецФункции

// Параметры:
// 	Архив - см. Создать
// 	ИмяФайла - Строка
//
Процедура ДобавитьФайл(Архив, ИмяФайла) Экспорт
	
	Перем ИмяВременногоФайла;
	
	Инфо = Новый Файл(ИмяФайла);
	Если Инфо.ЭтоКаталог() Или Инфо.Размер() > МаксимальныйРазмерФайлаВПамяти() Тогда
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("zip");
		Поток = ФайловыеПотоки.Открыть(ИмяВременногоФайла, РежимОткрытияФайла.ОткрытьИлиСоздать, ДоступКФайлу.ЧтениеИЗапись);
	Иначе
		Поток = Новый ПотокВПамяти();
	КонецЕсли;
	ЗаписьZIP = Новый ЗаписьZipФайла(Поток);
	Если Инфо.ЭтоКаталог() Тогда
		ЗаписьZIP.Добавить(ИмяФайла + ПолучитьРазделительПути() + "*", РежимСохраненияПутейZIP.СохранятьОтносительныеПути, РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
	Иначе
		ЗаписьZIP.Добавить(ИмяФайла, РежимСохраненияПутейZIP.НеСохранятьПути);
	КонецЕсли;
	ЗаписьZIP.Записать();
	
	ДанныеАрхива = ПрочитатьАрхив(Поток);
	Для Каждого КлючИЗначение Из ДанныеАрхива.КаталогФайлов Цикл
		
		НайденнаяЗапись = КлючИЗначение.Значение;
	
		ЗаголовокФайла = ПолучитьБайты(Поток, НайденнаяЗапись.СмещениеФайла, 30);
		Длина = 30 + ЗаголовокФайла.ПрочитатьЦелое16(26) + ЗаголовокФайла.ПрочитатьЦелое16(28) + НайденнаяЗапись.СжатыйРазмер; // 30 + file name length + extra field length
		
		Смещение = Архив.Размер + Архив.Поток.ТекущаяПозиция();
		Если Смещение >= 4294967295 Тогда
			
			ДлинаИмениФайла = НайденнаяЗапись.Буфер.ПрочитатьЦелое16(28);
			ДлинаДопДанных = НайденнаяЗапись.Буфер.ПрочитатьЦелое16(30);
			ДлинаКомментария = НайденнаяЗапись.Буфер.ПрочитатьЦелое16(32);
			Если ДлинаКомментария <> 0 Тогда
				ВызватьИсключение "не реализовано";
			КонецЕсли;
			БуферДопДанные = НайденнаяЗапись.Буфер.Прочитать(46 + ДлинаИмениФайла, ДлинаДопДанных);
			ДопДанные = РаспарситьДопДанные(БуферДопДанные);
			
			// Т.к. файл в исходном архиве всегда 1, то смещение его 0 и соответственно в расширенной информации отсутствует
			НовыйБуфер = Новый БуферДвоичныхДанных(8);
			НовыйБуфер.ЗаписатьЦелое64(0, Смещение);
			Для Каждого Доп64 Из ДопДанные Цикл
				Если Доп64.Тип = ЧислоИзШестнадцатеричнойСтроки("0x0001") Тогда
					Доп64.Данные = Доп64.Данные.Соединить(НовыйБуфер);
					НовыйБуфер = Неопределено;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если НовыйБуфер <> Неопределено Тогда
				ДопДанные.Добавить(Новый Структура("Тип, Данные", ЧислоИзШестнадцатеричнойСтроки("0x0001"), НовыйБуфер));
			КонецЕсли;
			БуферДопДанные = СобратьДопДанные(ДопДанные);
			НайденнаяЗапись.Буфер = НайденнаяЗапись.Буфер.Соединить(Новый БуферДвоичныхДанных(БуферДопДанные.Размер - ДлинаДопДанных));
			НайденнаяЗапись.Буфер.ЗаписатьЦелое16(30, БуферДопДанные.Размер);
			НайденнаяЗапись.Буфер.Записать(46 + ДлинаИмениФайла, БуферДопДанные);
			НайденнаяЗапись.ДлинаЗаписи = НайденнаяЗапись.Буфер.Размер;
			
			Смещение = 4294967295;
			
		КонецЕсли;
		НайденнаяЗапись.Буфер.ЗаписатьЦелое32(42, Смещение); // СмещениеФайла
		Архив.РазмерКаталога = Архив.РазмерКаталога + НайденнаяЗапись.ДлинаЗаписи;
		Архив.Файлы.Добавить(НайденнаяЗапись);
		
		// Сами данные
		Поток.Перейти(НайденнаяЗапись.СмещениеФайла, ПозицияВПотоке.Начало);
		Поток.КопироватьВ(Архив.Поток, Длина);		
		
	КонецЦикла;
	
	Поток.Закрыть();
	Если ТипЗнч(Поток) = Тип("ФайловыйПоток") Тогда
		УдалитьФайлы(ИмяВременногоФайла);
	КонецЕсли;
	
КонецПроцедуры

// Параметры: 
//  Архив - см. Создать
// 
// Возвращаемое значение: 
//  Число
Функция Размер(Архив) Экспорт
	
	Возврат Архив.Поток.Размер();
	
КонецФункции

// Параметры:
// 	Архив - см. Создать
// 	ИмяФайла - Строка
//
Процедура ОтделитьЧасть(Архив, ИмяФайла) Экспорт
	
	Архив.Поток.СброситьБуферы();
	Архив.Размер = Архив.Размер + Архив.Поток.Размер();
	Архив.Поток.Закрыть();
	ИмяАрхива = Архив.Поток.ИмяФайла;
	ПереместитьФайл(ИмяАрхива, ИмяФайла);
	Архив.Поток = ФайловыеПотоки.ОткрытьДляЗаписи(ИмяАрхива);
	
КонецПроцедуры

// Параметры:
// 	Архив - см. Создать
//
Процедура Завершить(Архив) Экспорт
	
	ПотокЗаписи = Архив.Поток;
	ФайлыВАрхиве = Архив.Файлы; // Массив Из см. ЗаписьКаталога
	
	СмещениеКаталога = Архив.Размер + ПотокЗаписи.ТекущаяПозиция();
	
	// Запись центрального каталога
	Для Каждого НайденнаяЗапись Из ФайлыВАрхиве Цикл
		//ЗаписьДанных.ЗаписатьБуферДвоичныхДанных(НайденнаяЗапись.Буфер);	
		ПотокЗаписи.Записать(НайденнаяЗапись.Буфер, 0, НайденнаяЗапись.Буфер.Размер);
	КонецЦикла;
	
	Если СмещениеКаталога >= 4294967295 Или ФайлыВАрхиве.Количество() >= 65535 Тогда
		
		// КонецКаталога64
		Буфер = НовыйКонецКаталога64(ФайлыВАрхиве.Количество(), Архив.РазмерКаталога, СмещениеКаталога);
		СмещениеКонецКаталога64 = Архив.Размер + ПотокЗаписи.ТекущаяПозиция();
		ПотокЗаписи.Записать(Буфер, 0, Буфер.Размер);
		
		// Локатор64
		Буфер = НовыйЛокатор64(СмещениеКонецКаталога64);
		ПотокЗаписи.Записать(Буфер, 0, Буфер.Размер);
		
		СмещениеКаталога = 4294967295;
	КонецЕсли;
	
	// КонецКаталога
	Буфер = НовыйКонецКаталога(ФайлыВАрхиве.Количество(), Архив.РазмерКаталога, СмещениеКаталога);
	ПотокЗаписи.Записать(Буфер, 0, Буфер.Размер);
	
	// Архив готов
	ПотокЗаписи.Закрыть();
	
КонецПроцедуры

// Прочитать архив.
// 
// Параметры: 
//  Источник - ФайловыйПоток, ПотокВПамяти, УникальныйИдентификатор - 
//  	источник архива, если УникальныйИдентификатор - то это файл в томе.
// 
// Возвращаемое значение: 
//	Структура:
//	 * КаталогФайлов - Соответствие из КлючИЗначение:
//		** Ключ - строка - имя файла.
//		** Значение - см. ПрочитатьЗаписьКаталога
//   * Источник - ФайловыйПоток, ПотокВПамяти, УникальныйИдентификатор -
//   * КонецКаталога - см. КонецКаталога
//   * Смещение - Число
//   * Размер - Число
//			  - Неопределено
Функция ПрочитатьАрхив(Источник) Экспорт

	Возврат ПрочитатьАрхивВнутр(Источник);
	
КонецФункции

// Параметры:
// 	ДанныеАрхива - см. ZipАрхивы.ПрочитатьАрхив
// 	ИмяФайла - Строка - имя файла в архиве
// 	
// Возвращаемое значение:
//  см. ПрочитатьАрхив 
Функция ПрочитатьВложенныйНесжатыйАрхив(ДанныеАрхива, ИмяФайла) Экспорт
	
	НайденнаяЗапись = ДанныеАрхива.КаталогФайлов.Получить(ИмяФайла);
	
	Если НайденнаяЗапись = Неопределено Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Файл %1 не найден'"), ИмяФайла);
	КонецЕсли;
	
	ЗаголовокФайла = ПрочитатьВБуферДвоичныхДанных(ДанныеАрхива, НайденнаяЗапись.СмещениеФайла, 30);
	Смещение = НайденнаяЗапись.СмещениеФайла + 30 + ЗаголовокФайла.ПрочитатьЦелое16(26) + ЗаголовокФайла.ПрочитатьЦелое16(28);
	
	Возврат ПрочитатьАрхивВнутр(ДанныеАрхива.Источник, Смещение, НайденнаяЗапись.НесжатыйРазмер);
	
КонецФункции

// Параметры: 
//  ДанныеАрхива - см. ZipАрхивы.ПрочитатьАрхив
//  ИмяФайла - Строка
//  Каталог - Строка
// 
// Возвращаемое значение: 
//  Булево
Функция ИзвлечьФайл(ДанныеАрхива, ИмяФайла, Каталог) Экспорт
	
	НайденнаяЗапись = ДанныеАрхива.КаталогФайлов.Получить(ИмяФайла);
	
	Если НайденнаяЗапись = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеАрхива.Источник) = Тип("УникальныйИдентификатор") Тогда
		// Длина заголовка:
		//   размер заголовка, всегда 30
		//   длина имени файла
		//   длина ДлинаДопДанных, но тут обычно 0 
		Размер = 30 + НайденнаяЗапись.Буфер.ПрочитатьЦелое16(28) + 0 + НайденнаяЗапись.СжатыйРазмер;
		ВремФайл = ПрочитатьВФайлИзТома(ДанныеАрхива, НайденнаяЗапись.СмещениеФайла, Размер);
		
		ПотокЧтения = ФайловыеПотоки.ОткрытьДляЧтения(ВремФайл);
		ЗаголовокФайла = Новый БуферДвоичныхДанных(30);
		ПотокЧтения.Прочитать(ЗаголовокФайла, 0, 30);
		ПотокЧтения.Перейти(0, ПозицияВПотоке.Начало);
		ПравильныйРазмер = 30 + ЗаголовокФайла.ПрочитатьЦелое16(26) + ЗаголовокФайла.ПрочитатьЦелое16(28) + НайденнаяЗапись.СжатыйРазмер;
		Разница = ПравильныйРазмер - Размер;
		Если Разница > 0 Тогда
			СмещениеФайла = НайденнаяЗапись.СмещениеФайла + Размер;
			Размер = ПравильныйРазмер;
			ПотокЧтения.Закрыть();
			ЗаписьДанных = Новый ЗаписьДанных(ВремФайл, , , , Истина);
			ЗаписьДанных.ЗаписатьБуферДвоичныхДанных(ПрочитатьВБуферДвоичныхДанных(ДанныеАрхива, СмещениеФайла, Разница));
			ЗаписьДанных.Закрыть();
			ПотокЧтения = ФайловыеПотоки.ОткрытьДляЧтения(ВремФайл);
		КонецЕсли;
		
		Если Размер > МаксимальныйРазмерФайлаВПамяти() Тогда 
			ИмяАрхива = ПолучитьИмяВременногоФайла("zip");
		Иначе
			ВременныйБуфер = Новый БуферДвоичныхДанных(Размер + НайденнаяЗапись.Буфер.Размер + 22);
			ИмяАрхива = Новый ПотокВПамяти(ВременныйБуфер);
		КонецЕсли;
		
		ЗаписьДанных = Новый ЗаписьДанных(ИмяАрхива);
		
		// Сами данные
		ПотокЧтения.КопироватьВ(ЗаписьДанных.ЦелевойПоток());
		
		ПотокЧтения.Закрыть();
		УдалитьФайлы(ВремФайл);
	
	Иначе
	
		ЗаголовокФайла = ПолучитьБайты(ДанныеАрхива.Источник, НайденнаяЗапись.СмещениеФайла + ДанныеАрхива.Смещение, 30);
		Размер = 30 + ЗаголовокФайла.ПрочитатьЦелое16(26) + ЗаголовокФайла.ПрочитатьЦелое16(28) + НайденнаяЗапись.СжатыйРазмер;
		
		Если Размер > МаксимальныйРазмерФайлаВПамяти() Тогда 
			ИмяАрхива = ПолучитьИмяВременногоФайла("zip");
		Иначе
			ВременныйБуфер = Новый БуферДвоичныхДанных(Размер + НайденнаяЗапись.Буфер.Размер + 22);
			ИмяАрхива = Новый ПотокВПамяти(ВременныйБуфер);
		КонецЕсли;
			
		ЗаписьДанных = Новый ЗаписьДанных(ИмяАрхива);
	
		// Сами данные
		ДанныеАрхива.Источник.Перейти(НайденнаяЗапись.СмещениеФайла + ДанныеАрхива.Смещение, ПозицияВПотоке.Начало);
		ДанныеАрхива.Источник.КопироватьВ(ЗаписьДанных.ЦелевойПоток(), Размер);
		
	КонецЕсли;
	
	
	// Запись центрального каталога
	ЗаписьКаталога = НайденнаяЗапись.Буфер.Скопировать();
	ЗаписьКаталога.ЗаписатьЦелое32(42, 0);
	ЗаписьДанных.ЗаписатьБуферДвоичныхДанных(ЗаписьКаталога);
	
	СмещениеКаталога = Размер;
	РазмерКаталога = НайденнаяЗапись.ДлинаЗаписи;
	Если СмещениеКаталога > ЧислоИзШестнадцатеричнойСтроки("0xFFFFFFFF") Тогда
		
		// КонецКаталога64
		Буфер = НовыйКонецКаталога64(1, РазмерКаталога, СмещениеКаталога);
		СмещениеКонецКаталога64 = СмещениеКаталога + РазмерКаталога;
		ЗаписьДанных.ЗаписатьБуферДвоичныхДанных(Буфер, 0, Буфер.Размер);
		
		// Локатор64
		Буфер = НовыйЛокатор64(СмещениеКонецКаталога64);
		ЗаписьДанных.ЗаписатьБуферДвоичныхДанных(Буфер, 0, Буфер.Размер);
		
		СмещениеКаталога = ЧислоИзШестнадцатеричнойСтроки("0xFFFFFFFF");
		
	КонецЕсли;
	
	// Окончание центрального каталога
	КонецКаталога = НовыйКонецКаталога(1, РазмерКаталога, СмещениеКаталога);
	ЗаписьДанных.ЗаписатьБуферДвоичныхДанных(КонецКаталога);
	
	// Архив готов
	ЗаписьДанных.Закрыть();
	ЗаписьДанных = Неопределено;
	
	Если ТипЗнч(ИмяАрхива) <> Тип("Строка") Тогда 
		ИмяАрхива.Перейти(0, ПозицияВПотоке.Начало);
	КонецЕсли;
	
	// ИзвлечениеАрхива;
	ЧтениеZip = Новый ЧтениеZipФайла(ИмяАрхива);
	ЧтениеZip.ИзвлечьВсе(Каталог, РежимВосстановленияПутейФайловZIP.Восстанавливать);
	ЧтениеZip.Закрыть();
	
	Если ТипЗнч(ИмяАрхива) = Тип("Строка") Тогда
		УдалитьФайлы(ИмяАрхива);
	Иначе 
		ИмяАрхива.Закрыть();
		ИмяАрхива = Неопределено;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Прочитать файл
// 
// Параметры: 
// 	ДанныеАрхива - см. ZipАрхивы.ПрочитатьАрхив
//  ИмяФайла - Строка
// 
// Возвращаемое значение: 
//   ДвоичныеДанные, Неопределено - Прочитать файл
Функция ПрочитатьФайл(ДанныеАрхива, ИмяФайла) Экспорт
	
	// ИзвлечениеАрхива;
	КаталогАрхива = ПолучитьИмяВременногоФайла("unzip");
	Если Не ИзвлечьФайл(ДанныеАрхива, ИмяФайла, КаталогАрхива) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ЧтениеДанных = Новый ЧтениеДанных(КаталогАрхива + ПолучитьРазделительПути() + ИмяФайла);
	ДанныеФайла = ЧтениеДанных.Прочитать().ПолучитьДвоичныеДанные();
	ЧтениеДанных.Закрыть();
	
	УдалитьФайлы(КаталогАрхива);
	
	Возврат ДанныеФайла;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИЙункции

Функция ПрочитатьАрхивВнутр(Знач Источник, Знач Смещение = 0, Знач Размер = Неопределено)

	ДанныеАрхива = Новый Структура;
	ДанныеАрхива.Вставить("Источник", Источник);
	ДанныеАрхива.Вставить("Смещение", Смещение);
	
	Если ТипЗнч(Источник) = Тип("УникальныйИдентификатор") Тогда
		ПолныйРазмер = РаботаВМоделиСервиса.ПолучитьРазмерФайлаИзХранилищаМенеджераСервиса(Источник);
		Если ПолныйРазмер = Неопределено Тогда
			ВызватьИсключение НСтр("ru = 'Не удалось прочитать архив'");
		КонецЕсли;
		
		АдресМенеджераСервиса = РаботаВМоделиСервиса.ВнутреннийАдресМенеджераСервиса();
		УстановитьПривилегированныйРежим(Истина);
		ПараметрыДоступа = Новый Структура;
		ПараметрыДоступа.Вставить("URL", АдресМенеджераСервиса);
		ПараметрыДоступа.Вставить("UserName", РаботаВМоделиСервиса.ИмяСлужебногоПользователяМенеджераСервиса());
		ПараметрыДоступа.Вставить("Password", РаботаВМоделиСервиса.ПарольСлужебногоПользователяМенеджераСервиса());
		ПараметрыДоступа.Вставить("Кэш", Новый Соответствие);
		УстановитьПривилегированныйРежим(Ложь);
		Если Не ЗначениеЗаполнено(АдресМенеджераСервиса) Тогда
			ВызватьИсключение НСтр("ru = 'Не установлены параметры связи с менеджером сервиса.'");
		КонецЕсли;
		Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ПередачаДанных") 
			Или ОбщегоНазначения.ПолучитьВерсииИнтерфейса(ПараметрыДоступа, "DataTransfer").Количество() = 0 Тогда
			ВызватьИсключение НСтр("ru = 'Получение данных из мендежера сервиса невозможно.'");
		КонецЕсли;
		ДанныеАрхива.Вставить("ПараметрыДоступа", ПараметрыДоступа);
	
	ИначеЕсли ТипЗнч(Источник) = Тип("ФайловыйПоток") Или ТипЗнч(Источник) = Тип("ПотокВПамяти") Тогда 
		ПолныйРазмер = Источник.Размер(); 
	Иначе
		ВызватьИсключение НСтр("ru = 'Неизвестный тип источника'");
	КонецЕсли;
	
	Если Размер = Неопределено Тогда
		Размер = ПолныйРазмер;
	ИначеЕсли (Смещение + Размер - 1) > ПолныйРазмер Тогда
		ВызватьИсключение НСтр("ru = 'Некорректный размер'");
	КонецЕсли;
	
	ДанныеАрхива.Вставить("Размер", Размер);
	
	КонецКаталога = ПрочитатьКонецКаталога(ДанныеАрхива);
	ДанныеАрхива.Вставить("КонецКаталога", КонецКаталога);
	
	Если КонецКаталога.СмещениеКаталога = ЧислоИзШестнадцатеричнойСтроки("0xFFFFFFFF") 
		Или КонецКаталога.КоличествоЗаписейВсего = ЧислоИзШестнадцатеричнойСтроки("0xFFFF") Тогда
		Локатор64 = ПрочитатьЛокатор64(ДанныеАрхива, ДанныеАрхива.Размер - КонецКаталога.Буфер.Размер);
		КонецКаталога64 = ПрочитатьКонецКаталога64(ДанныеАрхива, Локатор64.Смещение);
		ЗаписиКаталога = ПрочитатьЗаписиКаталога(ДанныеАрхива, КонецКаталога64.СмещениеКаталога, КонецКаталога64.РазмерКаталога);
	Иначе
		ЗаписиКаталога = ПрочитатьЗаписиКаталога(ДанныеАрхива, КонецКаталога.СмещениеКаталога, КонецКаталога.РазмерКаталога);
	КонецЕсли;
	
	КаталогФайлов = Новый Соответствие;
	Смещение = 0;
	Буфер = ЗаписиКаталога;
	Размер = Буфер.Размер;
	Пока Смещение < Размер Цикл
		ЗаписьКаталога = ПрочитатьЗаписьКаталога(Буфер, Смещение);
		КаталогФайлов.Вставить(ЗаписьКаталога.Имяфайла, ЗаписьКаталога);
		Смещение = Смещение + ЗаписьКаталога.ДлинаЗаписи;
	КонецЦикла;
	ДанныеАрхива.Вставить("КаталогФайлов", КаталогФайлов);
	
	Возврат ДанныеАрхива;
	
КонецФункции

// Параметры: 
//  КоличествоЗаписей - Число
//  РазмерКаталога - Число
//  СмещениеКаталога - Число
// 
// Возвращаемое значение: 
//  БуферДвоичныхДанных
Функция НовыйКонецКаталога(КоличествоЗаписей, РазмерКаталога, СмещениеКаталога)
	
	Буфер = Новый БуферДвоичныхДанных(22);
	Буфер.ЗаписатьЦелое32(0, ЧислоИзШестнадцатеричнойСтроки("0x06054b50")); // end of central dir signature
	Буфер.ЗаписатьЦелое16(4, 0); // number of this disk
	Буфер.ЗаписатьЦелое16(6, 0); // number of the disk with the start of the central directory
	Буфер.ЗаписатьЦелое16(8, Мин(КоличествоЗаписей, 65535)); // total number of entries in the central directory on this disk
	Буфер.ЗаписатьЦелое16(10, Мин(КоличествоЗаписей, 65535)); // total number of entries in  the central directory
	Буфер.ЗаписатьЦелое32(12, РазмерКаталога); // size of the central directory
	Буфер.ЗаписатьЦелое32(16, СмещениеКаталога); // offset of start of central directory with respect to the starting disk number
	Буфер.ЗаписатьЦелое16(20, 0); // .ZIP file comment length
	
	Возврат Буфер;
	
КонецФункции

// Параметры: 
//  ВсегоЗаписей - Число
//  РазмерКаталога - Число
//  СмещениеКаталога - Число
// 
// Возвращаемое значение: 
//  БуферДвоичныхДанных
Функция НовыйКонецКаталога64(ВсегоЗаписей, РазмерКаталога, СмещениеКаталога)
	
	Буфер = Новый БуферДвоичныхДанных(56);
	Буфер.ЗаписатьЦелое32(0, ЧислоИзШестнадцатеричнойСтроки("0x06064b50")); // zip64 end of central dir signature  
	Буфер.ЗаписатьЦелое64(4, 56 - 12); // size of zip64 end of central directory record 
	Буфер.ЗаписатьЦелое16(12, 45); // version made by
	Буфер.ЗаписатьЦелое16(14, 45); // version needed to extract
	Буфер.ЗаписатьЦелое32(16, 0); // number of this disk
	Буфер.ЗаписатьЦелое32(20, 0); // number of the disk with the start of the central directory
	Буфер.ЗаписатьЦелое64(24, ВсегоЗаписей); //total number of entries in the central directory on this disk
	Буфер.ЗаписатьЦелое64(32, ВсегоЗаписей); // total number of entries in the central directory
	Буфер.ЗаписатьЦелое64(40, РазмерКаталога); // size of the central directory
	Буфер.ЗаписатьЦелое64(48, СмещениеКаталога); // offset of start of central directory with respect to the starting disk number
	Возврат Буфер;
	
КонецФункции

// Параметры: 
//  СмещениеКонецКаталога64 - Число
// 
// Возвращаемое значение: 
//  БуферДвоичныхДанных
Функция НовыйЛокатор64(СмещениеКонецКаталога64)
	
	Буфер = Новый БуферДвоичныхДанных(20);
	Буфер.ЗаписатьЦелое32(0, ЧислоИзШестнадцатеричнойСтроки("0x07064b50")); // zip64 end of central dir locator signature
	Буфер.ЗаписатьЦелое32(4, 0); // number of the disk with the start of the zip64 end of central directory
	Буфер.ЗаписатьЦелое64(8, СмещениеКонецКаталога64); // relative offset of the zip64 end of central directory record
	Буфер.ЗаписатьЦелое32(16, 1); // total number of disks
	
	Возврат Буфер;
	
КонецФункции

// Параметры:
// 	Буфер - БуферДвоичныхДанных
// 	Смещение - Число
// 	
// Возвращаемое значение:
// 	Структура:
// * Буфер - БуферДвоичныхДанных
// * МетодСжатия - Число
// * СжатыйРазмер - Число
// * НесжатыйРазмер - Число
// * СмещениеФайла - Число
// * ДлинаЗаписи - Число
// * ИмяФайла - Строка
//
Функция ПрочитатьЗаписьКаталога(Буфер, Смещение)
	
	ЗаписьКаталога = Буфер;
	
	// ЧислоИзШестнадцатеричнойСтроки("0x02014b50") = 33639248
	Если ЗаписьКаталога.ПрочитатьЦелое32(Смещение) <> 33639248 Тогда
		ВызватьИсключение НСтр("ru = 'Неверный формат'");
	КонецЕсли;
	
	ДлинаИмениФайла = ЗаписьКаталога.ПрочитатьЦелое16(Смещение + 28);
	ДлинаДопДанных = ЗаписьКаталога.ПрочитатьЦелое16(Смещение + 30);
	ДлинаКомментария = ЗаписьКаталога.ПрочитатьЦелое16(Смещение + 32);
	ДлинаЗаписи = 46 + ДлинаИмениФайла + ДлинаДопДанных + ДлинаКомментария;
	
	Данные = Новый Структура;	
	Данные.Вставить("Буфер", ЗаписьКаталога.Прочитать(Смещение, ДлинаЗаписи));
	Данные.Вставить("МетодСжатия", ЗаписьКаталога.ПрочитатьЦелое16(Смещение + 10));
	Данные.Вставить("СжатыйРазмер", ЗаписьКаталога.ПрочитатьЦелое32(Смещение + 20));
	Данные.Вставить("НесжатыйРазмер", ЗаписьКаталога.ПрочитатьЦелое32(Смещение + 24));	
	Данные.Вставить("СмещениеФайла", ЗаписьКаталога.ПрочитатьЦелое32(Смещение + 42));
	Данные.Вставить("ДлинаЗаписи", ДлинаЗаписи);
	
	Если Данные.НесжатыйРазмер = 4294967295 Или Данные.СмещениеФайла = 4294967295 Или Данные.СжатыйРазмер = 4294967295 Тогда
		
		Если ДлинаДопДанных = 0 Тогда
			ВызватьИсключение НСтр("ru = 'Неверный формат'");
		КонецЕсли;
		
		Для Каждого ДопДанные Из РаспарситьДопДанные(ЗаписьКаталога.Прочитать(Смещение + 46 + ДлинаИмениФайла, ДлинаДопДанных)) Цикл 
			Если ДопДанные.Тип = ЧислоИзШестнадцатеричнойСтроки("0x0001") Тогда
				Буфер64 = ДопДанные.Данные;
				Индекс64 = 0;
				Если Данные.НесжатыйРазмер = 4294967295 Тогда
					Данные.НесжатыйРазмер = Буфер64.ПрочитатьЦелое64(Индекс64);
					Индекс64 = Индекс64 + 8;
				КонецЕсли;
				Если Данные.СжатыйРазмер = 4294967295 Тогда
					Данные.СжатыйРазмер = Буфер64.ПрочитатьЦелое64(Индекс64);
					Индекс64 = Индекс64 + 8;
				КонецЕсли;
				Если Данные.СмещениеФайла = 4294967295 Тогда
					Данные.СмещениеФайла = Буфер64.ПрочитатьЦелое64(Индекс64);
					Индекс64 = Индекс64 + 8;
				КонецЕсли;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Данные.Вставить("ИмяФайла", ПолучитьСтрокуИзБуфераДвоичныхДанных(ЗаписьКаталога.ПолучитьСрез(Смещение + 46, ДлинаИмениФайла))); // Мы используем только латиницу
	
	Возврат Данные;
	
КонецФункции

// Читает из потока конец каталога
// 
// Параметры:
// 	ДанныеАрхива - см. ZipАрхивы.ПрочитатьАрхив -
// Возвращаемое значение:
// 	Структура - Описание:
//   * НомерДиска - Число
//   * НачалоДиска - Число
//   * КоличествоЗаписейНаДиске - Число
//   * КоличествоЗаписейВсего - Число
//   * РазмерКаталога - Число
//   * СмещениеКаталога - Число
//   * ДлинаКомментария - Число
//   * Буфер - БуферДвоичныхДанных
Функция ПрочитатьКонецКаталога(ДанныеАрхива)
	
	КонецКаталога = ПрочитатьВБуферДвоичныхДанных(ДанныеАрхива, ДанныеАрхива.Размер - 22, 22);
	Если КонецКаталога.ПрочитатьЦелое32(0) <> ЧислоИзШестнадцатеричнойСтроки("0x06054b50") Тогда
		ВызватьИсключение НСтр("ru = 'Файл не является zip архивом'");
	КонецЕсли;
	
	Данные = Новый Структура;
		
	Данные.Вставить("НомерДиска", КонецКаталога.ПрочитатьЦелое16(4));
	Данные.Вставить("НачалоДиска", КонецКаталога.ПрочитатьЦелое16(6));
	Данные.Вставить("КоличествоЗаписейНаДиске", КонецКаталога.ПрочитатьЦелое16(8));
	Данные.Вставить("КоличествоЗаписейВсего", КонецКаталога.ПрочитатьЦелое16(10));
	Данные.Вставить("РазмерКаталога", КонецКаталога.ПрочитатьЦелое32(12));
	Данные.Вставить("СмещениеКаталога", КонецКаталога.ПрочитатьЦелое32(16));
	Данные.Вставить("ДлинаКомментария", КонецКаталога.ПрочитатьЦелое16(20));
	Данные.Вставить("Буфер", КонецКаталога);
	
	Возврат Данные;
	
КонецФункции

Функция ПрочитатьКонецКаталога64(ДанныеАрхива, Начало)
	
	КонецКаталога = ПрочитатьВБуферДвоичныхДанных(ДанныеАрхива, Начало, 56);
	Если КонецКаталога.ПрочитатьЦелое32(0) <> ЧислоИзШестнадцатеричнойСтроки("0x06064b50") Тогда
		ВызватьИсключение НСтр("ru = 'Файл не является zip архивом'");
	КонецЕсли;
	
	Данные = Новый Структура;
	Данные.Вставить("РазмерКонецКаталога64", КонецКаталога.ПрочитатьЦелое64(4));
	Данные.Вставить("СделаноВерсией", КонецКаталога.ПрочитатьЦелое16(12));
	Данные.Вставить("ВерсияТребуется", КонецКаталога.ПрочитатьЦелое16(14));
	Данные.Вставить("НомерДиска", КонецКаталога.ПрочитатьЦелое32(16));
	Данные.Вставить("НомерДиска2", КонецКаталога.ПрочитатьЦелое32(20));
	Данные.Вставить("КоличествоЗаписейНаЭтомДиске", КонецКаталога.ПрочитатьЦелое64(24));
	Данные.Вставить("ВсегоЗаписей", КонецКаталога.ПрочитатьЦелое64(32));
	Данные.Вставить("РазмерКаталога", КонецКаталога.ПрочитатьЦелое64(40));
	Данные.Вставить("СмещениеКаталога", КонецКаталога.ПрочитатьЦелое64(48));
	Данные.Вставить("Буфер", КонецКаталога);
	
	// Обход для проблемных архивов (см. MC-7278), удалить можно только через продолжительное время.
	Данные.РазмерКаталога = Начало - Данные.СмещениеКаталога;
	
	Возврат Данные;
	
КонецФункции

Функция ПолучитьБайты(Поток, Начало, Размер)
	
	Поток.Перейти(Начало, ПозицияВПотоке.Начало);
	Буфер = Новый БуферДвоичныхДанных(Размер);
	Если Поток.Прочитать(Буфер, 0, Размер) <> Размер Тогда
		ВызватьИсключение "Неправильные размеры";
	КонецЕсли;
	
	Возврат Буфер;
	
КонецФункции

Функция ПрочитатьВФайлИзТома(ДанныеАрхива, Начало, Размер)
	
	Диапазон = Новый Структура("Начало, Конец", Начало + ДанныеАрхива.Смещение, Начало + Размер - 1 + ДанныеАрхива.Смещение);
	Результат = ПередачаДанныхСервер.ПолучитьИзЛогическогоХранилища(ДанныеАрхива.ПараметрыДоступа, "files", ДанныеАрхива.Источник, Диапазон);
	Если Результат = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Не удалось получить данные из менеджера сервиса'");
	КонецЕсли;
	Возврат Результат.ПолноеИмя;
	
КонецФункции

Функция ПрочитатьВБуферДвоичныхДанных(ДанныеАрхива, Начало, Размер)
	
	Если ТипЗнч(ДанныеАрхива.Источник) = Тип("УникальныйИдентификатор") Тогда
		ИмяФайла = ПрочитатьВФайлИзТома(ДанныеАрхива, Начало, Размер);
		ДвоичныеДанные = Новый ДвоичныеДанные(ИмяФайла);
		УдалитьФайлы(ИмяФайла);
		Возврат ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(ДвоичныеДанные);
	Иначе
		Возврат ПолучитьБайты(ДанныеАрхива.Источник, Начало + ДанныеАрхива.Смещение, Размер);
	КонецЕсли;
	
КонецФункции

Функция ПрочитатьЗаписиКаталога(ДанныеАрхива, Начало, Размер)
	
	Возврат ПрочитатьВБуферДвоичныхДанных(ДанныеАрхива, Начало, Размер);
	
КонецФункции

Функция ПрочитатьЛокатор64(ДанныеАрхива, Конец)
	
	Локатор = ПрочитатьВБуферДвоичныхДанных(ДанныеАрхива, Конец - 20, 20);
	Если Локатор.ПрочитатьЦелое32(0) <> ЧислоИзШестнадцатеричнойСтроки("0x07064b50") Тогда
		ВызватьИсключение НСтр("ru = 'Файл не является zip архивом'");
	КонецЕсли;
	
	Данные = Новый Структура;
	Данные.Вставить("НомерДиска", Локатор.ПрочитатьЦелое32(4));
	Данные.Вставить("Смещение", Локатор.ПрочитатьЦелое64(8));
	Данные.Вставить("ВсегоДисков", Локатор.ПрочитатьЦелое32(16));
	Данные.Вставить("Буфер", Локатор);
	
	Возврат Данные;
	
КонецФункции

// Параметры:
// 	БуферДвоичныхДанных - БуферДвоичныхДанных
// 	
// Возвращаемое значение:
// 	Массив Из Структура:
//	* Тип - Число
//	* Данные - БуферДвоичныхДанных
//
Функция РаспарситьДопДанные(БуферДвоичныхДанных)
	
	ДопДанные = Новый Массив;
	
	Индекс = 0;
	Пока Индекс < БуферДвоичныхДанных.Размер Цикл
		
		Тип = БуферДвоичныхДанных.ПрочитатьЦелое16(Индекс);
		Размер = БуферДвоичныхДанных.ПрочитатьЦелое16(Индекс + 2);
		Если Размер > 0 Тогда
			Данные = БуферДвоичныхДанных.Прочитать(Индекс + 4, Размер);
		Иначе
			Данные = Неопределено;
		КонецЕсли;
		
		ДопДанные.Добавить(Новый Структура("Тип, Данные", Тип, Данные));
		Индекс = Индекс + 4 + Размер;
		
	КонецЦикла;
	
	Возврат ДопДанные;
	
КонецФункции

Функция СобратьДопДанные(ДопДанные)
	
	Размер = 0;
	Для Каждого Данные Из ДопДанные Цикл
		Размер = Размер + 4 + Данные.Данные.Размер;
	КонецЦикла;
	
	Буфер = Новый БуферДвоичныхДанных(Размер);
	Смещение = 0;
	Для Каждого Данные Из ДопДанные Цикл
		Буфер.ЗаписатьЦелое16(Смещение, Данные.Тип);
		Буфер.ЗаписатьЦелое16(Смещение + 2, Данные.Данные.Размер);
		Буфер.Записать(Смещение + 4, Данные.Данные);
		Смещение = Смещение + 4 + Данные.Данные.Размер;		
	КонецЦикла;
	
	Возврат Буфер;
	
КонецФункции

Функция МаксимальныйРазмерФайлаВПамяти()
	
	Возврат 10 * 1024 * 1024;
	
КонецФункции

#КонецОбласти
