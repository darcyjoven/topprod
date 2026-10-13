/*
================================================================================
檔案代號:gcn_file
檔案名稱:udm_tree资料查询类型设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table gcn_file
(
gcn01       varchar2(10) NOT NULL,   /*类型代码                               */
gcn02       varchar2(1) NOT NULL,    /*语言别                                 */
gcn03       varchar2(80),            /*类型名称                               */
gcn04       varchar2(1000),          /*备注                                   */
gcn05       varchar2(1),             /*no use                                 */
gcn06       varchar2(1),             /*no use                                 */
gcn07       varchar2(1),             /*no use                                 */
gcn08       varchar2(1)              /*no use                                 */
);

alter table gcn_file add  constraint gcn_pk primary key  (gcn01,gcn02) enable validate;
grant select on gcn_file to tiptopgp;
grant update on gcn_file to tiptopgp;
grant delete on gcn_file to tiptopgp;
grant insert on gcn_file to tiptopgp;
grant index on gcn_file to public;
grant select on gcn_file to ods;
