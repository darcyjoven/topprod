/*
================================================================================
檔案代號:luf_file
檔案名稱:正式商户品牌资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table luf_file
(
luf00       varchar2(10),            /*来源门店编号                           */
luf01       varchar2(10) DEFAULT ' ' NOT NULL, /*商户号*/
luf02       varchar2(20) DEFAULT ' ' NOT NULL, /*版本号*/
luf03       varchar2(10) DEFAULT ' ' NOT NULL, /*品牌号*/
luf04       varchar2(10)             /*产地编号                               */
);

alter table luf_file add  constraint luf_pk primary key  (luf01,luf02,luf03) enable validate;
grant select on luf_file to tiptopgp;
grant update on luf_file to tiptopgp;
grant delete on luf_file to tiptopgp;
grant insert on luf_file to tiptopgp;
grant index on luf_file to public;
grant select on luf_file to ods;
