/*
================================================================================
檔案代號:cdb_file
檔案名稱:每月人工/制费档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cdb_file
(
cdb01       number(5) DEFAULT '0' NOT NULL, /*年度*/
cdb02       number(5) DEFAULT '0' NOT NULL, /*月份*/
cdb03       varchar2(10) DEFAULT ' ' NOT NULL, /*成本中心*/
cdb04       varchar2(10) DEFAULT ' ' NOT NULL, /*成本项目*/
cdb05       number(20,6) DEFAULT '0' NOT NULL, /*成本*/
cdb06       number(20,6) DEFAULT '0' NOT NULL, /*分摊基础指标总数*/
cdb07       number(20,6) DEFAULT '0' NOT NULL, /*单位成本*/
cdb08       varchar2(1) DEFAULT ' ' NOT NULL, /*分摊方式*/
cdbdate     date,                    /*最近更改日                             */
cdbgrup     varchar2(10),            /*资料所有部门                           */
cdbmodu     varchar2(10),            /*资料更改者                             */
cdbuser     varchar2(10),            /*资料所有者                             */
cdb09       varchar2(1),             /*制费类别                               */
cdb10       number(15,3),            /*标准产量                               */
cdblegal    varchar2(10) NOT NULL,   /*所属法人                               */
cdborig     varchar2(10),            /*资料建立部门                           */
cdboriu     varchar2(10),            /*资料建立者                             */
cdb00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
cdb11       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
cdb12       varchar2(24),            /*科目编号                               */
cdb13       varchar2(30)             /*分录底稿单号                           */
);

alter table cdb_file add  constraint cdb_pk primary key  (cdb01,cdb02,cdb03,cdb04,cdb08,cdb11) enable validate;
grant select on cdb_file to tiptopgp;
grant update on cdb_file to tiptopgp;
grant delete on cdb_file to tiptopgp;
grant insert on cdb_file to tiptopgp;
grant index on cdb_file to public;
grant select on cdb_file to ods;
