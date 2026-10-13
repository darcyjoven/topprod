/*
================================================================================
檔案代號:omk_file
檔案名稱:应收实际交易税别明细资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table omk_file
(
omk01       varchar2(20) DEFAULT ' ' NOT NULL, /*帐款编号*/
omk02       number(5) DEFAULT '0' NOT NULL, /*序号*/
omk03       varchar2(4) DEFAULT ' ' NOT NULL, /*税种*/
omk04       number(9,4) DEFAULT '0' NOT NULL, /*税率*/
omk05       number(20,6) DEFAULT '0' NOT NULL, /*固定金额*/
omk06       varchar2(1) DEFAULT ' ' NOT NULL, /*含税否*/
omk07       number(20,6) DEFAULT '0' NOT NULL, /*税前金额*/
omk07t      number(20,6) DEFAULT '0' NOT NULL, /*含税金额*/
omk08       number(20,6) DEFAULT '0' NOT NULL, /*税额*/
omk09       number(20,6) DEFAULT '0' NOT NULL, /*留抵税额*/
omkdate     date,                    /*最近更改日                             */
omkgrup     varchar2(10),            /*资料所有群                             */
omklegal    varchar2(10),            /*所属法人                               */
omkmodu     varchar2(10),            /*资料更改者                             */
omkorig     varchar2(10),            /*资料建立部门                           */
omkoriu     varchar2(10),            /*资料建立者                             */
omkuser     varchar2(10)             /*资料所有者                             */
);

alter table omk_file add  constraint omk_pk primary key  (omk01,omk02) enable validate;
grant select on omk_file to tiptopgp;
grant update on omk_file to tiptopgp;
grant delete on omk_file to tiptopgp;
grant insert on omk_file to tiptopgp;
grant index on omk_file to public;
grant select on omk_file to ods;
