/*
================================================================================
檔案代號:ats_file
檔案名稱:股东权益分类设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ats_file
(
ats01       varchar2(10) DEFAULT ' ' NOT NULL, /*分类编号*/
ats02       varchar2(80),            /*编号说明                               */
ats03       varchar2(1),             /*NO USE                                 */
ats04       varchar2(1),             /*NO USE                                 */
ats05       varchar2(1),             /*NO USE                                 */
ats06       number(5) DEFAULT '0' NOT NULL, /*打印顺序*/
ats07       varchar2(1) DEFAULT ' ' NOT NULL /*合并*/
);

alter table ats_file add  constraint ats_pk primary key  (ats01,ats06) enable validate;
grant select on ats_file to tiptopgp;
grant update on ats_file to tiptopgp;
grant delete on ats_file to tiptopgp;
grant insert on ats_file to tiptopgp;
grant index on ats_file to public;
grant select on ats_file to ods;
