/*
================================================================================
檔案代號:oml_file
檔案名稱:应收单身税别明细资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oml_file
(
oml01       varchar2(20) DEFAULT ' ' NOT NULL, /*帐款编号*/
oml02       number(5) DEFAULT '0' NOT NULL, /*项次*/
oml03       number(5) DEFAULT '0' NOT NULL, /*序号*/
oml04       varchar2(4) DEFAULT ' ' NOT NULL, /*税种*/
oml05       number(9,4) DEFAULT '0' NOT NULL, /*税率*/
oml06       number(20,6) DEFAULT '0' NOT NULL, /*固定金额*/
oml07       varchar2(1) DEFAULT ' ' NOT NULL, /*含税否*/
oml08       number(20,6) DEFAULT '0' NOT NULL, /*税前金额*/
oml08t      number(20,6) DEFAULT '0' NOT NULL, /*含税金额*/
oml09       number(20,6) DEFAULT '0' NOT NULL, /*税额*/
omldate     date,                    /*最近更改日                             */
omlgrup     varchar2(10),            /*资料所有部门                           */
omllegal    varchar2(10),            /*所属法人                               */
omlmodu     varchar2(10),            /*资料更改者                             */
omlorig     varchar2(10),            /*资料建立部门                           */
omloriu     varchar2(10),            /*资料建立者                             */
omluser     varchar2(10)             /*资料所有者                             */
);

alter table oml_file add  constraint oml_pk primary key  (oml01,oml02,oml03) enable validate;
grant select on oml_file to tiptopgp;
grant update on oml_file to tiptopgp;
grant delete on oml_file to tiptopgp;
grant insert on oml_file to tiptopgp;
grant index on oml_file to public;
grant select on oml_file to ods;
