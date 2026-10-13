/*
================================================================================
檔案代號:gfi_file
檔案名稱:权限过滤器条件设定单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gfi_file
(
gfi01       varchar2(20) NOT NULL,   /*程序代码                               */
gfi02       varchar2(10) NOT NULL,   /*过滤条件编号                           */
gfi03       number(5) NOT NULL,      /*序号                                   */
gfi04       number(5),               /*AND/OR                                 */
gfi05       varchar2(30),            /*字段                                   */
gfi06       number(5),               /*SQL对比运算子                          */
gfi07       varchar2(80)             /*比较值                                 */
);

alter table gfi_file add  constraint gfi_pk primary key  (gfi01,gfi02,gfi03) enable validate;
grant select on gfi_file to tiptopgp;
grant update on gfi_file to tiptopgp;
grant delete on gfi_file to tiptopgp;
grant insert on gfi_file to tiptopgp;
grant index on gfi_file to public;
grant select on gfi_file to ods;
