/*
================================================================================
檔案代號:cdc_file
檔案名稱:每月工单人工/制费档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cdc_file
(
cdc01       number(5) DEFAULT '0' NOT NULL, /*年度*/
cdc02       number(5) DEFAULT '0' NOT NULL, /*月份*/
cdc03       varchar2(10) DEFAULT ' ' NOT NULL, /*成本中心*/
cdc04       varchar2(10) DEFAULT ' ' NOT NULL, /*成本项目*/
cdc041      varchar2(20) DEFAULT ' ' NOT NULL, /*工单代号*/
cdc05       number(15,3) DEFAULT '0' NOT NULL, /*成本*/
cdc06       number(15,3) DEFAULT '0' NOT NULL, /*分摊基础指标总数*/
cdc07       number(15,6) DEFAULT '0' NOT NULL, /*单位成本*/
cdc08       varchar2(1) DEFAULT ' ' NOT NULL, /*分摊方式*/
cdcdate     date,                    /*最近更改日                             */
cdcgrup     varchar2(10),            /*资料所有部门                           */
cdcmodu     varchar2(10),            /*资料更改者                             */
cdcuser     varchar2(10),            /*资料所有者                             */
cdc09       varchar2(1),             /*制费类别                               */
cdc10       number(15,3),            /*标准产能                               */
cdclegal    varchar2(10) NOT NULL,   /*所属法人                               */
cdcorig     varchar2(10),            /*资料建立部门                           */
cdcoriu     varchar2(10),            /*资料建立者                             */
cdc00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
cdc11       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
cdc12       varchar2(24),            /*科目编号                               */
cdc13       varchar2(30)             /*分录底稿单号                           */
);

alter table cdc_file add  constraint cdc_pk primary key  (cdc01,cdc02,cdc03,cdc04,cdc041,cdc08,cdc11) enable validate;
grant select on cdc_file to tiptopgp;
grant update on cdc_file to tiptopgp;
grant delete on cdc_file to tiptopgp;
grant insert on cdc_file to tiptopgp;
grant index on cdc_file to public;
grant select on cdc_file to ods;
