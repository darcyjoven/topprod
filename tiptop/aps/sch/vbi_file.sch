/*
================================================================================
檔案代號:vbi_file
檔案名稱:aps工作站
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vbi_file
(
vbi01       varchar2(10) DEFAULT ' ' NOT NULL, /*工作站编号*/
vbi02       varchar2(10),            /*存放位置                               */
vbi03       varchar2(40),            /*工作站名称                             */
vbi04       varchar2(40),            /*工作站描述                             */
vbi05       number(9),               /*cpt界面上的排序号                      */
vbi06       varchar2(60),            /*APS保留字段文字                        */
vbi07       varchar2(60),            /*APS保留字段文字                        */
vbi08       varchar2(60),            /*APS保留字段文字                        */
vbi09       number(9),               /*APS保留字段数值                        */
vbi10       number(18,8),            /*APS保留字段浮点数                      */
vbi11       number(18,8),            /*APS保留字段浮点数                      */
vbi12       date,                    /*APS保留字段日期                        */
vbi13       date,                    /*APS保留字段日期                        */
vbilegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vbiplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vbi_file add  constraint vbi_pk primary key  (vbilegal,vbiplant,vbi01) enable validate;
grant select on vbi_file to tiptopgp;
grant update on vbi_file to tiptopgp;
grant delete on vbi_file to tiptopgp;
grant insert on vbi_file to tiptopgp;
grant index on vbi_file to public;
grant select on vbi_file to ods;
