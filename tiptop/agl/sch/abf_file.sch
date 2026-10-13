/*
================================================================================
檔案代號:abf_file
檔案名稱:打印族群资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table abf_file
(
abf01       varchar2(10) NOT NULL,   /*用户编号                               */
abf02       varchar2(6) NOT NULL,    /*族群编号                               */
abf03       varchar2(1),             /*No Use                                 */
abf04       varchar2(1),             /*No Use                                 */
abf05       varchar2(1),             /*No Use                                 */
abf06       varchar2(1),             /*No Use                                 */
abf07       varchar2(1),             /*No Use                                 */
abfacti     varchar2(1),             /*资料有效码                             */
abfuser     varchar2(10),            /*资料所有者                             */
abfgrup     varchar2(10),            /*资料所有部门                           */
abfmodu     varchar2(10),            /*资料更改者                             */
abfdate     date,                    /*最近更改日                             */
abforig     varchar2(10),            /*资料建立部门                           */
abforiu     varchar2(10)             /*资料建立者                             */
);

alter table abf_file add  constraint abf_pk primary key  (abf01,abf02) enable validate;
grant select on abf_file to tiptopgp;
grant update on abf_file to tiptopgp;
grant delete on abf_file to tiptopgp;
grant insert on abf_file to tiptopgp;
grant index on abf_file to public;
grant select on abf_file to ods;
