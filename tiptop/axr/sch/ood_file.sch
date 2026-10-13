/*
================================================================================
檔案代號:ood_file
檔案名稱:卡种对应会计科目
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ood_file
(
ood01       varchar2(10) DEFAULT ' ' NOT NULL, /*卡种编号*/
ood02       varchar2(24),            /*会计科目                               */
ood03       varchar2(24)             /*会计科目二                             */
);

alter table ood_file add  constraint ood_pk primary key  (ood01) enable validate;
grant select on ood_file to tiptopgp;
grant update on ood_file to tiptopgp;
grant delete on ood_file to tiptopgp;
grant insert on ood_file to tiptopgp;
grant index on ood_file to public;
grant select on ood_file to ods;
