/*
================================================================================
檔案代號:ponslk_file
檔案名稱:无交期性采购单款式单身
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ponslk_file
(
ponslk01    varchar2(20) DEFAULT ' ' NOT NULL, /*采购单号*/
ponslk02    number(5) DEFAULT '0' NOT NULL, /*项次*/
ponslk04    varchar2(40),            /*料件编号                               */
ponslk041   varchar2(120),           /*品名规格                               */
ponslk06    varchar2(40),            /*厂商料件编号                           */
ponslk07    varchar2(4),             /*采购单位                               */
ponslk19    date,                    /*截至日期                               */
ponslk20    number(15,3) DEFAULT '0' NOT NULL, /*申请数量*/
ponslk21    number(15,3),            /*已转数量                               */
ponslk31    number(20,6) DEFAULT '0' NOT NULL, /*税前单价*/
ponslk31t   number(20,6) DEFAULT '0' NOT NULL, /*含税单价*/
ponslklegal varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
ponslkplant varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table ponslk_file add  constraint ponslk_pk primary key  (ponslk01,ponslk02) enable validate;
grant select on ponslk_file to tiptopgp;
grant update on ponslk_file to tiptopgp;
grant delete on ponslk_file to tiptopgp;
grant insert on ponslk_file to tiptopgp;
grant index on ponslk_file to public;
grant select on ponslk_file to ods;
