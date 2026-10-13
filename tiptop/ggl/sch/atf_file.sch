/*
================================================================================
檔案代號:atf_file
檔案名稱:合并流量表直接法存档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table atf_file
(
atf01       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
atf02       varchar2(10) DEFAULT ' ' NOT NULL, /*最上层公司编号*/
atf03       number(5) DEFAULT '0' NOT NULL, /*年度*/
atf04       number(5) DEFAULT '0' NOT NULL, /*期别*/
atf05       varchar2(4) DEFAULT ' ' NOT NULL, /*现金异动码*/
atf06       number(20,6) DEFAULT '0' NOT NULL, /*金额*/
atf07       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
atflegal    varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

alter table atf_file add  constraint atf_pk primary key  (atf01,atf02,atf03,atf04,atf05) enable validate;
grant select on atf_file to tiptopgp;
grant update on atf_file to tiptopgp;
grant delete on atf_file to tiptopgp;
grant insert on atf_file to tiptopgp;
grant index on atf_file to public;
grant select on atf_file to ods;
