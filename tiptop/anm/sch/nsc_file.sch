/*
================================================================================
檔案代號:nsc_file
檔案名稱:转账媒体代码转换档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nsc_file
(
nsc01       varchar2(10) DEFAULT ' ' NOT NULL, /*媒体编号*/
nsc02       number(5) DEFAULT '0' NOT NULL, /*媒体序号*/
nsc03       varchar2(10) DEFAULT ' ' NOT NULL, /*原值*/
nsc04       varchar2(10)             /*转换值                                 */
);

alter table nsc_file add  constraint nsc_pk primary key  (nsc01,nsc02,nsc03) enable validate;
grant select on nsc_file to tiptopgp;
grant update on nsc_file to tiptopgp;
grant delete on nsc_file to tiptopgp;
grant insert on nsc_file to tiptopgp;
grant index on nsc_file to public;
grant select on nsc_file to ods;
