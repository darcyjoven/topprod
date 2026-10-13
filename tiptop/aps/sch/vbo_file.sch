/*
================================================================================
檔案代號:vbo_file
檔案名稱:工模具大類主檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vbo_file
(
vbo01       varchar2(60) NOT NULL,   /*工模具大类编号                         */
vbo02       varchar2(60),            /*工模具大类名称                         */
vbo03       varchar2(60),            /*工模具大类名称                         */
vbo04       number(1),               /*产能类型                               */
vbo05       varchar2(60),            /*APS保留字段文字                        */
vbo06       varchar2(60),            /*APS保留字段文字                        */
vbo07       varchar2(60),            /*APS保留字段文字                        */
vbo08       number(9),               /*APS保留字段数值                        */
vbo09       number(18,8),            /*APS保留字段浮点数                      */
vbo10       number(18,8),            /*APS保留字段浮点数                      */
vbo11       date,                    /*APS保留字段日期                        */
vbo12       date,                    /*APS保留字段日期                        */
vbolegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vboplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vbo_file add  constraint vbo_pk primary key  (vbolegal,vboplant,vbo01) enable validate;
grant select on vbo_file to tiptopgp;
grant update on vbo_file to tiptopgp;
grant delete on vbo_file to tiptopgp;
grant insert on vbo_file to tiptopgp;
grant index on vbo_file to public;
grant select on vbo_file to ods;
