/*
================================================================================
檔案代號:rwt_file
檔案名稱:营运中心门店销售目标设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rwt_file
(
rwt01       varchar2(10) DEFAULT ' ' NOT NULL, /*目标营运中心*/
rwt02       number(5) DEFAULT '0' NOT NULL, /*目标年度*/
rwt03       varchar2(10) DEFAULT ' ' NOT NULL, /*制定營運中心*/
rwt04       varchar2(10),            /*上级营运中心                           */
rwt201      number(20,6) DEFAULT '0' NOT NULL, /*1月目标金额*/
rwt202      number(20,6) DEFAULT '0' NOT NULL, /*2月目标金额*/
rwt203      number(20,6) DEFAULT '0' NOT NULL, /*3月目标金额*/
rwt204      number(20,6) DEFAULT '0' NOT NULL, /*4月目标金额*/
rwt205      number(20,6) DEFAULT '0' NOT NULL, /*5月目标金额*/
rwt206      number(20,6) DEFAULT '0' NOT NULL, /*6月目标金额*/
rwt207      number(20,6) DEFAULT '0' NOT NULL, /*7月目标金额*/
rwt208      number(20,6) DEFAULT '0' NOT NULL, /*8月目标金额*/
rwt209      number(20,6) DEFAULT '0' NOT NULL, /*9月目标金额*/
rwt210      number(20,6) DEFAULT '0' NOT NULL, /*10月目标金额*/
rwt211      number(20,6) DEFAULT '0' NOT NULL, /*11月目标金额*/
rwt212      number(20,6) DEFAULT '0' NOT NULL, /*12月目标金额*/
rwtdate     date,                    /*最近更改日                             */
rwtgrup     varchar2(10),            /*资料所有群                             */
rwtmodu     varchar2(10),            /*资料更改者                             */
rwtorig     varchar2(10),            /*资料建立部门                           */
rwtoriu     varchar2(10),            /*资料建立者                             */
rwtuser     varchar2(10)             /*资料所有者                             */
);

alter table rwt_file add  constraint rwt_pk primary key  (rwt01,rwt02) enable validate;
grant select on rwt_file to tiptopgp;
grant update on rwt_file to tiptopgp;
grant delete on rwt_file to tiptopgp;
grant insert on rwt_file to tiptopgp;
grant index on rwt_file to public;
grant select on rwt_file to ods;
