create table ctt_file
(
ctt01       varchar2(40) NOT NULL, /*工单号*/
ctt02       date NOT NULL,/*异动日期*/
ctt03       varchar2(20) NOT NULL,/*异动时间*/
ctt04       varchar2(40), /*异动人员*/
ctt05       varchar2(10), /*异动类型*/
ctt06       varchar2(1000), /*异动内容*/
ctt07       varchar2(100), /*对应git单号*/
ctt08       varchar2(1000), /*补充说明*/
ctt09       varchar2(20),
ctt10       varchar2(20),
ctt11       number(15,3),
ctt12       number(15,3),
ctt13       date,
ctt14       date,
ctt15       date
);

alter table ctt_file add  constraint ctt_pk primary key  (ctt01,ctt02,ctt03) enable validate;