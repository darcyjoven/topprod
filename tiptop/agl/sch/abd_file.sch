/*
================================================================================
檔案代號:abd_file
檔案名稱:部门层级资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table abd_file
(
abd01       varchar2(10) NOT NULL,   /*部门编号                               */
abd02       varchar2(10) NOT NULL,   /*部门编号                               */
abd03       varchar2(1),             /*No Use                                 */
abd04       varchar2(1),             /*No Use                                 */
abd05       varchar2(1),             /*No Use                                 */
abd06       varchar2(1),             /*No Use                                 */
abdacti     varchar2(1),             /*资料有效码                             */
abduser     varchar2(10),            /*资料所有者                             */
abdgrup     varchar2(10),            /*资料所有部门                           */
abdmodu     varchar2(10),            /*资料更改者                             */
abddate     date,                    /*最近更改日                             */
abdorig     varchar2(10),            /*资料建立部门                           */
abdoriu     varchar2(10)             /*资料建立者                             */
);

alter table abd_file add  constraint abd_pk primary key  (abd01,abd02) enable validate;
grant select on abd_file to tiptopgp;
grant update on abd_file to tiptopgp;
grant delete on abd_file to tiptopgp;
grant insert on abd_file to tiptopgp;
grant index on abd_file to public;
grant select on abd_file to ods;
