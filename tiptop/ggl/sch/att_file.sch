/*
================================================================================
檔案代號:att_file
檔案名稱:股东权益分类对应会计科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table att_file
(
att01       varchar2(10) DEFAULT ' ' NOT NULL, /*分类编号*/
att02       varchar2(24) DEFAULT ' ' NOT NULL, /*会计科目*/
att03       varchar2(1),             /*NO USE                                 */
att04       varchar2(255),           /*NO USE                                 */
att05       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
att06       varchar2(10) DEFAULT ' ' NOT NULL, /*上层公司编号*/
att07       varchar2(5) DEFAULT ' ' NOT NULL /*帐别*/
);

alter table att_file add  constraint att_pk primary key  (att01,att02,att05,att06,att07) enable validate;
grant select on att_file to tiptopgp;
grant update on att_file to tiptopgp;
grant delete on att_file to tiptopgp;
grant insert on att_file to tiptopgp;
grant index on att_file to public;
grant select on att_file to ods;
