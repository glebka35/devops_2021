# Instruction

Зависимости: NodeJS, npm

## Поднимаем машину
vagrant up

## Подключаемся к мастеру и конфигурируем миниона
vagrant ssh master

sudo salt '*' state.highstate

logout

## Подключаемся к миниону и клоним репозиторий с проектом
vagrant ssh minion

## Запускаем проект
cd Develop/react_2021 && sudo npm start

## Переходим на localhost:8080
