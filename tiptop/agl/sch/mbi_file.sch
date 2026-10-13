/*
================================================================================
檔案代號:mbi_file
檔案名稱:报表格式单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table mbi_file
(
mbi00       varchar2(5),             /*帐套                                   */
mbi01       varchar2(6) DEFAULT ' ' NOT NULL, /*报表编号*/
mbi02       varchar2(80),            /*报表名称                               */
mbi03       varchar2(1) DEFAULT ' ' NOT NULL, /*报表性质*/
mbiacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
mbidate     date,                    /*最近更改日                             */
mbigrup     varchar2(10),            /*资料所有群                             */
mbimodu     varchar2(10),            /*资料更改者                             */
mbiorig     varchar2(10),            /*资料建立部门                           */
mbioriu     varchar2(10),            /*资料建立者                             */
mbiuser     varchar2(10)             /*资料所有者                             */
);

create unique index mbi_01 on mbi_file (mbi01);
alter table mbi_file add  constraint mbi_pk primary key  (mbi01) enable validate;
grant select on mbi_file to tiptopgp;
grant update on mbi_file to tiptopgp;
grant delete on mbi_file to tiptopgp;
grant insert on mbi_file to tiptopgp;
grant index on mbi_file to public;
grant select on mbi_file to ods;
