/*
================================================================================
檔案代號:tc_imd_file
檔案名稱:在制LOT清单交接第三页签表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_imd_file
(
tc_imd01    varchar2(40) NOT NULL,   /*交接单号                               */
tc_imd02    number(10) NOT NULL,     /*项次                                   */
tc_imd03    varchar2(40),            /*料件编码                               */
tc_imd04    number(15,3)             /*数量                                   */
);

alter table tc_imd_file add  constraint tpc_imd_pk primary key  (tc_imd01,tc_imd02) enable validate;
grant select on tc_imd_file to tiptopgp;
grant update on tc_imd_file to tiptopgp;
grant delete on tc_imd_file to tiptopgp;
grant insert on tc_imd_file to tiptopgp;
grant index on tc_imd_file to public;
grant select on tc_imd_file to ods;
