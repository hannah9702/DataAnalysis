# 计算每条billnumber订单号下的消费总额spay
drop table ordergroup;
create table ordergroup(
	select o.billnumber,sum(o.pay) spay
	from orderdetail o
	group by o.billnumber
);

# 将OrderGroup表中的pay字段合并到Bill表中，并使用pay与billdiscount字段计算出折扣金额
drop table newbill;
create table newbill(
	select b.*,o.spay,o.spay*b.billdiscount rebate
	from ctdb.bill b
	left join ctdb.ordergroup o on b.billnumber = o.billnumber
);


# 总座位数
drop table newshopdetail;
create table newshopdetail(
	select s.*, (s.twotable*2 + threetable*3 + fourtable*6) allseats
    from shopdetail s
 ); 

# 为orderdetail表添加菜品消费的所属店铺
drop table ctdb.neworderdedtail;
create table neworderdedtail(
select o.*, b.shopname
from bill b
right join orderdetail o on o.billnumber = b.billnumber
);

# 用NewBill表与NewShopDetail表创建店汇总信息表
drop table shoptotal;
create table shoptotal(
	select b.shopname 店名, 
		   count(b.billnumber) 单数,
		   sum(b.peoplecount) 人数,
		   sum(b.rebate) 折扣总金额,
		   sum(b.spay) 店汇总金额,
		   sum(b.spay)/count(b.billnumber) 单均消费,
		   sum(b.spay)/sum(b.peoplecount) 人均消费,
		   s.alltable 总台数,
		   s.allseats 总座位数,
		   count(b.billnumber)/s.alltable 翻台率,
		   sum(b.peoplecount)/s.allseats 上座率,
		   sum(b.rebate)/sum(b.spay) 折扣率
	from newbill b
	left join newshopdetail s on b.shopname = s.shopname
    group by b.shopname
);

# 清洗订单的时间段
alter table newbill add column paytimezone int not null;
update newbill set paytimezone = hour(paytime);

# 目标达成比例
update target t set rate=t.sumsale/t.target;
