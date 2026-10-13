/*
================================================================================
檔案代號:gbl_file
檔案名稱:程序Action比照功能记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gbl_file
(
gbl01       varchar2(20) NOT NULL,   /*程序代码                               */
gbl02       varchar2(80) NOT NULL,   /*Action 代码                            */
gbl03       varchar2(1),             /*比对Action代码                         */
gbl04       varchar2(1),             /*No Use                                 */
gbl05       varchar2(1)              /*No Use                                 */
);

alter table gbl_file add  constraint gbl_pk primary key  (gbl01,gbl02) enable validate;
grant select on gbl_file to tiptopgp;
grant update on gbl_file to tiptopgp;
grant delete on gbl_file to tiptopgp;
grant insert on gbl_file to tiptopgp;
grant index on gbl_file to public;
grant select on gbl_file to ods;
