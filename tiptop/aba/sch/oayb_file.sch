/*
================================================================================
檔案代號:oayb_file
檔案名稱:销售系统单据性质-条码相关资料档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oayb_file
(
oayb01      varchar2(5),             /*出货单别                               */
oaybslip    varchar2(5) DEFAULT ' ' NOT NULL /*单别*/
);

alter table oayb_file add  constraint oayb_pk primary key  (oaybslip) enable validate;
grant select on oayb_file to tiptopgp;
grant update on oayb_file to tiptopgp;
grant delete on oayb_file to tiptopgp;
grant insert on oayb_file to tiptopgp;
grant index on oayb_file to public;
grant select on oayb_file to ods;
