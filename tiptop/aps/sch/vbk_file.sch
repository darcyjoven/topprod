/*
================================================================================
檔案代號:vbk_file
檔案名稱:工模具群組主檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vbk_file
(
vbk01       varchar2(60) NOT NULL,   /*工模具群组描述                         */
vbk02       varchar2(60),            /*工模具群组名称                         */
vbk03       varchar2(60),            /*工模具群组描述                         */
vbk04       varchar2(60),            /*APS保留字段文字                        */
vbk05       varchar2(60),            /*APS保留字段文字                        */
vbk06       varchar2(60),            /*APS保留字段文字                        */
vbk07       number(9),               /*APS保留字段数值                        */
vbk08       number(18,8),            /*APS保留字段浮点数                      */
vbk09       number(18,8),            /*APS保留字段浮点数                      */
vbk10       date,                    /*APS保留字段日期                        */
vbk11       date,                    /*APS保留字段日期                        */
vbklegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vbkplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vbk_file add  constraint vbk_pk primary key  (vbklegal,vbkplant,vbk01) enable validate;
grant select on vbk_file to tiptopgp;
grant update on vbk_file to tiptopgp;
grant delete on vbk_file to tiptopgp;
grant insert on vbk_file to tiptopgp;
grant index on vbk_file to public;
grant select on vbk_file to ods;
