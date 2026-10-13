/*
================================================================================
檔案代號:rci_file
檔案名稱:专柜对账单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rci_file
(
rci01       varchar2(20) DEFAULT ' ' NOT NULL, /*专柜对账单号*/
rci02       varchar2(1) DEFAULT ' ' NOT NULL, /*对账类型*/
rci03       number(5) DEFAULT '0' NOT NULL, /*项次*/
rci04       varchar2(10),            /*抽成编号                               */
rci05       number(6,2),             /*抽成率                                 */
rci06       varchar2(1) DEFAULT ' ' NOT NULL, /*核算资料含税否*/
rci07       number(20,6) DEFAULT '0' NOT NULL, /*核算销售金额*/
rci08       number(20,6) DEFAULT '0' NOT NULL, /*未税抽成金额*/
rci09       number(20,6) DEFAULT '0' NOT NULL, /*含税抽成金额*/
rci10       varchar2(10),            /*费用代码                               */
rci11       number(20,6) DEFAULT '0' NOT NULL, /*未税费用金额*/
rci12       number(20,6) DEFAULT '0' NOT NULL, /*含税费用金额*/
rcilegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
rciplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table rci_file add  constraint rci_pk primary key  (rci01,rci02,rci03) enable validate;
grant select on rci_file to tiptopgp;
grant update on rci_file to tiptopgp;
grant delete on rci_file to tiptopgp;
grant insert on rci_file to tiptopgp;
grant index on rci_file to public;
grant select on rci_file to ods;
