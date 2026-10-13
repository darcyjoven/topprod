/*
================================================================================
檔案代號:vac_file
檔案名稱:aps 週行事曆
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vac_file
(
vac01       varchar2(60) DEFAULT ' ' NOT NULL, /*周行事历编号*/
vac02       varchar2(60) DEFAULT ' ' NOT NULL, /*星期一的工作模式编号*/
vac03       varchar2(60) DEFAULT ' ' NOT NULL, /*星期二的工作模式编号*/
vac04       varchar2(60) DEFAULT ' ' NOT NULL, /*星期三的工作模式编号*/
vac05       varchar2(60) DEFAULT ' ' NOT NULL, /*星期四的工作模式编号*/
vac06       varchar2(60) DEFAULT ' ' NOT NULL, /*星期五的工作模式编号*/
vac07       varchar2(60) DEFAULT ' ' NOT NULL, /*星期六的工作模式编号*/
vac08       varchar2(60) DEFAULT ' ' NOT NULL, /*星期日的工作模式编号*/
vac09       varchar2(60),            /*APS保留字段文字                        */
vac10       varchar2(60),            /*APS保留字段文字                        */
vac11       varchar2(60),            /*APS保留字段文字                        */
vac12       number(9),               /*APS保留字段数值                        */
vac13       number(18,8),            /*APS保留字段浮点数                      */
vac14       number(18,8),            /*APS保留字段浮点数                      */
vac15       date,                    /*APS保留字段日期                        */
vac16       date,                    /*APS保留字段日期                        */
vaclegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vacplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vac_file add  constraint vac_pk primary key  (vaclegal,vacplant,vac01) enable validate;
grant select on vac_file to tiptopgp;
grant update on vac_file to tiptopgp;
grant delete on vac_file to tiptopgp;
grant insert on vac_file to tiptopgp;
grant index on vac_file to public;
grant select on vac_file to ods;
