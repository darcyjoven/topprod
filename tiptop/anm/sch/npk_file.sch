/*
================================================================================
檔案代號:npk_file
檔案名稱:银行存款异动记录单身档(转账)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table npk_file
(
npk00       varchar2(20) NOT NULL,   /*收支单号                               */
                                     /*收支單號                               */
npk01       number(5) NOT NULL,      /*收支项次                               */
                                     /*收支項次                               */
npk02       varchar2(2),             /*出帐异动码/入帐异动码                  */
                                     /*出帳異動碼/入帳異動碼                  */
npk03       varchar2(1),             /*异动别                                 */
                                     /*異動別: 1:入帳,2:出帳,3:借方科目,4:貸方*/
npk04       varchar2(20),            /*银行编号                               */
                                     /*銀行編號                               */
npk05       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
npk06       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
npk07       varchar2(24),            /*科目编号                               */
                                     /*科目編號                               */
npk071      varchar2(24),            /*对方科目编号                           */
                                     /*對方科目編號 (98/07/30)                */
npk08       number(20,6),            /*原币金额                               */
                                     /*原幣金額                               */
npk09       number(20,6),            /*本币金额                               */
                                     /*本幣金額                               */
npk10       varchar2(80),            /*摘要                                   */
npk11       varchar2(1),             /*进口编号                               */
                                     /*進口編號                               */
npk12       varchar2(20),            /*No Use                                 */
npk13       varchar2(1),             /*No Use                                 */
npk14       varchar2(1),             /*No Use                                 */
npk15       varchar2(1),             /*No Use                                 */
npk072      varchar2(24),            /*科目二                                 */
npk073      varchar2(24),            /*对方科目二                             */
npkud01     varchar2(255),           /*自订字段-Textedit                      */
npkud02     varchar2(40),            /*自订字段-文字                          */
npkud03     varchar2(40),            /*自订字段-文字                          */
npkud04     varchar2(40),            /*自订字段-文字                          */
npkud05     varchar2(40),            /*自订字段-文字                          */
npkud06     varchar2(40),            /*自订字段-文字                          */
npkud07     number(15,3),            /*自订字段-数值                          */
npkud08     number(15,3),            /*自订字段-数值                          */
npkud09     number(15,3),            /*自订字段-数值                          */
npkud10     number(10),              /*自订字段-整数                          */
npkud11     number(10),              /*自订字段-整数                          */
npkud12     number(10),              /*自订字段-整数                          */
npkud13     date,                    /*自订字段-日期                          */
npkud14     date,                    /*自订字段-日期                          */
npkud15     date,                    /*自订字段-日期                          */
npklegal    varchar2(10) NOT NULL,   /*所属法人                               */
npk16       varchar2(10)             /*部门编码                               */
);

create        index npk_04 on npk_file (npk04);
alter table npk_file add  constraint npk_pk primary key  (npk00,npk01) enable validate;
grant select on npk_file to tiptopgp;
grant update on npk_file to tiptopgp;
grant delete on npk_file to tiptopgp;
grant insert on npk_file to tiptopgp;
grant index on npk_file to public;
grant select on npk_file to ods;
