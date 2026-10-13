/*
================================================================================
檔案代號:asp_file
檔案名稱:成本法转权益法单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table asp_file
(
asp01       number(5) DEFAULT '0' NOT NULL, /*年度*/
asp02       number(5) DEFAULT '0' NOT NULL, /*月份*/
asp03       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
asp04       varchar2(10) DEFAULT ' ' NOT NULL, /*上层公司编号*/
asp05       varchar2(10) DEFAULT ' ' NOT NULL, /*投資公司編號*/
asp06       varchar2(10) DEFAULT ' ' NOT NULL, /*被投资公司*/
asp07       varchar2(24) DEFAULT ' ' NOT NULL, /*所有者权益科目*/
asp08       varchar2(10) DEFAULT ' ' NOT NULL, /*母公司关系人编号*/
asp09       varchar2(4) DEFAULT ' ' NOT NULL, /*子公司币别*/
asp10       number(20,6) DEFAULT '0' NOT NULL, /*年初金额*/
asp11       number(20,10) DEFAULT '0' NOT NULL, /*再衡量汇率*/
asp12       number(20,10) DEFAULT '0' NOT NULL, /*转换汇率*/
asp13       number(20,6) DEFAULT '0' NOT NULL, /*合并年初金额*/
asp14       number(9,4) DEFAULT '0' NOT NULL, /*期末投资比例*/
asp15       varchar2(24) DEFAULT ' ' NOT NULL, /*投資公司股權科目*/
asp16       number(20,6) DEFAULT '0' NOT NULL, /*母公司權益-年初*/
asp17       varchar2(24) DEFAULT ' ' NOT NULL, /*调成科目-年初*/
asp18       varchar2(10) DEFAULT ' ' NOT NULL, /*投資公司編號*/
asp19       number(20,6) DEFAULT '0' NOT NULL, /*本年發生額*/
asp20       number(20,6) DEFAULT '0' NOT NULL, /*合併本年金額*/
asp21       number(20,6) DEFAULT '0' NOT NULL, /*母公司權益-本年*/
asp22       varchar2(24),            /*調整科目-本年                          */
asplegal    varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

alter table asp_file add  constraint asp_pk primary key  (asp01,asp02,asp03,asp04,asp05,asp06,asp07,asp18) enable validate;
grant select on asp_file to tiptopgp;
grant update on asp_file to tiptopgp;
grant delete on asp_file to tiptopgp;
grant insert on asp_file to tiptopgp;
grant index on asp_file to public;
grant select on asp_file to ods;
