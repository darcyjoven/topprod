/*
================================================================================
檔案代號:val_file
檔案名稱:aps品項分配法則
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table val_file
(
val01       varchar2(40) DEFAULT ' ' NOT NULL, /*完成品料号*/
val02       varchar2(60) DEFAULT ' ' NOT NULL, /*分配法则编号*/
val03       varchar2(40) DEFAULT ' ' NOT NULL, /*为part_id本身或其下阶料号*/
val04       varchar2(60) DEFAULT ' ' NOT NULL, /*供给法则编号*/
val05       number(1),               /*是否视为无供给法则 0：否 1：           */
val06       varchar2(60),            /*APS保留字段文字                        */
val07       varchar2(60),            /*APS保留字段文字                        */
val08       varchar2(60),            /*APS保留字段文字                        */
val09       number(9),               /*APS保留字段数值                        */
val10       number(18,8),            /*APS保留字段浮点数                      */
val11       number(18,8),            /*APS保留字段浮点数                      */
val12       date,                    /*APS保留字段日期                        */
val13       date,                    /*APS保留字段日期                        */
vallegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
valplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table val_file add  constraint val_pk primary key  (vallegal,valplant,val01,val02,val03,val04) enable validate;
grant select on val_file to tiptopgp;
grant update on val_file to tiptopgp;
grant delete on val_file to tiptopgp;
grant insert on val_file to tiptopgp;
grant index on val_file to public;
grant select on val_file to ods;
