/*
================================================================================
檔案代號:oza_file
檔案名稱:航运基本代码档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oza_file
(
oza01       varchar2(10) NOT NULL,   /*航运代码                               */
oza02       varchar2(80),            /*航运说明                               */
ozaacti     varchar2(1),             /*资料有效码                             */
ozauser     varchar2(10),            /*资料所有者                             */
ozagrup     varchar2(10),            /*资料所有部门                           */
ozamodu     varchar2(10),            /*资料更改者                             */
ozadate     date,                    /*最近更改日                             */
ozaorig     varchar2(10),            /*资料建立部门                           */
ozaoriu     varchar2(10)             /*资料建立者                             */
);

alter table oza_file add  constraint oza_pk primary key  (oza01) enable validate;
grant select on oza_file to tiptopgp;
grant update on oza_file to tiptopgp;
grant delete on oza_file to tiptopgp;
grant insert on oza_file to tiptopgp;
grant index on oza_file to public;
grant select on oza_file to ods;
