/*
================================================================================
檔案代號:pji_file
檔案名稱:wbs组织成员档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pji_file
(
pji01       varchar2(30) NOT NULL,   /*WBS编码                                */
pji02       varchar2(10) NOT NULL,   /*人员编号                               */
pji03       varchar2(255)            /*负责事项                               */
);

alter table pji_file add  constraint pji_pk primary key  (pji01,pji02) enable validate;
grant select on pji_file to tiptopgp;
grant update on pji_file to tiptopgp;
grant delete on pji_file to tiptopgp;
grant insert on pji_file to tiptopgp;
grant index on pji_file to public;
grant select on pji_file to ods;
