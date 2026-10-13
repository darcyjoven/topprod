/*
================================================================================
檔案代號:aso_file
檔案名稱:成本法转权益法单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table aso_file
(
aso01       number(5) DEFAULT '0' NOT NULL, /*年度*/
aso02       number(5) DEFAULT '0' NOT NULL, /*月份*/
aso03       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
aso04       varchar2(10) DEFAULT ' ' NOT NULL, /*最上层公司编号*/
aso05       varchar2(10) DEFAULT ' ' NOT NULL, /*投資公司編號*/
aso06       varchar2(24) DEFAULT ' ' NOT NULL, /*长期股权投资科目*/
aso07       varchar2(10) DEFAULT ' ' NOT NULL, /*关系人异动码*/
aso08       number(20,6) DEFAULT '0' NOT NULL, /*金额*/
aso09       varchar2(4),             /*币种                                   */
aso10       varchar2(20),            /*生成調整單單號                         */
aso11       varchar2(5) DEFAULT ' ' NOT NULL, /*合并帐套*/
asolegal    varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

alter table aso_file add  constraint aso_pk primary key  (aso01,aso02,aso03,aso04,aso05,aso06,aso07,aso11) enable validate;
grant select on aso_file to tiptopgp;
grant update on aso_file to tiptopgp;
grant delete on aso_file to tiptopgp;
grant insert on aso_file to tiptopgp;
grant index on aso_file to public;
grant select on aso_file to ods;
