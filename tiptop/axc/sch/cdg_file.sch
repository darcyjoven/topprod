/*
================================================================================
檔案代號:cdg_file
檔案名稱:每月工单入库主件科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table cdg_file
(
cdg01       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
cdg02       number(5) DEFAULT '0' NOT NULL, /*年度*/
cdg03       number(5) DEFAULT '0' NOT NULL, /*月份*/
cdg04       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
cdg05       varchar2(30) DEFAULT ' ',/*分录底稿单号                           */
cdg06       varchar2(40) DEFAULT ' ' NOT NULL, /*类型编号*/
cdg07       varchar2(40) DEFAULT ' ' NOT NULL, /*工单单号*/
cdg08       varchar2(40) DEFAULT ' ' NOT NULL, /*主件*/
cdg09       varchar2(24) DEFAULT ' ',/*科目                                   */
cdg10       number(15,3) DEFAULT '0' NOT NULL, /*本月转出数量*/
cdg11       number(20,6) DEFAULT '0' NOT NULL, /*本月转出金额*/
cdg11a      number(20,6) DEFAULT '0' NOT NULL, /*本月本階轉出金額-材料*/
cdg11b      number(20,6) DEFAULT '0' NOT NULL, /*本月本階轉出金額-人工*/
cdg11c      number(20,6) DEFAULT '0' NOT NULL, /*本月本階轉出金額-制費一*/
cdg11d      number(20,6) DEFAULT '0' NOT NULL, /*本月本階轉出金額-加工*/
cdg11e      number(20,6) DEFAULT '0' NOT NULL, /*本月本階轉出金額-制費二*/
cdg11f      number(20,6) DEFAULT '0' NOT NULL, /*本月本階轉出金額-制費三*/
cdg11g      number(20,6) DEFAULT '0' NOT NULL, /*本月本階轉出金額-制費四*/
cdg11h      number(20,6) DEFAULT '0' NOT NULL, /*本月本階轉出金額-制費五*/
cdg12       varchar2(10),            /*成本中心                               */
cdgconf     varchar2(1) NOT NULL,    /*审核否                                 */
cdglegal    varchar2(10),            /*所属法人                               */
cdgorig     varchar2(10),            /*资料建立部门                           */
cdgoriu     varchar2(10),            /*资料建立者                             */
cdgplant    varchar2(10),            /*所属工厂                               */
cdg00       varchar2(1) DEFAULT '1' NOT NULL, /*来源类型*/
cdg13       number(5),               /*工单类型                               */
cdg14       varchar2(10)             /*客户厂商                               */
);

create        index cdg_01 on cdg_file (cdg01,cdg02,cdg03,cdg04,cdg06,cdg07);
alter table cdg_file add  constraint cdg_pk primary key  (cdg00,cdg01,cdg02,cdg03,cdg04,cdg06,cdg07,cdg08) enable validate;
grant select on cdg_file to tiptopgp;
grant update on cdg_file to tiptopgp;
grant delete on cdg_file to tiptopgp;
grant insert on cdg_file to tiptopgp;
grant index on cdg_file to public;
grant select on cdg_file to ods;
