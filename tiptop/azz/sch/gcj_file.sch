/*
================================================================================
檔案代號:gcj_file
檔案名稱:Express 报表权限设置
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gcj_file
(
gcj01       varchar2(1),             /*分类                                   */
gcj02       varchar2(10) NOT NULL,   /*用户编号/权限类型                      */
gcj03       varchar2(20) NOT NULL,   /*报表代码                               */
gcj04       varchar2(1),             /*运行程序否                             */
gcj05       varchar2(1),             /*no use                                 */
gcj06       varchar2(1)              /*no use                                 */
);

alter table gcj_file add  constraint gcj_pk primary key  (gcj02,gcj03) enable validate;
grant select on gcj_file to tiptopgp;
grant update on gcj_file to tiptopgp;
grant delete on gcj_file to tiptopgp;
grant insert on gcj_file to tiptopgp;
grant index on gcj_file to public;
grant select on gcj_file to ods;
