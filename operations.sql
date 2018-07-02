select *
from item;

insert into item
values (item_seq.NEXTVAL, 'milk', 115);

update item
set price=120
where name='milk';

delete from item
where name='milk';