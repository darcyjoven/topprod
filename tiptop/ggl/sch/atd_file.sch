/*
================================================================================
檔案代號:atd_file
檔案名稱:现金流量表直接法导入资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table atd_file
(
atd01       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
atd02       varchar2(10) DEFAULT ' ' NOT NULL, /*来源公司编号*/
atd03       number(5) DEFAULT '0' NOT NULL, /*年度*/
atd04       number(5) DEFAULT '0' NOT NULL, /*期别*/
atd05       varchar2(4) DEFAULT ' ' NOT NULL, /*现金异动码*/
atd06       number(20,6) DEFAULT '0' NOT NULL, /*转换后金额*/
atd07       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
atd08       number(20,10) DEFAULT '0' NOT NULL, /*功能币汇率*/
atd09       number(20,6) DEFAULT '0' NOT NULL, /*原始金额*/
atd10       varchar2(4) DEFAULT ' ' NOT NULL, /*来源公司币种*/
atd11       varchar2(2),             /*变动分类                               */
atd12       varchar2(30) DEFAULT ' ' NOT NULL, /*关系人*/
atd13       number(20,6) DEFAULT '0' NOT NULL, /*个体功能币金额*/
atd14       varchar2(4),             /*個體功能幣幣別                         */
atd15       number(20,10) DEFAULT '0' NOT NULL, /*转换汇率*/
atd16       varchar2(100),           /*说明                                   */
atd17       varchar2(2),             /*变动类型                               */
atdlegal    varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

alter table atd_file add  constraint atd_pk primary key  (atd01,atd02,atd03,atd04,atd05,atd12) enable validate;
grant select on atd_file to tiptopgp;
grant update on atd_file to tiptopgp;
grant delete on atd_file to tiptopgp;
grant insert on atd_file to tiptopgp;
grant index on atd_file to public;
grant select on atd_file to ods;
