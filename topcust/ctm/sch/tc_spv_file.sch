/*
================================================================================
檔案代號:tc_spv_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_spv_file
(
tc_spv01    varchar2(40) NOT NULL,   /*模板编号                               */
tc_spv02    varchar2(40) NOT NULL,   /*模板名称                               */
tc_spv03    date,                    /*建立日期                               */
tc_spv04    varchar2(40),            /*建立人                                 */
tc_spv05    varchar2(40),            /*配货计划号                             */
tc_spv06    number(5) NOT NULL,      /*项次                                   */
tc_spv07    varchar2(40),            /*料号                                   */
tc_spv08    number(15,3),            /*数量                                   */
tc_spv09    varchar2(255),           /*备注                                   */
tc_spv10    varchar2(40)             /*客户编号                               */
);

create unique index tic_spv_01 on tc_spv_file (tc_spv01,tc_spv06);
alter table tc_spv_file add  constraint tpc_spv_pk primary key  (tc_spv01,tc_spv06) enable validate;
grant select on tc_spv_file to tiptopgp;
grant update on tc_spv_file to tiptopgp;
grant delete on tc_spv_file to tiptopgp;
grant insert on tc_spv_file to tiptopgp;
grant index on tc_spv_file to public;
grant select on tc_spv_file to ods;
