/*
================================================================================
檔案代號:wcd_file
檔案名稱:spc 集成设置档(基本资料字段设置)
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wcd_file
(
wcd01       varchar2(15) NOT NULL,   /*档案代码                               */
wcd02       varchar2(20) NOT NULL,   /*字段名称                               */
wcd03       varchar2(1),             /*No Use                                 */
wcd04       varchar2(1),             /*No Use                                 */
wcd05       varchar2(1),             /*No Use                                 */
wcd06       varchar2(1),             /*No Use                                 */
wcd07       varchar2(1)              /*No Use                                 */
);

alter table wcd_file add  constraint wcd_pk primary key  (wcd01,wcd02) enable validate;
grant select on wcd_file to tiptopgp;
grant update on wcd_file to tiptopgp;
grant delete on wcd_file to tiptopgp;
grant insert on wcd_file to tiptopgp;
grant index on wcd_file to public;
grant select on wcd_file to ods;
