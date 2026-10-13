/*
================================================================================
檔案代號:aen_file
檔案名稱:成本法转权益法单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table aen_file
(
aen01       number(5) DEFAULT '0' NOT NULL, /*年度*/
aen02       number(5) DEFAULT '0' NOT NULL, /*月份*/
aen03       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
aen04       varchar2(10) DEFAULT ' ' NOT NULL, /*最上层公司编号*/
aen05       varchar2(10) DEFAULT ' ' NOT NULL, /*投資公司編號*/
aen06       varchar2(24) DEFAULT ' ' NOT NULL, /*长期股权投资科目*/
aen07       varchar2(10) DEFAULT ' ' NOT NULL, /*关系人核算项*/
aen08       number(20,6) DEFAULT '0' NOT NULL, /*金额*/
aen09       varchar2(4),             /*币种                                   */
aen10       varchar2(20),            /*生成調整單單號                         */
aen11       varchar2(5) DEFAULT ' ' NOT NULL, /*合并帐套*/
aenlegal    varchar2(10)             /*所属法人                               */
);

alter table aen_file add  constraint aen_pk primary key  (aen01,aen02,aen03,aen04,aen05,aen06,aen07,aen11) enable validate;
grant select on aen_file to tiptopgp;
grant update on aen_file to tiptopgp;
grant delete on aen_file to tiptopgp;
grant insert on aen_file to tiptopgp;
grant index on aen_file to public;
grant select on aen_file to ods;
