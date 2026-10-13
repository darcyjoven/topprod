/*
================================================================================
檔案代號:ccy_file
檔案名稱:库存及在制成本计算的特殊状况信息档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ccy_file
(
ccy01       date,                    /*运行日期                               */
                                     /*執行日期                               */
ccy02       varchar2(8),             /*运行时间                               */
                                     /*執行時間                               */
ccy03       varchar2(10),            /*运行人员                               */
                                     /*執行人員                               */
ccy04       varchar2(255)            /*特殊状况信息档                         */
                                     /*特殊狀況訊息檔                         */
);

grant select on ccy_file to tiptopgp;
grant update on ccy_file to tiptopgp;
grant delete on ccy_file to tiptopgp;
grant insert on ccy_file to tiptopgp;
grant index on ccy_file to public;
grant select on ccy_file to ods;
