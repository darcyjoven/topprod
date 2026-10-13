create table ctr_file
(
ctr01       varchar2(40) NOT NULL, /*工单号*/
ctr02       date, /*建立日期*/
ctr03       varchar2(20), /*姓名*/
ctr04       varchar2(100), /*邮箱*/
ctr05       varchar2(10), /*修改类型*/
ctr06       varchar2(10), /*来源*/
ctr07       varchar2(10), /*来源部门*/
ctr08       varchar2(1000), /*需求说明*/
ctr09       varchar2(10), /*需求单状态*/
ctr10       varchar2(20),
ctr11       varchar2(20),
ctr12       varchar2(20),
ctr13       varchar2(20),
ctr14       number(15,3),
ctr15       number(15,3),
ctr16       number(15,3),
ctr17       date,
ctr18       date,
ctr19       date,
ctr20       date,
ctr21       varchar2(40), /*创建者*/
ctr22       date,           /*创建日期*/
ctr23       varchar2(40),   /*创建时间*/
ctr24       varchar2(40), /*修改者*/
ctr25       date,           /*修改日期*/
ctr26       varchar2(40)    /*修改时间*/
);

alter table ctr_file add  constraint ctr_pk primary key  (ctr01) enable validate;