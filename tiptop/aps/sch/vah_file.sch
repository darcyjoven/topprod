/*
================================================================================
檔案代號:vah_file
檔案名稱:aps供給法則
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vah_file
(
vah01       varchar2(60) DEFAULT ' ' NOT NULL, /*供给法则编号*/
vah02       number(9) DEFAULT '0' NOT NULL, /*供给类型*/
vah03       varchar2(10) DEFAULT ' ' NOT NULL, /*仓库编号*/
vah04       varchar2(10) DEFAULT ' ' NOT NULL, /*库位编号*/
vah05       number(5),               /*供给优先顺序                           */
vah06       varchar2(60),            /*APS保留字段文字                        */
vah07       varchar2(60),            /*APS保留字段文字                        */
vah08       varchar2(60),            /*APS保留字段文字                        */
vah09       number(9),               /*APS保留字段数值                        */
vah10       number(18,8),            /*APS保留字段浮点数                      */
vah11       number(18,8),            /*APS保留字段浮点数                      */
vah12       date,                    /*APS保留字段日期                        */
vah13       date,                    /*APS保留字段日期                        */
vahlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vahplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vah_file add  constraint vah_pk primary key  (vahlegal,vahplant,vah01,vah02,vah03,vah04) enable validate;
grant select on vah_file to tiptopgp;
grant update on vah_file to tiptopgp;
grant delete on vah_file to tiptopgp;
grant insert on vah_file to tiptopgp;
grant index on vah_file to public;
grant select on vah_file to ods;
