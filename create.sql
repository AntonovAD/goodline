create table item
(id number (3)
constraint item_id_pk primary key,
name varchar2 (50)
constraint item_name_nn not null,
price number (6)
constraint item_price_nn not null
);

create table customer
(id number (3)
constraint customer_id_pk primary key,
last_name varchar2 (25)
constraint customer_last_name_nn not null,
first_name varchar2 (25)
constraint customer_first_name_nn not null,
patronymic varchar2 (25)
constraint customer_patronymic_nn not null,
address varchar2 (25)
constraint customer_address_nn not null,
telephone number (11)
constraint customer_telephone_nn not null
);

create table storage
(id number (3)
constraint storage_id_pk primary key,
address varchar2 (50)
constraint storage_address_nn not null
);

create table item_list
(id number (3)
constraint item_list_id_pk primary key,
item_id number (3)
constraint item_list_item_id_nn not null,
constraint item_list_item_id_fk foreign key (item_id) references item (id),
storage_id number (3)
constraint item_list_storage_id_nn not null,
constraint item_list_storage_id_fk foreign key (storage_id) references storage (id),
quantity number (6)
constraint item_list_quantity_nn not null
);

create table orders
(id number (3)
constraint orders_id_pk primary key,
customer_id number (3)
constraint orders_customer_id_nn not null,
constraint orders_customer_id_fk foreign key (customer_id) references customer (id),
status varchar2 (25)
constraint orders_status_nn not null
);

create table order_list
(order_id number (3),
item_list_id number (3),
quantity number (6)
constraint order_list_quantity_nn not null
);

alter table order_list
add constraint order_list_pk primary key (order_id, item_list_id);

alter table order_list
add constraint order_list_order_id_fk foreign key (order_id) references orders (id);

alter table order_list
add constraint order_list_item_list_id_fk foreign key (item_list_id) references item_list (id);
