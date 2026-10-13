/*
================================================================================
檔案代號:azj_file
檔案名稱:币种每月汇率档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table azj_file
(
azj01       varchar2(4) NOT NULL,    /*币种代码                               */
                                     /*幣別代碼                               */
azj02       varchar2(6) NOT NULL,    /*年月                                   */
azj03       number(20,10),           /*银行买入汇率                           */
                                     /*當月採購平均匯率                       */
azj04       number(20,10),           /*银行卖出汇率                           */
                                     /*當月銷售平均匯率                       */
azj041      number(20,10),           /*银行中价汇率                           */
azj05       number(20,10),           /*月底采购汇率                           */
                                     /*月底採購匯率                           */
azj051      number(20,10),           /*海关买入汇率                           */
azj052      number(20,10),           /*海关卖出汇率                           */
azj06       number(20,10),           /*月底销售汇率                           */
                                     /*月底銷售匯率                           */
azj07       number(20,10),           /*月底重评价汇率                         */
                                     /*月底重評價匯率                         */
azj08       number(9,4),             /*No Use                                 */
azj09       number(9,4),             /*No Use                                 */
azj10       number(9,4),             /*No Use                                 */
azjacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
azjuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
azjgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
azjmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
azjdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
azjoriu     varchar2(10),            /*资料建立者                             */
azjorig     varchar2(10)             /*资料建立部门                           */
);

alter table azj_file add  constraint azj_pk primary key  (azj01,azj02) enable validate;
grant select on azj_file to tiptopgp;
grant update on azj_file to tiptopgp;
grant delete on azj_file to tiptopgp;
grant insert on azj_file to tiptopgp;
grant index on azj_file to public;
grant select on azj_file to ods;
