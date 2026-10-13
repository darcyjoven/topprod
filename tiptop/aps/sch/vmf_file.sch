/*
================================================================================
檔案代號:vmf_file
檔案名稱:APS仓库维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vmf_file
(
vmf01       varchar2(10) DEFAULT ' ' NOT NULL, /*仓库编号*/
vmf04       number(1),               /*是否存货不可转移                       */
vmf05       number(1),               /*是否为主仓位                           */
vmf06       number(1),               /*是否为客供料                           */
vmf07       number(1)                /*是否受供给法则限制, 0;否 1:是          */
);

alter table vmf_file add  constraint vmf_pk primary key  (vmf01) enable validate;
grant select on vmf_file to tiptopgp;
grant update on vmf_file to tiptopgp;
grant delete on vmf_file to tiptopgp;
grant insert on vmf_file to tiptopgp;
grant index on vmf_file to public;
grant select on vmf_file to ods;
