/*
================================================================================
檔案代號:tc_gee_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table tc_gee_file
(
tc_gee01    varchar2(10) DEFAULT ' ' NOT NULL, /*模组代码*/
tc_gee02    varchar2(2) DEFAULT ' ' NOT NULL, /*单据性质*/
tc_gee03    varchar2(80),            /*单据性质说明                           */
tc_gee04    varchar2(15),            /*单据别参考档案                         */
tc_gee05    varchar2(20),            /*单据别参考栏位                         */
tc_gee06    varchar2(20),            /*核准参考栏位                           */
tc_gee07    varchar2(20),            /*核准参考值                             */
tc_gee08    varchar2(20),            /*过账参考栏位                           */
tc_gee09    varchar2(20),            /*过账参考值                             */
tc_gee10    varchar2(20),            /*单身参考档案                           */
tc_gee11    varchar2(300),           /*关联条件                               */
tc_gee12    varchar2(20),            /*日期参考栏位                           */
tc_geeacti  varchar2(1)              /*有效码                                 */
);

create unique index tic_gee_01 on tc_gee_file (tc_gee01,tc_gee02);
alter table tc_gee_file add  constraint tpc_gee_pk primary key  (tc_gee01,tc_gee02) enable validate;
grant select on tc_gee_file to tiptopgp;
grant update on tc_gee_file to tiptopgp;
grant delete on tc_gee_file to tiptopgp;
grant insert on tc_gee_file to tiptopgp;
grant index on tc_gee_file to public;
grant select on tc_gee_file to ods;
