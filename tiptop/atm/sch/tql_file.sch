/*
================================================================================
檔案代號:tql_file
檔案名稱:客户类系列档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tql_file
(
tql01       varchar2(10) NOT NULL,   /*客户编号                               */
tql02       number(5) NOT NULL,      /*项次                                   */
tql03       varchar2(2) NOT NULL,    /*代码类型                               */
tql04       varchar2(10)             /*代码编号                               */
);

alter table tql_file add  constraint tql_pk primary key  (tql01,tql02,tql03) enable validate;
grant select on tql_file to tiptopgp;
grant update on tql_file to tiptopgp;
grant delete on tql_file to tiptopgp;
grant insert on tql_file to tiptopgp;
grant index on tql_file to public;
grant select on tql_file to ods;
