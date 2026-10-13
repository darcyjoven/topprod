/*
================================================================================
檔案代號:tc_cdl_file
檔案名稱:每月杂项进出科目档(旧值)
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table tc_cdl_file
(
tc_cdl01       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
tc_cdl02       number(5) DEFAULT '0' NOT NULL, /*年度*/
tc_cdl03       number(5) DEFAULT '0' NOT NULL, /*月份*/
tc_cdl04       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
tc_cdl05       varchar2(10) DEFAULT ' ' NOT NULL, /*部门*/
tc_cdl06       varchar2(10) DEFAULT ' ' NOT NULL, /*原因码*/
tc_cdl07       varchar2(40) DEFAULT ' ' NOT NULL, /*料号*/
tc_cdl08       varchar2(24),            /*原因科目                               */
tc_cdl09       varchar2(24),            /*存货科目                               */
tc_cdl10       number(20,6) DEFAULT '0' NOT NULL, /*金额*/
tc_cdl11       varchar2(30),            /*分录底稿单号                           */
tc_cdl12       varchar2(30),            /*差異分錄底稿單號                       */
tc_cdl13       varchar2(40) DEFAULT ' ' NOT NULL, /*类型编号*/
tc_cdlconf     varchar2(1) NOT NULL,    /*审核否                                 */
tc_cdllegal    varchar2(10),            /*所属法人                               */
tc_cdlconf1    varchar2(1) DEFAULT 'N' NOT NULL,
tc_cdl14       varchar2(10) DEFAULT ' ' NOT NULL, /*项目编号*/
tc_cdl15       varchar2(30) DEFAULT ' ' NOT NULL, /*WBS 编号*/
                                     /*                                       */
                                     /*                                       */
                                     /*                                       */
tc_cdl16       varchar2(10)             /*成本归属部门                           */
);

create        index tic_cdl_01 on tc_cdl_file (tc_cdl01,tc_cdl02,tc_cdl03,tc_cdl04,tc_cdl05,tc_cdl06,tc_cdl07,tc_cdl13);
alter table tc_cdl_file add  constraint tpc_cdl_pk primary key  (tc_cdl01,tc_cdl02,tc_cdl03,tc_cdl04,tc_cdl05,tc_cdl06,tc_cdl07,tc_cdl13,tc_cdl14,tc_cdl15) enable validate;
grant select on tc_cdl_file to tiptopgp;
grant update on tc_cdl_file to tiptopgp;
grant delete on tc_cdl_file to tiptopgp;
grant insert on tc_cdl_file to tiptopgp;
grant index on tc_cdl_file to public;
grant select on tc_cdl_file to ods;
