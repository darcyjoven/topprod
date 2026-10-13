/*
================================================================================
檔案代號:idp_file
檔案名稱:委外工單自動開立log
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table idp_file
(
idp01       varchar2(20) DEFAULT ' ' NOT NULL, /*入库单号*/
idp02       number(5) DEFAULT '0' NOT NULL, /*入库项次*/
idp03       number(5) DEFAULT '0' NOT NULL, /*處理項次*/
idp04       date,                    /*处理日期                               */
idp05       varchar2(1),             /*处理成功否                             */
idp06       varchar2(20),            /*工单单号                               */
idp07       varchar2(20),            /*采购单号                               */
idp08       number(5),               /*采购项次                               */
idp09       varchar2(20),            /*发料单号                               */
idp10       number(5),               /*發料項次                               */
idp11       varchar2(80),            /*错误信息                               */
idp12       varchar2(80)             /*錯誤代號(ze01)                         */
);

alter table idp_file add  constraint idp_pk primary key  (idp01,idp02,idp03) enable validate;
grant select on idp_file to tiptopgp;
grant update on idp_file to tiptopgp;
grant delete on idp_file to tiptopgp;
grant insert on idp_file to tiptopgp;
grant index on idp_file to public;
grant select on idp_file to ods;
