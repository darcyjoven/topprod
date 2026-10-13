/*
================================================================================
檔案代號:cxk_file
檔案名稱:转拨单价档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cxk_file
(
cxk01       varchar2(40) NOT NULL,   /*料号                                   */
cxk02       varchar2(120),           /*品名                                   */
cxk03       varchar2(120),           /*规格                                   */
cxk04       number(20,6),            /*调拨单价                               */
cxk05       date                     /*建立日期                               */
);

alter table cxk_file add  constraint cxk_pk primary key  (cxk01) enable validate;
grant select on cxk_file to tiptopgp;
grant update on cxk_file to tiptopgp;
grant delete on cxk_file to tiptopgp;
grant insert on cxk_file to tiptopgp;
grant index on cxk_file to public;
grant select on cxk_file to ods;
