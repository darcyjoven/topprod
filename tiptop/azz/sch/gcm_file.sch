/*
================================================================================
檔案代號:gcm_file
檔案名稱:udm_tree资料查询设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gcm_file
(
gcm01       number(5) NOT NULL,      /*项次                                   */
gcm02       varchar2(10),            /*类型代码                               */
gcm03       varchar2(15),            /*表格代码                               */
gcm04       varchar2(20),            /*字段代码                               */
gcm05       varchar2(20),            /*对应程序代码                           */
gcm06       varchar2(20),            /*key1                                   */
gcm07       varchar2(20),            /*key2                                   */
gcm08       varchar2(20),            /*key3                                   */
gcm09       varchar2(20),            /*key4                                   */
gcm10       varchar2(20),            /*key5                                   */
gcm11       varchar2(20),            /*对应的程序代码                         */
gcm12       varchar2(1),             /*no use                                 */
gcm13       varchar2(1)              /*no use                                 */
);

alter table gcm_file add  constraint gcm_pk primary key  (gcm01) enable validate;
grant select on gcm_file to tiptopgp;
grant update on gcm_file to tiptopgp;
grant delete on gcm_file to tiptopgp;
grant insert on gcm_file to tiptopgp;
grant index on gcm_file to public;
grant select on gcm_file to ods;
