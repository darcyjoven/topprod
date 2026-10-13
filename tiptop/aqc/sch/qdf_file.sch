/*
================================================================================
檔案代號:qdf_file
檔案名稱:1916检验水准计数值样本代码资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table qdf_file
(
qdf01       varchar2(1) DEFAULT '1' NOT NULL, /*级数*/
qdf02       varchar2(1) DEFAULT '1' NOT NULL, /*样本字号*/
qdf03       number(10) DEFAULT '0' NOT NULL, /*起始批量*/
qdf04       number(10) DEFAULT '0' NOT NULL /*截止批量*/
);

alter table qdf_file add  constraint qdf_pk primary key  (qdf01,qdf02,qdf03) enable validate;
grant select on qdf_file to tiptopgp;
grant update on qdf_file to tiptopgp;
grant delete on qdf_file to tiptopgp;
grant insert on qdf_file to tiptopgp;
grant index on qdf_file to public;
grant select on qdf_file to ods;
