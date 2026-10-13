/*
================================================================================
檔案代號:vab_file
檔案名稱:aps 日行事曆
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vab_file
(
vab01       varchar2(60) DEFAULT ' ' NOT NULL, /*日行事历编号*/
vab02       date DEFAULT sysdate NOT NULL, /*日期*/
vab03       varchar2(60),            /*工作模式                               */
vab04       varchar2(60),            /*APS保留字段文字                        */
vab05       varchar2(60),            /*APS保留字段文字                        */
vab06       varchar2(60),            /*APS保留字段文字                        */
vab07       number(9),               /*APS保留字段数值                        */
vab08       number(18,8),            /*APS保留字段浮点数                      */
vab09       number(18,8),            /*APS保留字段浮点数                      */
vab10       date,                    /*APS保留字段日期                        */
vab11       date,                    /*APS保留字段日期                        */
vablegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vabplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vab_file add  constraint vab_pk primary key  (vablegal,vabplant,vab01,vab02) enable validate;
grant select on vab_file to tiptopgp;
grant update on vab_file to tiptopgp;
grant delete on vab_file to tiptopgp;
grant insert on vab_file to tiptopgp;
grant index on vab_file to public;
grant select on vab_file to ods;
