/*
================================================================================
檔案代號:ala_file
檔案名稱:预付购料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ala_file
(
ala01       varchar2(20) NOT NULL,   /*预付单号                               */
                                     /*預付單號 (L/C No)                      */
                                     /*  當本預付資料由採購部門或會計部門先行輸*/
                                     /*  入時, 尚未知L/C No, 則本欄位請由人工自*/
                                     /*  行流水編號, 視之為預付單號, 實際的 L/C*/
                                     /*  No 請輸入於 ala03 欄位.              */
                                     /*  否則本欄位請輸入 L/C No.             */
ala02       varchar2(10),            /*付款条件                               */
                                     /*付款條件 (LC, TT, OA, DA, DP) 001114   */
ala03       varchar2(20),            /*L/C NO.                                */
ala04       varchar2(10),            /*帐款部门                               */
                                     /*帳款部門                               */
ala05       varchar2(10),            /*付款厂商                               */
                                     /*付款廠商                               */
ala06       varchar2(10),            /*出货厂商                               */
                                     /*出貨廠商 (Shipper)                     */
ala07       varchar2(10),            /*信贷银行/付款厂商编号                  */
                                     /*Credit Bank/Paying Vender No.          */
                                     /*Payment Terms='LC',This Field Value=Credit Bank/Paying Vender*/
ala08       date,                    /*开 状 日                               */
                                     /*開 狀 日                               */
ala09       varchar2(20),            /*价格条件                               */
                                     /*價格條件                               */
ala10       varchar2(1),             /*开状性质                               */
                                     /*開狀性質 98/11/17 modify               */
ala11       date,                    /*有效期限                               */
ala12       varchar2(20),            /*外币开票单号                           */
                                     /*F.C Drawing Slip No                    */
ala13       number(5),               /*外币支票薄号                           */
ala14       varchar2(15),            /*外幣支票號碼                           */
                                     /*外币支票号码                           */
ala20       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
ala21       number(9,4),             /*自备比率                               */
                                     /*自備比率                               */
ala22       number(5),               /*还款天数                               */
                                     /*還款天數                               */
ala23       number(20,6),            /*初开状金额                             */
                                     /*初開狀金額                             */
ala24       number(20,6),            /*更改金额                               */
                                     /*修改金額                               */
ala25       number(20,6),            /*到单金额                               */
                                     /*到單金額(輸入'到單作業'後自動更新)     */
ala26       number(20,6),            /*提单金额                               */
                                     /*提單金額(輸入'提單作業'後自動更新)     */
ala31       varchar2(15),            /*I/P NO.                                */
ala32       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
ala33       varchar2(10),            /*合约编号                               */
                                     /*合約編號                               */
ala34       number(20,6),            /*保证金原币金额                         */
                                     /*保証金原幣金額                         */
ala35       varchar2(10),            /*融资种类                               */
                                     /*融資種類                               */
ala36       varchar2(20),            /*价格条件                               */
                                     /*價格條件                               */
ala37       varchar2(20),            /*FORWORDER                              */
ala38       varchar2(20),            /*Ship By :                              */
ala39       varchar2(20),            /*Ship To :                              */
ala40       varchar2(20),            /*免税                                   */
                                     /*免稅                                   */
ala41       varchar2(24),            /*预付科目                               */
                                     /*預付科目                               */
ala42       varchar2(24),            /*应付科目                               */
                                     /*應付科目                               */
ala43       varchar2(24),            /*付款科目                               */
                                     /*付款科目(銀行存款)                     */
ala44       varchar2(24),            /*付款其他科目-其他费用                  */
                                     /*付款其他科目-其他費用                  */
ala51       number(20,10),           /*开状汇率                               */
                                     /*開狀匯率                               */
ala52       number(20,6),            /*自 备 款                               */
                                     /*自 備 款                               */
ala53       number(20,6),            /*手续费                                 */
                                     /*手續費                                 */
ala54       number(20,6),            /*邮电费                                 */
                                     /*郵電費                                 */
ala55       number(20,6),            /*签证费                                 */
                                     /*簽証費                                 */
ala56       number(20,6),            /*保 险 费                               */
                                     /*保 險 費                               */
ala57       number(20,6),            /*其它费用                               */
                                     /*其它費用                               */
ala59       number(20,6),            /*开状应摊                               */
                                     /*開狀應攤                               */
ala60       number(20,6),            /*更改应摊                               */
                                     /*修改應攤                               */
ala61       number(20,6),            /*开状及更改已摊金额                     */
                                     /*開狀及修改已攤金額                     */
ala71       varchar2(4),             /*外币支付币种                           */
                                     /*外幣支付幣別 98/11/17 modify           */
ala72       varchar2(20),            /*会计凭证单号                           */
                                     /*會計傳票單號(會計請款)                 */
ala73       varchar2(20),            /*付款凭证单号                           */
                                     /*付款傳票單號(會計付款)                 */
ala74       varchar2(20),            /*付款凭证单号                           */
                                     /*付款傳票單號(出納付款)                 */
ala75       varchar2(20),            /*结案凭证单号                           */
                                     /*結案傳票單號                           */
ala76       number(5),               /*支票簿号                               */
                                     /*支票簿號  modi in 00/05/21             */
ala77       date,                    /*会计日期                               */
ala771      date,                    /*结案日期                               */
                                     /*結案日期                               */
ala772      varchar2(80),            /*结案说明                               */
                                     /*結案說明                               */
ala773      number(20,6),            /*结案原币金额                           */
                                     /*結案原幣金額                           */
ala774      number(20,10),           /*结案时汇率                             */
                                     /*結案時匯率                             */
ala775      number(20,6),            /*结案时退还保证金本币金额               */
                                     /*結案時退還保証金本幣金額               */
ala776      varchar2(24),            /*结案时退还保证金银存科目               */
                                     /*結案時退還保証金銀存科目               */
ala777      number(20,6),            /*结案时预付转费用本币金额               */
                                     /*結案時預付轉費用本幣金額               */
ala778      varchar2(24),            /*结案时预付转费用科目                   */
                                     /*結案時預付轉費用科目                   */
ala78       varchar2(1),             /*付款审核码                             */
                                     /*付款確認碼 (Y/N)                       */
ala79       number(20,6),            /*信贷额度换算率                         */
                                     /*信貸額度換算率 (使用額度=貸款額*換算率)*/
ala80       varchar2(1),             /*保证金付款方式                         */
                                     /*付款方式 (0.本幣 1.原幣)               */
ala81       varchar2(20),            /*外币支付银行编号                       */
                                     /*外幣支付銀行編號                       */
ala82       varchar2(1),             /*银行类型                               */
                                     /*銀行類別 (1.支存 2.活存 3.其它)        */
ala83       number(10),              /*电脑编号                               */
                                     /*    電腦編號 (銀行存款異動流水號)      */
ala84       number(20,10),           /*出帐汇率                               */
                                     /*    出帳匯率                           */
ala85       number(20,6),            /*本币保证金                             */
                                     /*    本幣保證金                         */
ala91       varchar2(20),            /*本币支付银行编号                       */
                                     /*本幣支付銀行編號                       */
ala92       varchar2(1),             /*银行类型                               */
                                     /*    銀行類別 (1.支存 2.活存 3.其它)    */
ala93       number(10),              /*电脑编号                               */
                                     /*    電腦編號 (銀行存款異動流水號)      */
ala931      varchar2(20),            /*开票单号                               */
                                     /*    開票單號                           */
ala932      varchar2(20),            /*支票号                                 */
                                     /*      支票號                           */
ala94       number(20,10),           /*保证金支付汇率                         */
                                     /*支付匯率                               */
ala951      number(20,6),            /*本币保证金                             */
                                     /*    本幣保證金                         */
ala952      number(20,6),            /*本币手续费                             */
                                     /*    本幣手續費                         */
ala953      number(20,6),            /*本币邮电费                             */
                                     /*    本幣郵電費                         */
ala95       number(20,6),            /*本币支付合计                           */
                                     /*    本幣支付合計(951+952+953)          */
ala96       varchar2(2),             /*银行异动码                             */
                                     /*銀行異動碼 #modify 00/07/27            */
alaclos     varchar2(1),             /*结案码                                 */
                                     /*結案碼                                 */
alafirm     varchar2(1),             /*确认码                                 */
                                     /*確認碼(Y/N/X)                          */
alainpd     date,                    /*录入日期                               */
                                     /*輸入日期                               */
alamksg     varchar2(1),             /*是否签核                               */
                                     /*是否簽核                               */
alasign     varchar2(4),             /*签核等级                               */
                                     /*簽核等級                               */
aladays     number(5),               /*签核完成天数                           */
                                     /*簽核完成天數                           */
alaprit     number(5),               /*签核优先等级                           */
                                     /*簽核優先等級                           */
alasmax     number(5),               /*应签等级                               */
                                     /*應簽等級                               */
alasseq     number(5),               /*已签等级                               */
                                     /*已簽等級                               */
alaacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
alauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
alagrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
alamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
aladate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
ala86       date,                    /*付款日期                               */
ala930      varchar2(10),            /*成本中心                               */
ala411      varchar2(24),            /*预付科目二                             */
ala421      varchar2(24),            /*应付科目二                             */
ala431      varchar2(24),            /*付款科目二                             */
ala441      varchar2(24),            /*付款其他科目二-其他费用二              */
ala779      varchar2(24),            /*结案时退还保证金银存科目二             */
ala780      varchar2(24),            /*结案时预付转费用科目二                 */
alaud01     varchar2(255),           /*自订字段-Textedit                      */
alaud02     varchar2(40),            /*自订字段-文字                          */
alaud03     varchar2(40),            /*自订字段-文字                          */
alaud04     varchar2(40),            /*自订字段-文字                          */
alaud05     varchar2(40),            /*自订字段-文字                          */
alaud06     varchar2(40),            /*自订字段-文字                          */
alaud07     number(15,3),            /*自订字段-数值                          */
alaud08     number(15,3),            /*自订字段-数值                          */
alaud09     number(15,3),            /*自订字段-数值                          */
alaud10     number(10),              /*自订字段-整数                          */
alaud11     number(10),              /*自订字段-整数                          */
alaud12     number(10),              /*自订字段-整数                          */
alaud13     date,                    /*自订字段-日期                          */
alaud14     date,                    /*自订字段-日期                          */
alaud15     date,                    /*自订字段-日期                          */
alalegal    varchar2(10) NOT NULL,   /*所属法人                               */
ala97       varchar2(10),            /*采购营运中心编号                       */
alaoriu     varchar2(10),            /*资料建立者                             */
alaorig     varchar2(10)             /*资料建立部门                           */
);

create        index ala_04 on ala_file (ala75);
create        index ala_03 on ala_file (ala74);
create        index ala_02 on ala_file (ala72);
alter table ala_file add  constraint ala_pk primary key  (ala01) enable validate;
grant select on ala_file to tiptopgp;
grant update on ala_file to tiptopgp;
grant delete on ala_file to tiptopgp;
grant insert on ala_file to tiptopgp;
grant index on ala_file to public;
grant select on ala_file to ods;
