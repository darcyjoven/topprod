/*
================================================================================
檔案代號:sch_file
檔案名稱:数据结构文件
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table sch_file
(
sch01       varchar2(30) DEFAULT ' ' NOT NULL, /*资料表名称*/
sch02       varchar2(30) DEFAULT ' ' NOT NULL, /*字段名称*/
sch03       number(5),               /*字段类型                               */
sch04       number(5),               /*字段长度                               */
sch05       number(5)                /*字段序号                               */
);

create        index sch_01 on sch_file (sch02);
alter table sch_file add  constraint sch_pk primary key  (sch01,sch02) enable validate;
grant select on sch_file to tiptopgp;
grant update on sch_file to tiptopgp;
grant delete on sch_file to tiptopgp;
grant insert on sch_file to tiptopgp;
grant index on sch_file to public;
grant select on sch_file to ods;
