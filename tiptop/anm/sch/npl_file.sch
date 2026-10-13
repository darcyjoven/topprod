/*
================================================================================
檔案代號:npl_file
檔案名稱:应付票据异动单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table npl_file
(
npl01       varchar2(20) NOT NULL,   /*单据编号                               */
                                     /*單據編號                               */
npl02       date,                    /*单据日期                               */
                                     /*單據日期                               */
npl03       varchar2(1),             /*异动别                                 */
                                     /*異動別1.開票 6.撤票 7.退票 8.兌票 9.作廢*/
npl04       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
npl05       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
npl06       varchar2(24),            /*借方科目                               */
npl07       varchar2(24),            /*贷方科目                               */
                                     /*貸方科目                               */
npl08       varchar2(80),            /*摘要                                   */
npl09       varchar2(20),            /*凭证编号                               */
                                     /*傳票編號                               */
npl10       number(20,6),            /*原币金额                               */
                                     /*原幣金額                               */
npl11       number(20,6),            /*本币开票金额                           */
                                     /*本幣開票金額                           */
npl12       number(20,6),            /*本币异动金额                           */
                                     /*本幣異動金額                           */
nplconf     varchar2(1),             /*确认码                                 */
                                     /*確認碼(Y/N/X)                          */
npluser     varchar2(10),            /*资料录入者                             */
                                     /*資料輸入者                             */
nplgrup     varchar2(10),            /*资料录入者部门                         */
                                     /*資料輸入者部門                         */
npldate     date,                    /*资料录入日期                           */
                                     /*資料輸入日期                           */
npl061      varchar2(24),            /*借方科目二                             */
npl071      varchar2(24),            /*贷方科目二                             */
nplud01     varchar2(255),           /*自订字段-Textedit                      */
nplud02     varchar2(40),            /*自订字段-文字                          */
nplud03     varchar2(40),            /*自订字段-文字                          */
nplud04     varchar2(40),            /*自订字段-文字                          */
nplud05     varchar2(40),            /*自订字段-文字                          */
nplud06     varchar2(40),            /*自订字段-文字                          */
nplud07     number(15,3),            /*自订字段-数值                          */
nplud08     number(15,3),            /*自订字段-数值                          */
nplud09     number(15,3),            /*自订字段-数值                          */
nplud10     number(10),              /*自订字段-整数                          */
nplud11     number(10),              /*自订字段-整数                          */
nplud12     number(10),              /*自订字段-整数                          */
nplud13     date,                    /*自订字段-日期                          */
nplud14     date,                    /*自订字段-日期                          */
nplud15     date,                    /*自订字段-日期                          */
npllegal    varchar2(10) NOT NULL,   /*所属法人                               */
nploriu     varchar2(10),            /*资料建立者                             */
nplorig     varchar2(10)             /*资料建立部门                           */
);

create        index npl_02 on npl_file (npl02);
create        index npl_03 on npl_file (npl09);
alter table npl_file add  constraint npl_pk primary key  (npl01) enable validate;
grant select on npl_file to tiptopgp;
grant update on npl_file to tiptopgp;
grant delete on npl_file to tiptopgp;
grant insert on npl_file to tiptopgp;
grant index on npl_file to public;
grant select on npl_file to ods;
