select *
from item; --3.1.1 получение списка товаров

create or replace procedure add_item (name in varchar2,price in number)
is
begin
insert into item(id,name,price)
values(item_seq.NEXTVAL,name,price);
end; --3.1.2 добавление товара с помощью процедуры

begin add_item('milk',100); end; --вызов процедуры

update item
set price=120
where name='milk'; --3.1.3 изменение товара

delete from item
where name='milk'; --3.1.4 удаление товара

--заполнение тестовыми данными для задания 3.2.4
insert into storages(id,address)
values(storages_seq.NEXTVAL,'pr.Lenina 124'); --3.3.1 добаление склада
insert into storages(id,address)
values(storages_seq.NEXTVAL,'pr.Lenina 37');

begin add_item('milk',100); end; --добавление товара

insert into customer(id,last_name,first_name,patronymic,address,telephone)
values(customer_seq.NEXTVAL,'Antonov','Andrey','Denisovich','pr.Oktyabrskiy 28',88005553333); --добавление заказчика

insert into item_list(id,item_id,storage_id,quantity)
values(item_list_seq.NEXTVAL,1,1,100);
insert into item_list(id,item_id,storage_id,quantity)
values(item_list_seq.NEXTVAL,1,2,50); --распределение товров по складам

insert into orders(id,customer_id,status)
values(orders_seq.NEXTVAL,1,'in progress'); --создание заказа

--пример вставки вызывающей ошибку по условию
insert into order_list(order_id,item_list_id,quantity) --order_list это корзина
values(1,1,150); --3.2.4 добавление товара в корзину
--в качестве параметров передаются (номер заказа, номер позиции товара из item_list, требуемое количество)
--триггер check_q следит за корректным добавлением заказа в корзину
--если заказано товара больше чем возможно, то заказ не добавится в корзину
--также при заказе меняется остаток товара на складе при помощи того же триггера

--пример вставки удовлетворяющей условию
insert into order_list(order_id,item_list_id,quantity)
values(1,1,10);

update order_list
set quantity=90
where order_id=1; --пример где отработает триггер check_quantity и изменит остаток товара

update orders
set status='delivery'
where id=1; --3.2.5 заказ доставки. заказ переходит в статус "доставляется"

select o.id, o.customer_id, il.item_id, i.name, il.storage_id, ol.quantity
from order_list ol, orders o, item_list il, item i
where ol.order_id=o.id
and ol.item_list_id=il.id
and il.item_id=i.id
and o.status='delivery'; --3.4.1 заказы ожидающие доставки

select il.item_id, i.name, il.storage_id, il.quantity
from item i, item_list il
where il.item_id=i.id
and il.quantity<100; --3.4.2 товары заканчивающиеся на складах по заданному ограничению

select i.name, il.item_id, ol.order_id
from order_list ol, item_list il, item i
where ol.item_list_id=il.id
and il.item_id=i.id
and i.name not like 'milk'
and ol.order_id in
(select o.id
from orders o, item i, item_list il, order_list ol
where ol.order_id=o.id
and ol.item_list_id=il.id
and il.item_id=i.id
and i.name='milk')
; --3.5 предиктивная продажа. подзапрос ищет все номера заказов где было заказано молоко
--потом выводятся все продукты из отобранных заказов, исключая само молоко

select c.last_name, c.first_name, o.id as order_id, o.status, i.name, i.price, s.id as storage_id, ol.quantity
from orders o, order_list ol, customer c, item_list il, item i, storages s
where ol.order_id=o.id
and il.storage_id=s.id
and o.customer_id=c.id
and ol.item_list_id=il.id
and il.item_id=i.id
and o.customer_id=1; --3.2.6 список заказов пользователя

delete from storages
where id=2; --3.3.2 пример где отработает триггер delete_storage (закрытие склада)
--3.3.3 и переместит все товары из него в другой склад