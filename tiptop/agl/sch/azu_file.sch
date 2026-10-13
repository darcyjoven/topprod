/*
================================================================================
檔案代號:azu_file
檔案名稱:用户执行记录查询
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table azu_file
(
azu00       varchar2(100) DEFAULT ' ' NOT NULL, /*唯一标识号*/
azu01       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
azu02       varchar2(10),            /*法人                                   */
azu03       varchar2(10) DEFAULT ' ' NOT NULL, /*Module*/
azu04       date DEFAULT sysdate NOT NULL, /*操作日期*/
azu05       varchar2(10) DEFAULT ' ' NOT NULL, /*操作时间*/
azu06       date,                    /*结束日期                               */
azu07       varchar2(10),            /*结束时间                               */
azu08       number(10),              /*时长(分钟)                             */
azu09       varchar2(20) DEFAULT ' ' NOT NULL, /*作业编号*/
azu10       varchar2(40),            /*单据编号                               */
azu11       varchar2(20) DEFAULT ' ' NOT NULL, /*人员编号*/
azu12       varchar2(10) DEFAULT ' ' NOT NULL, /*操作类型*/
azu13       varchar2(1) DEFAULT ' ' NOT NULL, /*来源类型*/
azu14       varchar2(20),            /*关联单号                               */
azu15       varchar2(40) DEFAULT ' ' NOT NULL, /*IP地址*/
azu16       varchar2(1000)           /*备注                                   */
);

create        index azu_03 on azu_file (azu00);
create        index azu_02 on azu_file (azu11);
create        index azu_01 on azu_file (azu09,azu10);
alter table azu_file add  constraint azu_pk primary key  (azu00,azu01,azu03,azu04,azu05,azu09,azu11,azu12,azu13,azu15) enable validate;
grant select on azu_file to tiptopgp;
grant update on azu_file to tiptopgp;
grant delete on azu_file to tiptopgp;
grant insert on azu_file to tiptopgp;
grant index on azu_file to public;
grant select on azu_file to ods;
