/*
================================================================================
檔案代號:wpc_file
檔案名稱:电子采购需求档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table wpc_file
(
wpc01       varchar2(15) DEFAULT ' ' NOT NULL, /*电子采购序号*/
wpc02       varchar2(1) DEFAULT 'N' NOT NULL, /*需求来源(1.请购单,2.预测需求)*/
wpc03       varchar2(10) DEFAULT ' ' NOT NULL, /*厂商编号*/
wpc04       date,                    /*需求日期                               */
wpc05       varchar2(40),            /*料件编号                               */
wpc06       varchar2(120),           /*品名规格                               */
wpc07       varchar2(4),             /*需求单位                               */
wpc08       number(15,3) DEFAULT '0' NOT NULL, /*需求数量*/
wpc09       varchar2(1) DEFAULT 'N' NOT NULL, /*公司结束否*/
wpc10       date,                    /*报价截止日                             */
wpc11       varchar2(10)             /*来源工厂                               */
);

alter table wpc_file add  constraint wpc_pk primary key  (wpc01,wpc03) enable validate;
grant select on wpc_file to tiptopgp;
grant update on wpc_file to tiptopgp;
grant delete on wpc_file to tiptopgp;
grant insert on wpc_file to tiptopgp;
grant index on wpc_file to public;
grant select on wpc_file to ods;
