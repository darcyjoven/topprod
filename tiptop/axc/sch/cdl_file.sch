/*
================================================================================
檔案代號:cdl_file
檔案名稱:每月杂项进出科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table cdl_file
(
cdl01       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
cdl02       number(5) DEFAULT '0' NOT NULL, /*年度*/
cdl03       number(5) DEFAULT '0' NOT NULL, /*月份*/
cdl04       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
cdl05       varchar2(10) DEFAULT ' ' NOT NULL, /*部门*/
cdl06       varchar2(10) DEFAULT ' ' NOT NULL, /*原因码*/
cdl07       varchar2(40) DEFAULT ' ' NOT NULL, /*料号*/
cdl08       varchar2(24),            /*原因科目                               */
cdl09       varchar2(24),            /*存货科目                               */
cdl10       number(20,6) DEFAULT '0' NOT NULL, /*金额*/
cdl11       varchar2(30),            /*分录底稿单号                           */
cdl12       varchar2(30),            /*差異分錄底稿單號                       */
cdl13       varchar2(40) DEFAULT ' ' NOT NULL, /*类型编号*/
cdlconf     varchar2(1) NOT NULL,    /*审核否                                 */
cdllegal    varchar2(10),            /*所属法人                               */
cdlconf1    varchar2(1) DEFAULT 'N' NOT NULL,
cdl14       varchar2(10) DEFAULT ' ' NOT NULL, /*项目编号*/
cdl15       varchar2(30) DEFAULT ' ' NOT NULL, /*WBS 编号*/
                                     /*                                       */
                                     /*                                       */
                                     /*                                       */
cdl16       varchar2(10)             /*成本归属部门                           */
);

create        index cdl_01 on cdl_file (cdl01,cdl02,cdl03,cdl04,cdl05,cdl06,cdl07,cdl13);
alter table cdl_file add  constraint cdl_pk primary key  (cdl01,cdl02,cdl03,cdl04,cdl05,cdl06,cdl07,cdl13,cdl14,cdl15) enable validate;
grant select on cdl_file to tiptopgp;
grant update on cdl_file to tiptopgp;
grant delete on cdl_file to tiptopgp;
grant insert on cdl_file to tiptopgp;
grant index on cdl_file to public;
grant select on cdl_file to ods;
