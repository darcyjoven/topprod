/*
================================================================================
檔案代號:oog_file
檔案名稱:券种对应会计科目
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oog_file
(
oog01       varchar2(10) DEFAULT ' ' NOT NULL, /*券种编号*/
oog02       varchar2(24),            /*会计科目                               */
oog03       varchar2(24)             /*会计科目二                             */
);

alter table oog_file add  constraint oog_pk primary key  (oog01) enable validate;
grant select on oog_file to tiptopgp;
grant update on oog_file to tiptopgp;
grant delete on oog_file to tiptopgp;
grant insert on oog_file to tiptopgp;
grant index on oog_file to public;
grant select on oog_file to ods;
