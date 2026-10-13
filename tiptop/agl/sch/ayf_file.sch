/*
================================================================================
檔案代號:ayf_file
檔案名稱:合并财报会计科目-区分部门别
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ayf_file
(
ayf00       varchar2(5) DEFAULT ' ' NOT NULL,
ayf01       varchar2(10) DEFAULT ' ' NOT NULL, /*母公司编号*/
ayf02       varchar2(10) DEFAULT ' ' NOT NULL,
ayf03       varchar2(10) DEFAULT ' ' NOT NULL,
ayf04       varchar2(24) DEFAULT ' ' NOT NULL,
ayf05       varchar2(120),
ayf06       varchar2(24),
ayf07       varchar2(1) DEFAULT ' ' NOT NULL,
ayf08       varchar2(1) DEFAULT ' ' NOT NULL,
ayf09       varchar2(10) DEFAULT ' ' NOT NULL, /*集团代号*/
ayfacti     varchar2(1) DEFAULT ' ' NOT NULL,
ayfgrup     varchar2(10),
ayfmodu     varchar2(10),
ayforiu     varchar2(10),
ayfuser     varchar2(10),
ayfdate     date,
ayforig     varchar2(10),
ayf10       number(5) DEFAULT '0' NOT NULL, /*年度*/
ayf11       number(5) DEFAULT '0' NOT NULL /*期别*/
);

alter table ayf_file add  constraint ayf_pk primary key  (ayf00,ayf01,ayf02,ayf03,ayf04,ayf09,ayf10,ayf11) enable validate;
grant select on ayf_file to tiptopgp;
grant update on ayf_file to tiptopgp;
grant delete on ayf_file to tiptopgp;
grant insert on ayf_file to tiptopgp;
grant index on ayf_file to public;
grant select on ayf_file to ods;
