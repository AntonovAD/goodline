create or replace trigger check_q
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
