/*
================================================================================
檔案代號:asf_file
檔案名稱:合并报表历史汇率档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table asf_file
(
asf01       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
asf02       varchar2(10) DEFAULT ' ' NOT NULL, /*公司代码*/
asf03       varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
asf04       varchar2(4),             /*记账币种                               */
asf05       number(20,6) DEFAULT '0' NOT NULL, /*记账币种金额*/
asf06       date DEFAULT sysdate NOT NULL, /*异动日期*/
asf07       varchar2(24) DEFAULT ' ' NOT NULL, /*来源科目*/
asf08       number(5) DEFAULT '0' NOT NULL, /*历史年度*/
asf09       number(5) DEFAULT '0' NOT NULL, /*历史期别*/
asf10       number(5) DEFAULT '0' NOT NULL, /*异动年度*/
asf11       number(5) DEFAULT '0' NOT NULL, /*异动期别*/
asf12       number(20,10) DEFAULT '0' NOT NULL, /*历史汇率*/
asf13       number(20,6) DEFAULT '0' NOT NULL, /*合并币种金额*/
asf14       varchar2(4),             /*功能币种                               */
asf15       number(20,10) DEFAULT '0' NOT NULL, /*再衡量汇率*/
asf16       number(20,6) DEFAULT '0' NOT NULL /*功能币种金额*/
);

alter table asf_file add  constraint asf_pk primary key  (asf01,asf02,asf03,asf06,asf07) enable validate;
grant select on asf_file to tiptopgp;
grant update on asf_file to tiptopgp;
grant delete on asf_file to tiptopgp;
grant insert on asf_file to tiptopgp;
grant index on asf_file to public;
grant select on asf_file to ods;
