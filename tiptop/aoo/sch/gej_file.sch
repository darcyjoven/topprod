/*
================================================================================
檔案代號:gej_file
檔案名稱:独立段资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gej_file
(
gej01       varchar2(10) NOT NULL,   /*独立段编号                             */
gej02       varchar2(80),            /*名称                                   */
gej03       number(5),               /*长度                                   */
gej04       varchar2(1),             /*No Use                                 */
gej05       varchar2(1),             /*No Use                                 */
gej06       varchar2(1),             /*No Use                                 */
gejacti     varchar2(1),             /*资料有效码                             */
gejuser     varchar2(10),            /*资料所有者                             */
gejgrup     varchar2(10),            /*资料所有部门                           */
gejmodu     varchar2(10),            /*资料更改者                             */
gejdate     date,                    /*最近更改日                             */
gejoriu     varchar2(10),            /*资料建立者                             */
gejorig     varchar2(10)             /*资料建立部门                           */
);

alter table gej_file add  constraint gej_pk primary key  (gej01) enable validate;
grant select on gej_file to tiptopgp;
grant update on gej_file to tiptopgp;
grant delete on gej_file to tiptopgp;
grant insert on gej_file to tiptopgp;
grant index on gej_file to public;
grant select on gej_file to ods;
