/*
================================================================================
檔案代號:nne_file
檔案名稱:短期融资申请单资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nne_file
(
nne01       varchar2(20) NOT NULL,   /*融资单号                               */
                                     /*融資單號                               */
nne02       date,                    /*申请日期                               */
                                     /*申請日期                               */
nne03       date,                    /*动用日期                               */
                                     /*動用日期                               */
nne04       varchar2(20),            /*信贷银行编号                           */
                                     /*信貸銀行編號                           */
nne05       varchar2(20),            /*存入银行编号                           */
                                     /*存入銀行編號                           */
nne051      varchar2(2),             /*存入异动码                             */
                                     /*存入異動碼                             */
nne06       varchar2(10),            /*融资种类                               */
                                     /*融資種類                               */
nne07       varchar2(1),             /*担保品                                 */
                                     /*擔保品        1.信用借款  2.抵押借款   */
nne08       varchar2(1),             /*付息方式                               */
                                     /*付息方式      1.每月付息  2.還本還息   */
nne09       varchar2(1),             /*计息方式                               */
                                     /*計息方式      1.固定利息  2.浮動       */
nne10       varchar2(80),            /*摘要                                   */
nne111      date,                    /*融资起始日期                           */
                                     /*融資起始日期                           */
nne112      date,                    /*融资截止日期                           */
                                     /*融資截止日期                           */
nne12       number(20,6),            /*融资金额                               */
                                     /*融資金額(原幣)                         */
nne13       number(9,4),             /*借款利率                               */
                                     /*借款利率%           #No:7354           */
nne14       number(9,4),             /*还款利率                               */
                                     /*還款利率%           #No:7354           */
nne15       varchar2(20),            /*L/C NO.                                */
nne16       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
nne17       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
nneex2      number(20,10),           /*额度汇率                               */
                                     /*額度匯率(轉換信貸額度)                 */
nne18       varchar2(4),             /*现金变动码                             */
                                     /*現金變動碼                             */
nne19       number(20,6),            /*本币融资金额                           */
                                     /*本幣融資金額            02/11/26 alter */
nne20       number(20,6),            /*本币已还余额                           */
                                     /*本幣已還餘額                           */
nne21       date,                    /*还款日                                 */
                                     /*還款日                                 */
nne22       number(10),              /*还息日                                 */
                                     /*還息日                                 */
nne23       number(9,4),             /*承销费利率                             */
                                     /*承銷費利率％                           */
nne24       number(20,6),            /*承销费用(手续费用)                     */
                                     /*承銷費用(手續費用)       02/11/26 alter*/
nne25       number(20,6),            /*本票折价                               */
                                     /*本票折價                 02/11/26 alter*/
nne26       date,                    /*结案日期                               */
                                     /*結案日期                               */
nne27       number(20,6),            /*原币已还余额                           */
                                     /*原幣已還餘額                           */
nne28       varchar2(20),            /*参考单号                               */
                                     /*參考單號(LC到單號/NP單號)              */
nne29       number(20,6),            /*保证金费用                             */
                                     /*保證金費用               02/11/26 alter*/
nne30       varchar2(10),            /*合约编号                               */
                                     /*合約編號                               */
nne31       varchar2(8),             /*背书保证公司                           */
nne32       varchar2(1),             /*开帐否                                 */
                                     /*No Use                                 */
nne33       date,                    /*最后还息日                             */
                                     /*No Use                                 */
nne34       number(9,4),             /*保证金利率                             */
                                     /*保證金利率％ add (99/06/02)            */
nne35       varchar2(20),            /*他保银行编号                           */
                                     /*他保銀行編號 add (99/06/02)            */
nne36       number(9,4),             /*签证费率                               */
                                     /*簽證費率   add (99/06/02)              */
nne37       number(20,6),            /*签证费用                               */
                                     /*簽證費用 add   (99/06/02) 02/11/26 alter*/
nne38       varchar2(2),             /*银行存款异动码                         */
                                     /*銀行存款異動碼 (add in 99/06/02)       */
nne39       varchar2(1),             /*No Use                                 */
nne40       varchar2(1),             /*No Use                                 */
nne41       varchar2(1),             /*背书保证否                             */
                                     /*背書保證否(Y/N)           #03/01/03add */
nne42       number(20,6),            /*保证额                                 */
                                     /*保證額                    #03/01/03add */
nne43       varchar2(10),            /*来源营运中心                           */
                                     /*來源工廠                  #03/01/03add */
nne44       varchar2(10),            /*部门                                   */
                                     /*部門                      #03/01/03add */
nne_d1      varchar2(24),            /*借方科目-银行存款                      */
                                     /*借方科目-銀行存款                      */
nne_d2      varchar2(24),            /*借方科目-折价/利息                     */
                                     /*借方科目-折價/利息                     */
nne_d3      varchar2(24),            /*借方科目-手续费                        */
                                     /*借方科目-手續費                        */
nne_d4      varchar2(24),            /*借方科目-保证费用                      */
nne_d5      varchar2(24),            /*借方科目-承销费                        */
nne_d6      varchar2(24),            /*借方科目-签证费                        */
nne_c1      varchar2(24),            /*贷方科目-应付商业本票/借款             */
                                     /*貸方科目-應付商業本票/借款             */
nneglno     varchar2(20),            /*凭证编号                               */
                                     /*傳票編號                               */
nneconf     varchar2(1),             /*审核否                                 */
                                     /*確認否(Y/N/X)                          */
nneacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
nneuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
nnegrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
nnemodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
nnedate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
nne45       number(9,4),             /*交割服务费率                           */
nne46       number(20,6),            /*交割服务费用                           */
nne_d7      varchar2(24),            /*借方科目-交割服务费                    */
nne_d11     varchar2(24),            /*借方科目二-银行存款                    */
nne_d21     varchar2(24),            /*借方科目二-折价/利息                   */
nne_d31     varchar2(24),            /*借方科目二-手续费                      */
nne_d41     varchar2(24),            /*借方科目二-保证费                      */
nne_d51     varchar2(24),            /*借方科目二-承销费                      */
nne_d61     varchar2(24),            /*借方科目二-签证费                      */
nne_d71     varchar2(24),            /*借方科目二-交割服务费                  */
nne_c11     varchar2(24),            /*贷方科目二-应付商业本票/借             */
nne241      number(20,6),            /*承销费用原币金额                       */
nne291      number(20,6),            /*保证金费用原币金额                     */
nne371      number(20,6),            /*签证费用原币金额                       */
nne461      number(20,6),            /*交割服务费用原币金额                   */
nneud01     varchar2(255),           /*自订字段-Textedit                      */
nneud02     varchar2(40),            /*自订字段-文字                          */
nneud03     varchar2(40),            /*自订字段-文字                          */
nneud04     varchar2(40),            /*自订字段-文字                          */
nneud05     varchar2(40),            /*自订字段-文字                          */
nneud06     varchar2(40),            /*自订字段-文字                          */
nneud07     number(15,3),            /*自订字段-数值                          */
nneud08     number(15,3),            /*自订字段-数值                          */
nneud09     number(15,3),            /*自订字段-数值                          */
nneud10     number(10),              /*自订字段-整数                          */
nneud11     number(10),              /*自订字段-整数                          */
nneud12     number(10),              /*自订字段-整数                          */
nneud13     date,                    /*自订字段-日期                          */
nneud14     date,                    /*自订字段-日期                          */
nneud15     date,                    /*自订字段-日期                          */
nnelegal    varchar2(10) NOT NULL,   /*所属法人                               */
nneoriu     varchar2(10),            /*资料建立者                             */
nneorig     varchar2(10)             /*资料建立部门                           */
);

create        index nne_02 on nne_file (nneglno);
alter table nne_file add  constraint nne_pk primary key  (nne01) enable validate;
grant select on nne_file to tiptopgp;
grant update on nne_file to tiptopgp;
grant delete on nne_file to tiptopgp;
grant insert on nne_file to tiptopgp;
grant index on nne_file to public;
grant select on nne_file to ods;
