/*
================================================================================
檔案代號:ape_file
檔案名稱:应付暂估统计档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ape_file
(
ape01       varchar2(10) DEFAULT ' ' NOT NULL, /*供应商*/
ape02       number(5) DEFAULT '0' NOT NULL, /*年度*/
ape03       number(5) DEFAULT '0' NOT NULL, /*月份*/
ape04       varchar2(40) DEFAULT ' ' NOT NULL, /*料号*/
ape05       number(15,3) DEFAULT '0' NOT NULL,
ape06       number(15,3) DEFAULT '0' NOT NULL,
ape07       number(20,6) DEFAULT '0' NOT NULL,
ape08       number(20,6) DEFAULT '0' NOT NULL,
ape09       number(15,3) DEFAULT '0' NOT NULL,
ape10       number(15,3) DEFAULT '0' NOT NULL,
ape11       number(20,6) DEFAULT '0' NOT NULL, /*帐款类型*/
ape12       number(20,6) DEFAULT '0' NOT NULL,
ape13       number(15,3) DEFAULT '0' NOT NULL,
ape14       number(15,3) DEFAULT '0' NOT NULL,
ape15       number(20,6) DEFAULT '0' NOT NULL,
ape16       number(20,6) DEFAULT '0' NOT NULL,
ape17       number(20,6) DEFAULT '0' NOT NULL,
ape18       number(20,6) DEFAULT '0' NOT NULL,
ape19       number(15,3) DEFAULT '0' NOT NULL,
ape20       number(15,3) DEFAULT '0' NOT NULL,
ape21       number(20,6) DEFAULT '0' NOT NULL,
ape22       number(20,6) DEFAULT '0' NOT NULL,
ape23       number(20,6) DEFAULT '0' NOT NULL, /*no use*/
ape24       number(20,6) DEFAULT '0' NOT NULL, /*no use*/
ape25       number(20,6) DEFAULT '0' NOT NULL, /*no use*/
ape26       number(20,6) DEFAULT '0' NOT NULL, /*no use*/
ape27       varchar2(40),            /*no use                                 */
ape28       varchar2(40),            /*no use                                 */
ape29       date,                    /*no use                                 */
ape30       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
ape31       number(20,6) DEFAULT '0' NOT NULL, /*期初入库暂估原币金额*/
ape32       number(20,6) DEFAULT '0' NOT NULL, /*期初仓退暂估原币金额*/
ape33       number(20,6) DEFAULT '0' NOT NULL, /*入库暂估原币金额*/
ape34       number(20,6) DEFAULT '0' NOT NULL, /*仓退暂估原币金额*/
ape35       number(20,6) DEFAULT '0' NOT NULL, /*入库暂估冲抵原币金额*/
ape36       number(20,6) DEFAULT '0' NOT NULL, /*仓退暂估冲抵原币金额*/
ape37       number(20,6) DEFAULT '0' NOT NULL, /*入库暂估差异原币金额*/
ape38       number(20,6) DEFAULT '0' NOT NULL, /*仓退暂估差异原币金额*/
ape39       number(20,6) DEFAULT '0' NOT NULL, /*期末入库暂估原币金额*/
ape40       number(20,6) DEFAULT '0' NOT NULL, /*期末仓退暂估原币金额*/
ape41       number(20,10) DEFAULT '0' NOT NULL, /*重评价汇率*/
ape42       number(20,6) DEFAULT '0' NOT NULL, /*入库暂估汇差*/
ape43       number(20,6) DEFAULT '0' NOT NULL /*仓退暂估汇差*/
);

alter table ape_file add  constraint ape_pk primary key  (ape01,ape02,ape03,ape04) enable validate;
grant select on ape_file to tiptopgp;
grant update on ape_file to tiptopgp;
grant delete on ape_file to tiptopgp;
grant insert on ape_file to tiptopgp;
grant index on ape_file to public;
grant select on ape_file to ods;
