/*
================================================================================
檔案代號:aep_file
檔案名稱:现金流量表直接法导入资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table aep_file
(
aep01       varchar2(10) DEFAULT ' ' NOT NULL, /*集团代号*/
aep02       varchar2(10) DEFAULT ' ' NOT NULL, /*来源公司编号*/
aep03       number(5) DEFAULT '0' NOT NULL, /*年度*/
aep04       number(5) DEFAULT '0' NOT NULL, /*期别*/
aep05       varchar2(4) DEFAULT ' ' NOT NULL, /*现金异动码*/
aep06       number(20,6) DEFAULT '0' NOT NULL, /*转换后金额*/
aep07       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
aep08       number(20,10) DEFAULT '0' NOT NULL, /*功能币汇率*/
aep09       number(20,6) DEFAULT '0' NOT NULL, /*原始金额*/
aep10       varchar2(4) DEFAULT ' ' NOT NULL, /*来源公司币种*/
aep11       varchar2(2),             /*变动分类                               */
aep12       varchar2(30) DEFAULT ' ' NOT NULL, /*关系人*/
aep13       number(20,6) DEFAULT '0' NOT NULL, /*个体功能币金额*/
aep14       varchar2(4),             /*个体功能币币种                         */
aep15       number(20,10) DEFAULT '0' NOT NULL, /*转换汇率*/
aeplegal    varchar2(10),            /*所属法人                               */
aep16       varchar2(100),           /*说明                                   */
aep17       varchar2(2)              /*变动分类                               */
);

alter table aep_file add  constraint aep_pk primary key  (aep01,aep02,aep03,aep04,aep05,aep12) enable validate;
grant select on aep_file to tiptopgp;
grant update on aep_file to tiptopgp;
grant delete on aep_file to tiptopgp;
grant insert on aep_file to tiptopgp;
grant index on aep_file to public;
grant select on aep_file to ods;
