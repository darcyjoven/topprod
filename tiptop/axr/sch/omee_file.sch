/*
================================================================================
檔案代號:omee_file
檔案名稱:发票与帐款对照档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table omee_file
(
omee01      varchar2(16) DEFAULT ' ' NOT NULL, /*发票编号*/
omee02      varchar2(20) DEFAULT ' ' NOT NULL, /*帐款单号*/
omeedate    date,                    /*资料录入日                             */
omeegrup    varchar2(10),            /*资料所有群                             */
omeelegal   varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
omeemodu    varchar2(10),            /*资料更改者                             */
omeeorig    varchar2(10),            /*资料建立部门                           */
omeeoriu    varchar2(10),            /*资料建立者                             */
omeeuser    varchar2(10),            /*资料所有者                             */
omee03      varchar2(20) DEFAULT ' ' NOT NULL /*发票代码*/
);

alter table omee_file add  constraint omee_pk primary key  (omee01,omee02,omee03) enable validate;
grant select on omee_file to tiptopgp;
grant update on omee_file to tiptopgp;
grant delete on omee_file to tiptopgp;
grant insert on omee_file to tiptopgp;
grant index on omee_file to public;
grant select on omee_file to ods;
