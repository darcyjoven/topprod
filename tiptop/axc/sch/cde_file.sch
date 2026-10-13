/*
================================================================================
檔案代號:cde_file
檔案名稱:每月工单发料主件科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table cde_file
(
cde01       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
cde02       number(5) DEFAULT '0' NOT NULL, /*年度*/
cde03       number(5) DEFAULT '0' NOT NULL, /*月份*/
cde04       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
cde05       varchar2(30) DEFAULT ' ',/*分录底稿单号                           */
cde06       varchar2(40) DEFAULT ' ' NOT NULL, /*类型编号*/
cde07       varchar2(40) DEFAULT ' ' NOT NULL, /*工单单号*/
cde08       varchar2(40) DEFAULT ' ' NOT NULL, /*主件*/
cde09       varchar2(24),            /*费用科目                               */
cde10       number(20,6) DEFAULT '0' NOT NULL, /*本月投入金额*/
cde11       varchar2(10),            /*成本中心                               */
cdeconf     varchar2(1) NOT NULL,    /*审核否                                 */
cdelegal    varchar2(10),            /*所属法人                               */
cdeorig     varchar2(10),            /*资料建立部门                           */
cdeoriu     varchar2(10),            /*资料建立者                             */
cdeplant    varchar2(10),            /*所属工厂                               */
cde12       number(5),               /*工单类型                               */
cde13       varchar2(10)             /*客户厂商                               */
);

create unique index cde_01 on cde_file (cde01,cde02,cde03,cde04,cde06,cde07);
alter table cde_file add  constraint cde_pk primary key  (cde01,cde02,cde03,cde04,cde06,cde07) enable validate;
grant select on cde_file to tiptopgp;
grant update on cde_file to tiptopgp;
grant delete on cde_file to tiptopgp;
grant insert on cde_file to tiptopgp;
grant index on cde_file to public;
grant select on cde_file to ods;
