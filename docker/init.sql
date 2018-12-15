create sequence hibernate_sequence start with 1 increment by 1;
create table greeting (id bigint not null, say varchar(255), primary key (id));

insert into greeting(id,say) values(1,'Hello from PG');
insert into greeting(id,say) values(2,'Hi from PG');
insert into greeting(id,say) values(3,'Howdy! from PG');
insert into greeting(id,say) values(4,'Howdy, Howdy! from PG');