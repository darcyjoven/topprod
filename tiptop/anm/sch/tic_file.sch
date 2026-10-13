/*
================================================================================
檔案代號:tic_file
檔案名稱:现金异动码子档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tic_file
(
tic00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐别*/
tic01       number(5) DEFAULT '0' NOT NULL, /*年度*/
tic02       number(5) DEFAULT '0' NOT NULL, /*期别*/
tic03       varchar2(1) DEFAULT ' ' NOT NULL, /*借贷别*/
tic04       varchar2(20) DEFAULT ' ' NOT NULL, /*参考单号*/
tic05       number(5) DEFAULT '0' NOT NULL, /*项次*/
tic06       varchar2(6) DEFAULT ' ' NOT NULL, /*现金变动码*/
tic07       number(20,6) DEFAULT '0' NOT NULL, /*本币金额*/
tic07f      number(20,6) DEFAULT '0' NOT NULL, /*原币金额*/
tic08       varchar2(30) DEFAULT ' ' NOT NULL, /*关系人*/
tic09       varchar2(1) DEFAULT '1' NOT NULL /*来源*/
);

alter table tic_file add  constraint tic_pk primary key  (tic00,tic01,tic02,tic04,tic05,tic06,tic08) enable validate;
grant select on tic_file to tiptopgp;
grant update on tic_file to tiptopgp;
grant delete on tic_file to tiptopgp;
grant insert on tic_file to tiptopgp;
grant index on tic_file to public;
grant select on tic_file to ods;
