/*
================================================================================
檔案代號:azk_file
檔案名稱:币种每日汇率档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table azk_file
(
azk01       varchar2(4) NOT NULL,    /*币种代码                               */
                                     /*幣別代碼                               */
azk02       date NOT NULL,           /*日期                                   */
                                     /*日期 (當日期='99/12/31'時,表示最近匯率)*/
azk03       number(20,10),           /*银行买入汇率                           */
                                     /*銀行買入匯率                           */
azk04       number(20,10),           /*银行卖出汇率                           */
                                     /*銀行賣出匯率                           */
azk041      number(20,10),           /*银行中价汇率                           */
                                     /*銀行中價匯率                           */
azk05       number(20,10),           /*海关旬  汇率                           */
                                     /*海關旬  匯率                           */
azk051      number(20,10),           /*海关买入汇率                           */
                                     /*海關買入匯率                           */
azk052      number(20,10)            /*海关卖出汇率                           */
                                     /*海關賣出匯率                           */
);

alter table azk_file add  constraint azk_pk primary key  (azk02,azk01) enable validate;
grant select on azk_file to tiptopgp;
grant update on azk_file to tiptopgp;
grant delete on azk_file to tiptopgp;
grant insert on azk_file to tiptopgp;
grant index on azk_file to public;
grant select on azk_file to ods;
