/*
================================================================================
檔案代號:aeo_file
檔案名稱:成本法转权益法单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table aeo_file
(
aeo01       number(5) DEFAULT '0' NOT NULL, /*年度*/
aeo02       number(5) DEFAULT '0' NOT NULL, /*月份*/
aeo03       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
aeo04       varchar2(10) DEFAULT ' ' NOT NULL, /*上层公司编号*/
aeo05       varchar2(10) DEFAULT ' ' NOT NULL, /*投資公司編號*/
aeo06       varchar2(10) DEFAULT ' ' NOT NULL, /*被投资公司*/
aeo07       varchar2(24) DEFAULT ' ' NOT NULL, /*所有者权益科目*/
aeo08       varchar2(10) DEFAULT ' ' NOT NULL, /*母公司关系人编号*/
aeo09       varchar2(4) DEFAULT ' ' NOT NULL, /*子公司幣種*/
aeo10       number(20,6) DEFAULT '0' NOT NULL, /*年初金额*/
aeo11       number(20,10) DEFAULT '0' NOT NULL, /*再衡量汇率*/
aeo12       number(20,10) DEFAULT '0' NOT NULL, /*转换汇率*/
aeo13       number(20,6) DEFAULT '0' NOT NULL, /*合并年初金額*/
aeo14       number(9,4) DEFAULT '0' NOT NULL, /*期末投資比例*/
aeo15       varchar2(24) DEFAULT ' ' NOT NULL, /*投資公司股權科目*/
aeo16       number(20,6) DEFAULT '0' NOT NULL, /*母公司權益-年初*/
aeo17       varchar2(24) DEFAULT ' ' NOT NULL, /*調整科目-年初*/
aeo18       varchar2(5) DEFAULT ' ' NOT NULL, /*投資公司編號*/
aeo19       number(20,6) DEFAULT '0' NOT NULL, /*本年發生額*/
aeo20       number(20,6) DEFAULT '0' NOT NULL, /*合併本年金額*/
aeo21       number(20,6) DEFAULT '0' NOT NULL, /*母公司權益-本年*/
aeo22       varchar2(24),            /*調整科目-本年                          */
aeolegal    varchar2(10)             /*所属法人                               */
);

alter table aeo_file add  constraint aeo_pk primary key  (aeo01,aeo02,aeo03,aeo04,aeo05,aeo06,aeo07,aeo18) enable validate;
grant select on aeo_file to tiptopgp;
grant update on aeo_file to tiptopgp;
grant delete on aeo_file to tiptopgp;
grant insert on aeo_file to tiptopgp;
grant index on aeo_file to public;
grant select on aeo_file to ods;
