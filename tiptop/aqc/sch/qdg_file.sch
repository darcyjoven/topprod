/*
================================================================================
檔案代號:qdg_file
檔案名稱:1916检验水准抽样计划资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table qdg_file
(
qdg01       varchar2(1) DEFAULT '1' NOT NULL, /*检验水准*/
qdg02       varchar2(1) DEFAULT '1' NOT NULL, /*级数*/
qdg03       varchar2(1) DEFAULT '1' NOT NULL, /*样本字号*/
qdg04       number(5),               /*抽样数                                 */
qdg05       number(8,4),             /*K法标准值                              */
qdg06       number(8,4)              /*F法标准值                              */
);

alter table qdg_file add  constraint qdg_pk primary key  (qdg01,qdg02,qdg03) enable validate;
grant select on qdg_file to tiptopgp;
grant update on qdg_file to tiptopgp;
grant delete on qdg_file to tiptopgp;
grant insert on qdg_file to tiptopgp;
grant index on qdg_file to public;
grant select on qdg_file to ods;
