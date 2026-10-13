/*
================================================================================
檔案代號:aab_file
檔案名稱:科目部门设限档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aab_file
(
aab01       varchar2(24) NOT NULL,   /*科目编号                               */
aab02       varchar2(10) NOT NULL,   /*部门编号                               */
aab03       varchar2(255),           /*备注                                   */
aab00       varchar2(5) NOT NULL     /*帐套                                   */
);

alter table aab_file add  constraint aab_pk primary key  (aab00,aab01,aab02) enable validate;
grant select on aab_file to tiptopgp;
grant update on aab_file to tiptopgp;
grant delete on aab_file to tiptopgp;
grant insert on aab_file to tiptopgp;
grant index on aab_file to public;
grant select on aab_file to ods;
