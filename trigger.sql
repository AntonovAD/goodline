create or replace trigger check_quantity
  before
    insert or update or delete
    on order_list
  for each row
  declare
    cq item_list.quantity%type;
begin
  select il.quantity into cq
  from item_list il
  where il.id=:new.item_list_id;
  
case
  when inserting then
  if :new.quantity<=cq then
    :new.quantity := :new.quantity;
    update item_list
    set quantity=quantity-:new.quantity
    where id=:new.item_list_id;
  else
    raise_application_error(-20000,'Not enough item');
  end if;

  when updating ('quantity') then
  if :new.quantity<=cq+:old.quantity then
    :new.quantity := :new.quantity;
    update item_list
    set quantity=quantity-(:new.quantity-:old.quantity)
    where id=:new.item_list_id;
  else
    raise_application_error(-20000,'Not enough item');
  end if;

  when deleting then
  update item_list
  set quantity=quantity+:old.quantity
  where id=:old.item_list_id;
end case;
end;
/

create or replace trigger delete_storage
  for delete
  on storages
  compound trigger
    flag  boolean;
    n item_list.item_id%type;
    i item_list.item_id%type;
    m item_list.storage_id%type;
    o storages.id%type;
 
  before each row is
  begin
      flag := true;
      o := :old.id;
  end before each row;

  after statement is
  begin
    if flag then

  select count(*) into n
  from item_list
  where storage_id=o
  group by item_id;

  for cntr in 1..n
  loop

  select min(item_id) into i
  from item_list
  where storage_id=o
  group by item_id;

  select min(id) into m
  from storages
  where id!=o;

  update item_list
  set storage_id=m
  where item_id=i
  and storage_id=o;

  end loop;

    end if;
  end after statement;
end delete_storage;
/