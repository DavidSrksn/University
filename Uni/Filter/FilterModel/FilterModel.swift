//
//  Filter.swift
//  university
//
//  Created by Георгий Куликов on 19.10.2019.
//  Copyright © 2019 Георгий Куликов. All rights reserved.
//

import Foundation

enum Countrys: String {
    typealias RawValue = String
    
    case Абакан
    case Азов
    case Александров
    case Алексин
    case Альметьевск
    case Анапа
    case Ангарск
    case АнжероСудженск = "Анжеро-Судженск"
    case Апатиты
    case Арзамас
    case Армавир
    case Арсеньев
    case Артем
    case Архангельск
    case Асбест
    case Астрахань
    case Ачинск
    case Балаково
    case Балахна
    case Балашиха
    case Балашов
    case Барнаул
    case Батайск
    case Белгород
    case Белебей
    case Белово
    case Белогорск
    case Белорецк
    case Белореченск
    case Бердск
    case Березники
    case Березовский
    case Бийск
    case Биробиджан
    case Благовещенск
    case Бор
    case Борисоглебск
    case Боровичи
    case Братск
    case Брянск
    case Бугульма
    case Буденновск
    case Бузулук
    case Буйнакск
    case ВеликиеЛуки = "Великие Луки"
    case ВеликийНовгород = "Великий Новгород"
    case ВерхняяПышма = "ВерхняяПышма"
    case Видное
    case Владивосток
    case Владикавказ
    case Владимир
    case Волгоград
    case Волгодонск
    case Волжск
    case Волжский
    case Вологда
    case Вольск
    case Воркута
    case Воронеж
    case Воскресенск
    case Воткинск
    case Всеволожск
    case Выборг
    case Выкса
    case Вязьма
    case Гатчина
    case Геленджик
    case Георгиевск
    case Глазов
    case ГорноАлтайск = "Горно-Алтайск"
    case Грозный
    case Губкин
    case Гудермес
    case Гуково
    case ГусьХрустальный = "Гусь-Хрустальный"
    case Дербент
    case Дзержинск
    case Димитровград
    case Дмитров
    case Долгопрудный
    case Домодедово
    case Донской
    case Дубна
    case Евпатория
    case Егорьевск
    case Ейск
    case Екатеринбург
    case Елабуга
    case Елец
    case Ессентуки
    case Железногорск
    case Жигулевск
    case Жуковский
    case Заречный
    case Зеленогорск
    case Зеленодольск
    case Златоуст
    case Иваново
    case Ивантеевка
    case Ижевск
    case Избербаш
    case Иркутск
    case Искитим
    case Ишим
    case Ишимбай
    case ЙошкарОла = "Йошкар-Ола"
    case Казань
    case Калининград
    case Калуга
    case КаменскУральский = "Каменск-Уральский"
    case КаменскШахтинский = "Каменск-Шахтинский"
    case Камышин
    case Канск
    case Каспийск
    case Кемерово
    case Керчь
    case Кинешма
    case Кириши
    case Киров
    case КировоЧепецк = "Кирово-Чепецк"
    case Киселевск
    case Кисловодск
    case Клин
    case Клинцы
    case Ковров
    case Когалым
    case Коломна
    case КомсомольскНаАмуре = "Комсомольск-на-Амуре"
    case Копейск
    case Королев
    case Кострома
    case Котлас
    case Красногорск
    case Краснодар
    case Краснокаменск
    case Краснокамск
    case Краснотурьинск
    case Красноярск
    case Кропоткин
    case Крымск
    case Кстово
    case Кузнецк
    case Кумертау
    case Кунгур
    case Курган
    case Курск
    case Кызыл
    case Лабинск
    case Лениногорск
    case ЛенинскКузнецкий = "Ленинск-Кузнецкий"
    case Лесосибирск
    case Липецк
    case Лиски
    case Лобня
    case Лысьва
    case Лыткарино
    case Люберцы
    case Магадан
    case Магнитогорск
    case Майкоп
    case Махачкала
    case Междуреченск
    case Мелеуз
    case Миасс
    case МинеральныеВоды = "Минеральные Воды"
    case Минусинск
    case Михайловка
    case Михайловск
    case Мичуринск
    case Москва
    case Мурманск
    case Муром
    case Мытищи
    case НабережныеЧелны = "Набережные Челны"
    case Назарово
    case Назрань
    case Нальчик
    case НароФоминск = "Наро-Фоминск"
    case Находка
    case Невинномысск
    case Нерюнгри
    case Нефтекамск
    case Нефтеюганск
    case Нижневартовск
    case Нижнекамск
    case НижнийНовгород = "Нижний Новгород"
    case НижнийТагил = "Нижний Тагил"
    case Новоалтайск
    case Новокузнецк
    case Новокуйбышевск
    case Новомосковск
    case Новороссийск
    case Новосибирск
    case Новотроицк
    case Новоуральск
    case Новочебоксарск
    case Новочеркасск
    case Новошахтинск
    case НовыйУренгой = "Новый Уренгой"
    case Ногинск
    case Норильск
    case Ноябрьск
    case Нягань
    case Обнинск
    case Одинцово
    case Озерск
    case Октябрьский
    case Омск
    case Орел
    case Оренбург
    case ОреховоЗуево = "Орехово-Зуево"
    case Орск
    case Павлово
    case ПавловскийПосад = "Павловский Посад"
    case Пенза
    case Первоуральск
    case Пермь
    case Петрозаводск
    case ПетропавловскКамчатский = "Петропавловск-Камчатский"
    case Подольск
    case Полевской
    case Прокопьевск
    case Прохладный
    case Псков
    case Пушкино
    case Пятигорск
    case Раменское
    case Ревда
    case Реутов
    case Ржев
    case Рославль
    case Россошь
    case РостовНаДону = "Ростов-на-Дону"
    case Рубцовск
    case Рыбинск
    case Рязань
    case Салават
    case Сальск
    case Самара
    case СанктПетербург = "Санкт-Петербург"
    case Саранск
    case Сарапул
    case Саратов
    case Саров
    case Свободный
    case Севастополь
    case Северодвинск
    case Северск
    case СергиевПосад = "Сергиев Посад"
    case Серов
    case Серпухов
    case Сертолово
    case Сибай
    case Симферополь
    case СлавянскНаКубани = "Славянск-на-Кубани"
    case Смоленск
    case Соликамск
    case Солнечногорск
    case СосновыйБор = "Сосновый Бор"
    case Сочи
    case Ставрополь
    case СтарыйОскол = "Старый Оскол"
    case Стерлитамак
    case Ступино
    case Сургут
    case Сызрань
    case Сыктывкар
    case Таганрог
    case Тамбов
    case Тверь
    case Тимашевск
    case Тихвин
    case Тихорецк
    case Тобольск
    case Тольятти
    case Томск
    case Троицк
    case Туапсе
    case Туймазы
    case Тула
    case Тюмень
    case Узловая
    case УланУдэ = "Улан-Удэ"
    case Ульяновск
    case УрусМартан = "Урус-Мартан"
    case УсольеСибирское = "Усолье-Сибирское"
    case Уссурийск
    case УстьИлимск = "Усть-Илимск"
    case Уфа
    case Ухта
    case Феодосия
    case Фрязино
    case Хабаровск
    case ХантыМансийск = "Ханты-Мансийск"
    case Хасавюрт
    case Химки
    case Чайковский
    case Чапаевск
    case Чебоксары
    case Челябинск
    case Черемхово
    case Череповец
    case Черкесск
    case Черногорск
    case Чехов
    case Чистополь
    case Чита
    case Шадринск
    case Шали
    case Шахты
    case Шуя
    case Щекино
    case Щелково
    case Электросталь
    case Элиста
    case Энгельс
    case ЮжноСахалинск = "Южно-Сахалинск"
    case Юрга
    case Якутск
    case Ялта
    case Ярославль
}

enum Subjects: String {
    case Математика
    case Русский
    case Физика
    case Химия
    case История
    case Обществознание
    case Информатика
    case Биология
    case Георграфия
    case Английский
    case Немецкий
    case Французсский
    case Испанский
    case Литература
}

struct subjectData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

struct Filter {
    var country: String?
    var subjects: [String]?
    var minPoint: Int?
    var military: Bool?
    var campus: Bool?
}
