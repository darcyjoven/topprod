create table cts_file
(
cts01       varchar2(40) NOT NULL, /*工单号*/
cts02       number(5) NOT NULL,  /*项次*/
cts03       varchar2(10),  /*类型*/
cts04       varchar2(1000),  /*路径、名称*/
cts05       varchar2(10),  /*状态*/
cts06       date, /*最后修改日期*/
cts07       varchar2(20), /*最后修改时间*/
cts08       varchar2(20),
cts09       varchar2(20),
cts10       varchar2(20),
cts11       number(15,3),
cts12       number(15,3),
cts13       date,
cts14       date,
cts15       date
);

alter table cts_file add  constraint cts_pk primary key  (cts01,cts02) enable validate;