/*
================================================================================
檔案代號:tc_hraa_file
檔案名稱:人事考勤权限分配表
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table tc_hraa_file
(
tc_hraa01   varchar2(10) NOT NULL,   /*用户编号                               */
tc_hraa02   varchar2(80),            /*用户名称                               */
tc_hraa03   varchar2(10) NOT NULL    /*部门编号                               */
);

grant select on tc_hraa_file to tiptopgp;
grant update on tc_hraa_file to tiptopgp;
grant delete on tc_hraa_file to tiptopgp;
grant insert on tc_hraa_file to tiptopgp;
grant index on tc_hraa_file to public;
grant select on tc_hraa_file to ods;
