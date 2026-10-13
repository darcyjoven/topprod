/*
================================================================================
檔案代號:wcc_file
檔案名稱:spc 集成设置档(表单集成字段设置)
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wcc_file
(
wcc01       varchar2(20) NOT NULL,   /*程序编号                               */
wcc02       varchar2(20) NOT NULL,   /*字段名称                               */
wcc03       varchar2(1),             /*更新否                                 */
wcc04       varchar2(1),             /*No Use                                 */
wcc05       varchar2(1),             /*No Use                                 */
wcc06       varchar2(1),             /*No Use                                 */
wcc07       varchar2(1)              /*No Use                                 */
);

alter table wcc_file add  constraint wcc_pk primary key  (wcc01,wcc02) enable validate;
grant select on wcc_file to tiptopgp;
grant update on wcc_file to tiptopgp;
grant delete on wcc_file to tiptopgp;
grant insert on wcc_file to tiptopgp;
grant index on wcc_file to public;
grant select on wcc_file to ods;
