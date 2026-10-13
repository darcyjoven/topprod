/*
================================================================================
檔案代號:vbh_file
檔案名稱:aps外包商資料
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vbh_file
(
vbh01       varchar2(10) DEFAULT ' ' NOT NULL, /*外包商编号*/
vbh02       varchar2(40) DEFAULT ' ' NOT NULL, /*外包商名称*/
vbh03       varchar2(40),            /*外包部描述                             */
vbh04       varchar2(60),            /*APS保留字段文字                        */
vbh05       varchar2(60),            /*APS保留字段文字                        */
vbh06       varchar2(60),            /*APS保留字段文字                        */
vbh07       number(9),               /*APS保留字段数值                        */
vbh08       number(18,8),            /*APS保留字段浮点数                      */
vbh09       number(18,8),            /*APS保留字段浮点数                      */
vbh10       date,                    /*APS保留字段日期                        */
vbh11       date,                    /*APS保留字段日期                        */
vbhlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vbhplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vbh_file add  constraint vbh_pk primary key  (vbhlegal,vbhplant,vbh01) enable validate;
grant select on vbh_file to tiptopgp;
grant update on vbh_file to tiptopgp;
grant delete on vbh_file to tiptopgp;
grant insert on vbh_file to tiptopgp;
grant index on vbh_file to public;
grant select on vbh_file to ods;
