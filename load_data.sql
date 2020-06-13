create table bill(
	billdate date not null,
    billnumber varchar(20) primary key default'-',
    shopname varchar(20),
    billdiscount float not null default 0,
    paytime time not null,
    tablenumber int,
    peoplecount int not null default 0
);

truncate table orderdetail;
load data local infile 'D:\\SQL\\load_file\\data_ct\\-order.csv' 
into table orderdetail
fields terminated by ',';