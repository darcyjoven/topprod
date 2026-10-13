/*
================================================================================
檔案代號:alh_file
檔案名稱:信用状到单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table alh_file
(
alh00       varchar2(1),             /*改贷别                                 */
                                     /*改貸別 (1.改貸前 2.改貸後)             */
                                     /*改貸別為 "2.改貸後" 時, 底下以'/'區分  */
alh01       varchar2(20) NOT NULL,   /*到单单号                               */
                                     /*到單單號           /改貸到單號碼 010516*/
alh02       date,                    /*起息日期  /改贷日期                    */
                                     /*起息日期           /改貸日期           */
alh021      date,                    /*到单日期 /改贷日期                     */
                                     /*到單日期(收到輸入) /改貸日期(同alh02)  */
alh03       varchar2(20),            /*预购单号                               */
alh04       varchar2(10),            /*部门编号                               */
                                     /*部門編號                               */
alh05       varchar2(10),            /*供应厂商编号                           */
                                     /*供應廠商編號                           */
alh06       varchar2(10),            /*信贷银行/付款厂商编号                  */
                                     /*信貸銀行/付款廠商編號                  */
                                     /*付款條件='LC'時,本欄位=信貸銀行/付款廠商*/
                                     /*付款條件='TT'時,本欄位=付款廠商        */
alh07       number(5),               /*贷款天数                               */
                                     /*貸款天數                               */
alh08       date,                    /*应还日期                               */
                                     /*應還日期                               */
alh09       number(9,4),             /*计息利率                               */
                                     /*計息利率   #No:7354                    */
alh10       varchar2(10),            /*付款条件                               */
                                     /*付款條件 (LC, TT, OA, DA, DP) 001114   */
alh11       varchar2(4),             /*到单币种                               */
                                     /*到單幣別           /改貸幣別           */
alh12       number(20,6),            /*到单原币                               */
                                     /*到單原幣           /改貸原幣           */
alh13       number(20,6),            /*抵保证金原币                           */
                                     /*抵保證金原幣                           */
alh14       number(20,6),            /*应还原币(贷款原币) /改贷应还           */
                                     /*應還原幣(貸款原幣) /改貸應還原幣       */
alh15       number(20,10),           /*到单汇率                               */
                                     /*到單匯率           /改貸匯率           */
alh16       number(20,6),            /*应还本币(贷款本币) /改贷本币           */
                                     /*應還本幣(貸款本幣) /改貸本幣金額       */
alh17       number(20,6),            /*后到货额(本币)                         */
                                     /*後到貨額(本幣)     /0                  */
alh18       number(20,10),           /*信贷额度汇率                           */
                                     /*信貸額度匯率                           */
alh19       number(20,6),            /*抵预付本币                             */
                                     /*抵預付本幣(保證金本幣)                 */
alh20       number(5),               /*No Use                                 */
alh30       varchar2(20),            /*到货单号                               */
                                     /*到貨單號           /原到單號碼         */
                                     /*先到貨時本欄應輸入                     */
                                     /*否則空白)                              */
alh31       date,                    /*到货日期                               */
                                     /*到貨日期           /原到單日期         */
alh32       number(20,6),            /*到货原币                               */
                                     /*到貨原幣           /原到單原幣         */
alh33       number(13,3),            /*No Use                                 */
alh34       number(13,3),            /*No Use                                 */
alh35       number(20,10),           /*到货汇率                               */
                                     /*到貨匯率           /原到單匯率         */
alh36       number(20,6),            /*到货本币                               */
                                     /*到貨本幣           /原到單本幣         */
alh37       number(20,6),            /*立帐差额                               */
                                     /*立帳差額           /0                  */
alh38       number(20,6),            /*汇差损失                               */
                                     /*匯差損失           /改貸匯差損失       */
alh41       varchar2(24),            /*借方科目                               */
                                     /*借方科目           /原銀行貸款科目     */
                                     /*先到貨:暫估應付LC                      */
                                     /*先到單:在途存貨                        */
alh42       varchar2(24),            /*银行贷款科目(贷方) /新银行贷           */
                                     /*銀行貸款科目(貸方) /新銀行貸款科目     */
alh43       varchar2(24),            /*立帐差异科目                           */
                                     /*立帳差異科目       /''                 */
alh44       varchar2(1),             /*付款方式                               */
                                     /*付款方式  No.B103/no use c(20)->c(01)  */
alh45       varchar2(1),             /*到期还款生成否                         */
                                     /*到期還款產生否 /no use c(20)->c(01)    */
alh46       varchar2(20),            /*No Use                                 */
alh50       number(5),               /*保证金比率                             */
                                     /*保証金比率                             */
alh51       varchar2(1),             /*还息方式                               */
                                     /*還息方式: 1.每月還息 2.本息併還        */
alh52       varchar2(1),             /*是否为系统上线的前期历史资             */
                                     /*是否為系統上線的前期歷史資料           */
                                     /* 空白:否, 確認時須更新L/C的已到單額    */
                                     /* 'Y' :是, 確認時不更新L/C的已到單額    */
alh72       varchar2(20),            /*会计凭证编号                           */
                                     /*會計傳票編號       /改貸傳票編號       */
alh73       varchar2(20),            /*还款凭证编号                           */
                                     /*還款傳票編號       /還款傳票編號       */
alh74       date,                    /*改贷还款日期                           */
                                     /*改貸還款日期                           */
alh75       varchar2(1),             /*改贷状况                               */
                                     /*改貸狀況 (0.未改貸 1.已改貸)           */
alh76       number(20,6),            /*已还款原币                             */
                                     /*已還款原幣                             */
alh77       number(20,6),            /*已还款本币                             */
                                     /*已還款本幣                             */
alhfirm     varchar2(1),             /*确认码                                 */
                                     /*確認碼                                 */
alhinpd     date,                    /*录入日期                               */
                                     /*輸入日期                               */
alhacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
alhuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
alhgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
alhmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
alhdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
alh78       varchar2(10),            /*部门                                   */
alh930      varchar2(10),            /*成本中心                               */
alh411      varchar2(24),            /*借方科目二                             */
alh421      varchar2(24),            /*银行贷款科目二(贷方)/新银行            */
alh431      varchar2(24),            /*立帐差异科目二                         */
alhud01     varchar2(255),           /*自订字段-Textedit                      */
alhud02     varchar2(40),            /*自订字段-文字                          */
alhud03     varchar2(40),            /*自订字段-文字                          */
alhud04     varchar2(40),            /*自订字段-文字                          */
alhud05     varchar2(40),            /*自订字段-文字                          */
alhud06     varchar2(40),            /*自订字段-文字                          */
alhud07     number(15,3),            /*自订字段-数值                          */
alhud08     number(15,3),            /*自订字段-数值                          */
alhud09     number(15,3),            /*自订字段-数值                          */
alhud10     number(10),              /*自订字段-整数                          */
alhud11     number(10),              /*自订字段-整数                          */
alhud12     number(10),              /*自订字段-整数                          */
alhud13     date,                    /*自订字段-日期                          */
alhud14     date,                    /*自订字段-日期                          */
alhud15     date,                    /*自订字段-日期                          */
alhlegal    varchar2(10) NOT NULL,   /*所属法人                               */
alhoriu     varchar2(10),            /*资料建立者                             */
alhorig     varchar2(10)             /*资料建立部门                           */
);

create        index alh_05 on alh_file (alh72);
create        index alh_02 on alh_file (alh02);
create        index alh_04 on alh_file (alh30);
create        index alh_03 on alh_file (alh03);
alter table alh_file add  constraint alh_pk primary key  (alh01) enable validate;
grant select on alh_file to tiptopgp;
grant update on alh_file to tiptopgp;
grant delete on alh_file to tiptopgp;
grant insert on alh_file to tiptopgp;
grant index on alh_file to public;
grant select on alh_file to ods;
