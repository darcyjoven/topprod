/*
================================================================================
檔案代號:astt_file
檔案名稱:来源科目MISC明细科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table astt_file
(
astt00      varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
astt01      varchar2(24) DEFAULT ' ' NOT NULL, /*来源科目编号*/
astt03      varchar2(24) DEFAULT ' ' NOT NULL /*来源科目misc明细科目*/
);

alter table astt_file add  constraint astt_pk primary key  (astt00,astt01,astt03) enable validate;
grant select on astt_file to tiptopgp;
grant update on astt_file to tiptopgp;
grant delete on astt_file to tiptopgp;
grant insert on astt_file to tiptopgp;
grant index on astt_file to public;
grant select on astt_file to ods;
