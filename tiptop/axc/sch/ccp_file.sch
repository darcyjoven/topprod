/*
================================================================================
檔案代號:ccp_file
檔案名稱:各月份使用标准成本版本设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ccp_file
(
ccp01       number(5) NOT NULL,      /*年度                                   */
ccp02       number(5) NOT NULL,      /*月份                                   */
ccp03       varchar2(10)             /*标准成本版本                           */
                                     /*標準成本版本                           */
);

alter table ccp_file add  constraint ccp_pk primary key  (ccp01,ccp02) enable validate;
grant select on ccp_file to tiptopgp;
grant update on ccp_file to tiptopgp;
grant delete on ccp_file to tiptopgp;
grant insert on ccp_file to tiptopgp;
grant index on ccp_file to public;
grant select on ccp_file to ods;
