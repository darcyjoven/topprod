/*
================================================================================
檔案代號:pkb_file
檔案名稱:部门会计科目档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pkb_file
(
pkb01       varchar2(10) DEFAULT ' ' NOT NULL,
pkb02       varchar2(24),
pkbacti     varchar2(1) DEFAULT 'Y' NOT NULL,
pkbdate     date,
pkbgrup     varchar2(10),
pkbmodu     varchar2(10),
pkbuser     varchar2(10)
);

alter table pkb_file add  constraint pkb_pk primary key  (pkb01) enable validate;
grant select on pkb_file to tiptopgp;
grant update on pkb_file to tiptopgp;
grant delete on pkb_file to tiptopgp;
grant insert on pkb_file to tiptopgp;
grant index on pkb_file to public;
grant select on pkb_file to ods;
