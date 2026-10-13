/*
================================================================================
檔案代號:amj_file
檔案名稱:促销条码设定单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table amj_file
(
amj01       varchar2(10) DEFAULT ' ' NOT NULL, /*客户编号*/
amj02       date DEFAULT sysdate NOT NULL, /*生效日期*/
amj03       date DEFAULT sysdate,    /*失效日期                               */
amj04       varchar2(40) DEFAULT ' ' NOT NULL, /*促销条码*/
amj05       varchar2(40) DEFAULT ' ' NOT NULL /*产品编号*/
);

alter table amj_file add  constraint amj_pk primary key  (amj01,amj02,amj04,amj05) enable validate;
grant select on amj_file to tiptopgp;
grant update on amj_file to tiptopgp;
grant delete on amj_file to tiptopgp;
grant insert on amj_file to tiptopgp;
grant index on amj_file to public;
grant select on amj_file to ods;
