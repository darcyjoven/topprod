/*
================================================================================
檔案代號:vij_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vij_file
(
vij01       varchar2(10) NOT NULL,   /*积分使用规则编码                       */
vij02       number(5) NOT NULL,      /*项次                                   */
vij03       varchar2(40),            /*料件编号                               */
vij04       number(10)               /*所需积分                               */
);

alter table vij_file add  constraint vij_pk primary key  (vij01,vij02) enable validate;
grant select on vij_file to tiptopgp;
grant update on vij_file to tiptopgp;
grant delete on vij_file to tiptopgp;
grant insert on vij_file to tiptopgp;
grant index on vij_file to public;
grant select on vij_file to ods;
