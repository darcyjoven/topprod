/*
================================================================================
檔案代號:vmq_file
檔案名稱:单品/万用取替代维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vmq_file
(
vmq01       varchar2(40) DEFAULT ' ' NOT NULL, /*主件品号*/
vmq02       varchar2(40) DEFAULT ' ' NOT NULL, /*元件品号*/
vmq03       varchar2(40) DEFAULT ' ' NOT NULL, /*取替代料品号（元件）*/
vmq11       number(18,8)             /*替代比率                               */
);

alter table vmq_file add  constraint vmq_pk primary key  (vmq01,vmq02,vmq03) enable validate;
grant select on vmq_file to tiptopgp;
grant update on vmq_file to tiptopgp;
grant delete on vmq_file to tiptopgp;
grant insert on vmq_file to tiptopgp;
grant index on vmq_file to public;
grant select on vmq_file to ods;
