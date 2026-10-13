/*
================================================================================
檔案代號:xsf_file
檔案名稱:促銷公告明細
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table xsf_file
(
xsf01       varchar2(20) DEFAULT ' ' NOT NULL, /*促销代码*/
xsf02       varchar2(10) DEFAULT ' ' NOT NULL /*下层组织代号*/
);

alter table xsf_file add  constraint xsf_pk primary key  (xsf01,xsf02) enable validate;
grant select on xsf_file to tiptopgp;
grant update on xsf_file to tiptopgp;
grant delete on xsf_file to tiptopgp;
grant insert on xsf_file to tiptopgp;
grant index on xsf_file to public;
grant select on xsf_file to ods;
