/*
================================================================================
檔案代號:bxs_file
檔案名稱:保税仓库编号档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bxs_file
(
bxs01       varchar2(10) NOT NULL,   /*保税仓库代码                           */
bxs02       varchar2(80),            /*保税仓库名称                           */
bxs03       varchar2(1)              /*No Use                                 */
);

alter table bxs_file add  constraint bxs_pk primary key  (bxs01) enable validate;
grant select on bxs_file to tiptopgp;
grant update on bxs_file to tiptopgp;
grant delete on bxs_file to tiptopgp;
grant insert on bxs_file to tiptopgp;
grant index on bxs_file to public;
grant select on bxs_file to ods;
