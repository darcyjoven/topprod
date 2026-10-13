/*
================================================================================
檔案代號:vaj_file
檔案名稱:aps實體庫存
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vaj_file
(
vaj01       varchar2(40) DEFAULT ' ' NOT NULL, /*料号*/
vaj02       varchar2(10) DEFAULT ' ' NOT NULL, /*仓库编号*/
vaj03       varchar2(10) DEFAULT ' ' NOT NULL, /*库位编号*/
vaj04       number(15,3),            /*可用量                                 */
vaj05       varchar2(60),            /*库房位置                               */
vaj06       varchar2(60),            /*APS保留字段文字                        */
vaj07       varchar2(60),            /*APS保留字段文字                        */
vaj08       varchar2(60),            /*APS保留字段文字                        */
vaj09       number(9),               /*APS保留字段数值                        */
vaj10       number(18,8),            /*APS保留字段浮点数                      */
vaj11       number(18,8),            /*APS保留字段浮点数                      */
vaj12       date,                    /*APS保留字段日期                        */
vaj13       date,                    /*APS保留字段日期                        */
vajlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vajplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vaj_file add  constraint vaj_pk primary key  (vajlegal,vajplant,vaj01,vaj02,vaj03) enable validate;
grant select on vaj_file to tiptopgp;
grant update on vaj_file to tiptopgp;
grant delete on vaj_file to tiptopgp;
grant insert on vaj_file to tiptopgp;
grant index on vaj_file to public;
grant select on vaj_file to ods;
