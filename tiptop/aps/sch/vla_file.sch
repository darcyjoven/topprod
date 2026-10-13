/*
================================================================================
檔案代號:vla_file
檔案名稱:APS系统参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vla_file
(
vla01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
vla02       date,                    /*基本资料最后异动日                     */
vlalegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vlaplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vla_file add  constraint vla_pk primary key  (vla01) enable validate;
grant select on vla_file to tiptopgp;
grant update on vla_file to tiptopgp;
grant delete on vla_file to tiptopgp;
grant insert on vla_file to tiptopgp;
grant index on vla_file to public;
grant select on vla_file to ods;
