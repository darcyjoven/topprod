/*
================================================================================
檔案代號:ocs_file
檔案名稱:售货动作维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ocs_file
(
ocs01       varchar2(10) DEFAULT ' ' NOT NULL, /*产品分类码*/
ocs02       varchar2(10) DEFAULT ' ' NOT NULL, /*售货动作代号*/
ocs03       varchar2(24),            /*回转递延收入科目                       */
ocs031      varchar2(24),            /*回转递延收入科目二                     */
ocs04       number(9,4),             /*百分比                                 */
ocs05       number(5),               /*动作期间                               */
ocs011      varchar2(10) DEFAULT ' ' NOT NULL, /*客户编号*/
ocs012      varchar2(40) DEFAULT ' ' NOT NULL, /*料号*/
ocs06       number(5) DEFAULT '0' NOT NULL, /*有效起始年*/
ocs07       number(5) DEFAULT '0' NOT NULL, /*有效起始月*/
ocs08       number(5) DEFAULT '0' NOT NULL, /*有效截止年*/
ocs09       number(5) DEFAULT '0' NOT NULL /*有效截止月*/
);

alter table ocs_file add  constraint ocs_pk primary key  (ocs01,ocs011,ocs012,ocs02,ocs06,ocs07,ocs08,ocs09) enable validate;
grant select on ocs_file to tiptopgp;
grant update on ocs_file to tiptopgp;
grant delete on ocs_file to tiptopgp;
grant insert on ocs_file to tiptopgp;
grant index on ocs_file to public;
grant select on ocs_file to ods;
