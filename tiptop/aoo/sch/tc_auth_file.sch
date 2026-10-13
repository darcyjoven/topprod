/*
================================================================================
檔案代號:tc_auth_file
檔案名稱:用户权限档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_auth_file
(
tc_auth01   varchar2(10) NOT NULL,   /*账号                                   */
tc_auth02   varchar2(1) NOT NULL,    /*权限类别                               */
tc_auth03   varchar2(10) NOT NULL,   /*类别代码                               */
tc_auth04   varchar2(80)             /*名称                                   */
);

create unique index tic_auth_01 on tc_auth_file (tc_auth01,tc_auth02,tc_auth03);
alter table tc_auth_file add  constraint tpc_auth_pk primary key  (tc_auth01,tc_auth02,tc_auth03) enable validate;
grant select on tc_auth_file to tiptopgp;
grant update on tc_auth_file to tiptopgp;
grant delete on tc_auth_file to tiptopgp;
grant insert on tc_auth_file to tiptopgp;
grant index on tc_auth_file to public;
grant select on tc_auth_file to ods;
