/*
================================================================================
檔案代號:sgf_file
檔案名稱:异常除外属性档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sgf_file
(
sgf01       varchar2(10) NOT NULL,   /*属性                                   */
sgf02       varchar2(80),            /*说明                                   */
sgf03       varchar2(10),            /*分类                                   */
sgf04       varchar2(6),             /*No Use                                 */
sgf05       varchar2(20),            /*No Use                                 */
sgfacti     varchar2(1),             /*资料有效码                             */
sgfpost     varchar2(1),             /*No Use                                 */
sgfuser     varchar2(10),            /*资料所有者                             */
sgfgrup     varchar2(10),            /*资料所有群                             */
sgfmodu     varchar2(10),            /*资料更改者                             */
sgfdate     date,                    /*最近更改日                             */
sgforig     varchar2(10),            /*资料建立部门                           */
sgforiu     varchar2(10)             /*资料建立者                             */
);

alter table sgf_file add  constraint sgf_pk primary key  (sgf01) enable validate;
grant select on sgf_file to tiptopgp;
grant update on sgf_file to tiptopgp;
grant delete on sgf_file to tiptopgp;
grant insert on sgf_file to tiptopgp;
grant index on sgf_file to public;
grant select on sgf_file to ods;
