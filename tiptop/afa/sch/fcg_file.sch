/*
================================================================================
檔案代號:fcg_file
檔案名稱:固定资产解除设置单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fcg_file
(
fcg01       varchar2(30) NOT NULL,   /*解除文号                               */
fcg02       number(5) NOT NULL,      /*项次                                   */
fcg03       varchar2(10),            /*财产编号                               */
fcg031      varchar2(4),             /*附号                                   */
fcg04       varchar2(20),            /*申请编号                               */
fcg041      number(5),               /*申请项次                               */
fcg05       number(20,6),            /*抵押金额                               */
fcg06       date,                    /*清偿日期                               */
fcg07       varchar2(10),            /*解除原因                               */
fcglegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table fcg_file add  constraint fcg_pk primary key  (fcg01,fcg02) enable validate;
grant select on fcg_file to tiptopgp;
grant update on fcg_file to tiptopgp;
grant delete on fcg_file to tiptopgp;
grant insert on fcg_file to tiptopgp;
grant index on fcg_file to public;
grant select on fcg_file to ods;
