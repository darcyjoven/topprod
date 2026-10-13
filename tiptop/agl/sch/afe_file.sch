/*
================================================================================
檔案代號:afe_file
檔案名稱:预算底稿单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table afe_file
(
afe00       varchar2(10) DEFAULT ' ' NOT NULL, /*预算版本*/
afe01       varchar2(10) DEFAULT ' ' NOT NULL, /*预算营运中心*/
afe02       number(5) DEFAULT '0' NOT NULL, /*预算年度*/
afe03       varchar2(10) DEFAULT ' ' NOT NULL, /*预算部门*/
afe04       varchar2(10) DEFAULT ' ' NOT NULL, /*项目编号*/
afe05       varchar2(30) DEFAULT ' ' NOT NULL, /*wbs编码*/
afe06       varchar2(10) DEFAULT ' ' NOT NULL, /*预算项目*/
afe07       varchar2(24) DEFAULT ' ' NOT NULL, /*会计科目*/
afe08       number(5) DEFAULT '0' NOT NULL, /*期别*/
afe09       number(20,6),            /*预算金额                               */
afe10       number(20,6),            /*调整金额                               */
afe11       number(20,6),            /*预算金额(来源)                         */
afe12       number(20,6)             /*预算金额(来源)                         */
);

alter table afe_file add  constraint afe_pk primary key  (afe00,afe01,afe02,afe03,afe04,afe05,afe06,afe07,afe08) enable validate;
grant select on afe_file to tiptopgp;
grant update on afe_file to tiptopgp;
grant delete on afe_file to tiptopgp;
grant insert on afe_file to tiptopgp;
grant index on afe_file to public;
grant select on afe_file to ods;
