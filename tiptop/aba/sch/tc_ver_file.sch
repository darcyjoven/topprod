/*
================================================================================
檔案代號:tc_ver_file
檔案名稱:APP版本记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_ver_file
(
tc_ver00    varchar2(20) NOT NULL,   /*标识                                   */
tc_ver01    varchar2(1000),          /*更新地址                               */
tc_ver02    number(10,2),            /*版本号                                 */
tc_ver03    varchar2(20),            /*NO USE                                 */
tc_ver04    varchar2(20),            /*NO USE                                 */
tc_ver05    varchar2(20),            /*NO USE                                 */
tc_ver06    varchar2(5),             /*NO USE                                 */
tc_ver07    varchar2(20)             /*NO USE                                 */
);

alter table tc_ver_file add  constraint tpc_ver_pk primary key  (tc_ver00) enable validate;
grant select on tc_ver_file to tiptopgp;
grant update on tc_ver_file to tiptopgp;
grant delete on tc_ver_file to tiptopgp;
grant insert on tc_ver_file to tiptopgp;
grant index on tc_ver_file to public;
grant select on tc_ver_file to ods;
