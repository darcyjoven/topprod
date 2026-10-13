/*
================================================================================
檔案代號:vat_file
檔案名稱:aps(預測群組沖銷)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vat_file
(
vat01       varchar2(40) DEFAULT ' ' NOT NULL, /*主冲销料号*/
vat02       varchar2(40) DEFAULT ' ' NOT NULL, /*被冲销料号*/
vat03       varchar2(60),            /*APS保留字段文字                        */
vat04       varchar2(60),            /*APS保留字段文字                        */
vat05       varchar2(60),            /*APS保留字段文字                        */
vat06       number(9),               /*APS保留字段数值                        */
vat07       number(18,8),            /*APS保留字段浮点数                      */
vat08       number(18,8),            /*APS保留字段浮点数                      */
vat09       date,                    /*APS保留字段日期                        */
vat10       date,                    /*APS保留字段日期                        */
vatlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vatplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vat_file add  constraint vat_pk primary key  (vatlegal,vatplant,vat01,vat02) enable validate;
grant select on vat_file to tiptopgp;
grant update on vat_file to tiptopgp;
grant delete on vat_file to tiptopgp;
grant insert on vat_file to tiptopgp;
grant index on vat_file to public;
grant select on vat_file to ods;
