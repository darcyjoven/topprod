/*
================================================================================
檔案代號:lnc_file
檔案名稱:潜在商户品牌资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lnc_file
(
lnc00       varchar2(10),            /*来源门店编号                           */
lnc01       varchar2(20) DEFAULT ' ' NOT NULL, /*潜在商户单号*/
lnc02       varchar2(20) DEFAULT ' ' NOT NULL, /*品牌编号*/
lnc03       varchar2(10)             /*产地编号                               */
);

alter table lnc_file add  constraint lnc_pk primary key  (lnc01,lnc02) enable validate;
grant select on lnc_file to tiptopgp;
grant update on lnc_file to tiptopgp;
grant delete on lnc_file to tiptopgp;
grant insert on lnc_file to tiptopgp;
grant index on lnc_file to public;
grant select on lnc_file to ods;
