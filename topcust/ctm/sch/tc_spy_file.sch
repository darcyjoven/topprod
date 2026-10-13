/*
================================================================================
檔案代號:tc_spy_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_spy_file
(
tc_spy01    varchar2(40) NOT NULL,   /*配货计划号                             */
tc_spy02    number(5) NOT NULL,      /*项次                                   */
tc_spy03    varchar2(40),            /*模板编号                               */
tc_spy04    varchar2(40),            /*料号                                   */
tc_spy05    number(15,3),            /*数量                                   */
tc_spy06    number(15,3),            /*实发量                                 */
tc_spy07    varchar2(255)            /*备注                                   */
);

create unique index tic_spy_01 on tc_spy_file (tc_spy01,tc_spy02);
alter table tc_spy_file add  constraint tpc_spy_pk primary key  (tc_spy01,tc_spy02) enable validate;
grant select on tc_spy_file to tiptopgp;
grant update on tc_spy_file to tiptopgp;
grant delete on tc_spy_file to tiptopgp;
grant insert on tc_spy_file to tiptopgp;
grant index on tc_spy_file to public;
grant select on tc_spy_file to ods;
