/*
================================================================================
檔案代號:azh_file
檔案名稱:报表抬头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table azh_file
(
azh01       varchar2(10) NOT NULL,   /*抬头代码                               */
                                     /*抬頭代碼                               */
azh02       varchar2(80)             /*抬头名称                               */
                                     /*抬頭名稱                               */
);

alter table azh_file add  constraint azh_pk primary key  (azh01) enable validate;
grant select on azh_file to tiptopgp;
grant update on azh_file to tiptopgp;
grant delete on azh_file to tiptopgp;
grant insert on azh_file to tiptopgp;
grant index on azh_file to public;
grant select on azh_file to ods;
