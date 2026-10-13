/*
================================================================================
檔案代號:cap_file
檔案名稱:暂估差异明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cap_file
(
cap01       number(5) DEFAULT '0' NOT NULL, /*年度*/
cap02       number(5) DEFAULT '0' NOT NULL, /*月份*/
cap03       varchar2(40) DEFAULT ' ' NOT NULL, /*产品编号*/
cap04       varchar2(20) DEFAULT ' ' NOT NULL,
cap05       number(5) DEFAULT '0' NOT NULL,
cap06       varchar2(20),
cap07       number(5),               /*暂估项次                               */
cap08       varchar2(20),            /*入库单                                 */
cap09       number(5),               /*入库项次                               */
cap10       number(20,6),
cap11       number(20,6),
cap12       number(20,10),
cap13       number(15,3),            /*入库数量                               */
cap14       number(20,10),           /*重估汇率                               */
cap15       varchar2(1),             /*处理状态                               */
cap16       varchar2(10),            /*处理人员                               */
cap17       date,
cap18       number(20,6) DEFAULT '0' NOT NULL, /*发票单价*/
cap19       number(20,6) DEFAULT '0' NOT NULL /*暫估單價*/
);

alter table cap_file add  constraint cap_pk primary key  (cap01,cap02,cap03,cap04,cap05) enable validate;
grant select on cap_file to tiptopgp;
grant update on cap_file to tiptopgp;
grant delete on cap_file to tiptopgp;
grant insert on cap_file to tiptopgp;
grant index on cap_file to public;
grant select on cap_file to ods;
