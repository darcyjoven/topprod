/*
================================================================================
檔案代號:lup_file
檔案名稱:支出单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lup_file
(
lup01       varchar2(20) DEFAULT ' ' NOT NULL, /*支出单号*/
lup02       number(5) DEFAULT '0' NOT NULL, /*项次*/
lup03       varchar2(20),            /*来源单号                               */
lup04       number(5),               /*来源项次                               */
lup05       varchar2(10),            /*费用编号                               */
lup06       number(20,6),            /*支出金额                               */
lup07       number(20,6),            /*已退金额                               */
lup08       number(20,6),            /*清算金额                               */
lup09       varchar2(20),            /*清算单号                               */
luplegal    varchar2(10) NOT NULL,   /*法人                                   */
lupplant    varchar2(10) NOT NULL    /*门店编号                               */
);

alter table lup_file add  constraint lup_pk primary key  (lup01,lup02) enable validate;
grant select on lup_file to tiptopgp;
grant update on lup_file to tiptopgp;
grant delete on lup_file to tiptopgp;
grant insert on lup_file to tiptopgp;
grant index on lup_file to public;
grant select on lup_file to ods;
