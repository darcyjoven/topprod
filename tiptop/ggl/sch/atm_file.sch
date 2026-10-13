/*
================================================================================
檔案代號:atm_file
檔案名稱:揭露事项说明档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table atm_file
(
atm00       varchar2(1) DEFAULT ' ' NOT NULL, /*合并否*/
atm01       number(5) DEFAULT '0' NOT NULL, /*顺序*/
atm02       varchar2(80),            /*说明                                   */
atm03       number(20,6) DEFAULT '0' NOT NULL, /*金额*/
atm04       number(5) DEFAULT '0' NOT NULL, /*年度*/
atm05       number(5) DEFAULT '0' NOT NULL, /*期别*/
atm06       varchar2(10) DEFAULT ' ' NOT NULL /*族群编号*/
);

alter table atm_file add  constraint atm_pk primary key  (atm00,atm01,atm04,atm05,atm06) enable validate;
grant select on atm_file to tiptopgp;
grant update on atm_file to tiptopgp;
grant delete on atm_file to tiptopgp;
grant insert on atm_file to tiptopgp;
grant index on atm_file to public;
grant select on atm_file to ods;
