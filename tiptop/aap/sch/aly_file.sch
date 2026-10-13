/*
================================================================================
檔案代號:aly_file
檔案名稱:帐龄及备抵呆账提列率档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aly_file
(
aly01       varchar2(4) DEFAULT ' ' NOT NULL, /*帐龄类型*/
aly02       number(5) DEFAULT '1' NOT NULL, /*项次*/
aly03       number(5) DEFAULT '0' NOT NULL, /*账龄起始天数*/
aly04       number(5) DEFAULT '0' NOT NULL, /*账龄截止天数*/
aly05       number(9,4)              /*账龄呆账提列率                         */
);

alter table aly_file add  constraint aly_pk primary key  (aly01,aly02) enable validate;
grant select on aly_file to tiptopgp;
grant update on aly_file to tiptopgp;
grant delete on aly_file to tiptopgp;
grant insert on aly_file to tiptopgp;
grant index on aly_file to public;
grant select on aly_file to ods;
