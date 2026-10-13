/*
================================================================================
檔案代號:wpd_file
檔案名稱:电子采购报价档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table wpd_file
(
wpd01       varchar2(15) DEFAULT ' ' NOT NULL, /*电子采购序号*/
wpd02       date,                    /*报价日期                               */
wpd03       varchar2(10) DEFAULT ' ' NOT NULL, /*厂商编号*/
wpd04       date,                    /*需求日期                               */
wpd05       varchar2(40),            /*料件编号                               */
wpd06       varchar2(120),           /*品名规格                               */
wpd07       varchar2(4),             /*需求单位                               */
wpd08       number(15,3) DEFAULT '0' NOT NULL, /*需求数量*/
wpd09       number(20,6) DEFAULT '0' NOT NULL, /*报价单价*/
wpd10       varchar2(1) DEFAULT ' ',
wpd11       varchar2(1) DEFAULT 'N' NOT NULL, /*比价结束*/
wpd12       date,                    /*報價有效日                             */
wpd13       varchar2(1) DEFAULT 'N' NOT NULL, /*分量计价*/
wpd14       varchar2(10)             /*来源工厂                               */
);

alter table wpd_file add  constraint wpd_pk primary key  (wpd01,wpd03) enable validate;
grant select on wpd_file to tiptopgp;
grant update on wpd_file to tiptopgp;
grant delete on wpd_file to tiptopgp;
grant insert on wpd_file to tiptopgp;
grant index on wpd_file to public;
grant select on wpd_file to ods;
