/*
================================================================================
檔案代號:tc_authg_file
檔案名稱:用户权限档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_authg_file
(
tc_authg01  varchar2(10) NOT NULL,   /*权限类别                               */
tc_authg02  varchar2(80),            /*权限类别说明                           */
tc_authg03  varchar2(10) NOT NULL    /*作业编号                               */
);

create unique index tic_authg_01 on tc_authg_file (tc_authg01,tc_authg03);
alter table tc_authg_file add  constraint tpc_authg_pk primary key  (tc_authg01,tc_authg03) enable validate;
grant select on tc_authg_file to tiptopgp;
grant update on tc_authg_file to tiptopgp;
grant delete on tc_authg_file to tiptopgp;
grant insert on tc_authg_file to tiptopgp;
grant index on tc_authg_file to public;
grant select on tc_authg_file to ods;
