/*
================================================================================
檔案代號:atl_file
檔案名稱:人工录入金额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table atl_file
(
atl00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐别*/
atl01       varchar2(6) DEFAULT ' ' NOT NULL, /*群组编号*/
atl02       varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
atl03       varchar2(20) DEFAULT ' ' NOT NULL, /*编号*/
atl04       varchar2(80),            /*说明                                   */
atl05       number(20,6) DEFAULT '0' NOT NULL, /*人工录入金额*/
atl06       number(5) DEFAULT '0' NOT NULL, /*年度*/
atl07       number(5) DEFAULT '0' NOT NULL, /*期别*/
atl08       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
atl09       varchar2(10) DEFAULT ' ' NOT NULL /*上层公司编号*/
);

alter table atl_file add  constraint atl_pk primary key  (atl00,atl01,atl02,atl03,atl06,atl07,atl08,atl09) enable validate;
grant select on atl_file to tiptopgp;
grant update on atl_file to tiptopgp;
grant delete on atl_file to tiptopgp;
grant insert on atl_file to tiptopgp;
grant index on atl_file to public;
grant select on atl_file to ods;
