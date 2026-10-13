/*
================================================================================
檔案代號:nng_file
檔案名稱:中长期贷款申请资料档单头
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nng_file
(
nng01       varchar2(20) NOT NULL,   /*合约编号                               */
                                     /*合約編號                               */
nng02       date,                    /*申请日期                               */
                                     /*申請日期                               */
nng03       date,                    /*动用日期                               */
                                     /*動用日期                               */
nng04       varchar2(20),            /*信贷银行编号                           */
                                     /*信貸銀行代號                           */
nng05       varchar2(20),            /*存入银行编号                           */
                                     /*存入銀行代號                           */
nng051      varchar2(2),             /*存入异动码                             */
                                     /*存入異動碼                             */
nng06       varchar2(40),            /*担保品                                 */
                                     /*擔保品                                 */
nng07       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
nng081      date,                    /*起始借款日期                           */
nng082      date,                    /*截止借款日期                           */
nng09       number(20,6) DEFAULT '0' NOT NULL, /*利率*/
                                     /*利率％             #No:7354            */
nng101      date,                    /*起始还款日期                           */
                                     /*起始還款日期                           */
nng102      date,                    /*截止还款日期                           */
                                     /*截止還款日期                           */
nng11       number(10),              /*期数                                   */
                                     /*期數                                   */
nng12       varchar2(1),             /*付款方式                               */
                                     /*付款方式   1.月付  2.季付 3.半年 4.年  */
nng13       number(10),              /*付息日                                 */
nng14       varchar2(1),             /*计息方式                               */
                                     /*計息方式   1.固定利息  2.浮動          */
nng15       varchar2(1),             /*还款本票                               */
                                     /*還款本票   1.實際      2.虛擬   3.不開 */
nng16       varchar2(1),             /*付息方式                               */
                                     /*付息方式  1.每月付息 2.還本還息        */
nng17       varchar2(4),             /*现金变动码                             */
                                     /*現金變動碼                             */
nng18       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
nng19       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
nngex2      number(20,10),           /*额度汇率                               */
                                     /*額度匯率(轉換信貸額度)                 */
nng20       number(20,6),            /*原币贷款金额                           */
                                     /*原幣貸款金額                           */
nng21       number(20,6),            /*原币已还金额                           */
                                     /*原幣已還金額                           */
nng22       number(20,6),            /*本币贷款金额                           */
                                     /*本幣貸款金額                           */
nng23       number(20,6),            /*本币已还金额                           */
                                     /*本幣已還金額                           */
nng24       varchar2(10),            /*长贷种类                               */
                                     /*長貸種類 modi in 00/03/16              */
nng25       varchar2(1),             /*开帐否                                 */
nng26       date,                    /*最后还息日                             */
nng27       varchar2(1),             /*No Use                                 */
nng28       varchar2(1),             /*No Use                                 */
nng29       varchar2(1),             /*No Use                                 */
nng41       varchar2(20),            /*N/P 单号                               */
                                     /*N/P 單號                               */
nng42       varchar2(20),            /*付款银行                               */
                                     /*付款銀行                               */
nng43       date,                    /*开 票 日                               */
                                     /*開 票 日                               */
nng44       varchar2(2),             /*票 别 一                               */
                                     /*票 別 一                               */
nng45       varchar2(2),             /*票 别 二                               */
                                     /*票 別 二                               */
nng46       varchar2(4),             /*No Use                                 */
nng47       varchar2(10),            /*部门编号                               */
                                     /*部門編號                               */
nng48       varchar2(10),            /*厂商编号                               */
                                     /*廠商編號                               */
nng49       varchar2(80),            /*票据抬头                               */
                                     /*票據抬頭                               */
nng50       varchar2(10),            /*付款理由                               */
nng51       varchar2(40),            /*厂商简称                               */
                                     /*廠商簡稱                               */
nng52       varchar2(20),            /*合约单号                               */
                                     /*合約單號                   #03/01/10 add*/
nng53       number(20,6),            /*总借款成本                             */
                                     /*總借款成本                 #03/01/10 add*/
nng54       varchar2(20),            /*他保银行                               */
                                     /*他保銀行                   #03/01/10 add*/
nng55       number(20,6),            /*本票折价                               */
                                     /*本票折價                   #03/01/10 add*/
nng56       number(9,4),             /*保证金费率                             */
                                     /*保證金費率%                #03/01/10 add*/
nng57       number(20,6),            /*保证费                                 */
                                     /*保證費                     #03/01/10 add*/
nng58       number(9,4),             /*承销费率                               */
                                     /*承銷費率%                  #03/01/10 add*/
nng59       number(20,6),            /*承销费                                 */
                                     /*承銷費                     #03/01/10 add*/
nng60       number(9,4),             /*签证费率                               */
                                     /*簽證費率%                  #03/01/10 add*/
nng61       number(20,6),            /*签证费                                 */
                                     /*簽證費                     #03/01/10 add*/
nng_d1      varchar2(24),            /*借方科目-1                             */
nng_d2      varchar2(24),            /*借方科目-2                             */
nng_c1      varchar2(24),            /*贷方科目-1                             */
                                     /*貸方科目-1                             */
nng_c2      varchar2(24),            /*贷方科目-2                             */
                                     /*貸方科目-2                             */
nngglno     varchar2(20),            /*凭证编号                               */
                                     /*傳票編號                               */
nngconf     varchar2(1),             /*确认码                                 */
                                     /*確認碼(Y/N/X)                          */
nngacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
nnguser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
nnggrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
nngmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
nngdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
nng_d11     varchar2(24),            /*借方科目二-1                           */
nng_d21     varchar2(24),            /*借方科目二-2                           */
nng_c11     varchar2(24),            /*贷方科目二-1                           */
nng_c21     varchar2(24),            /*贷方科目二-2                           */
nngud01     varchar2(255),           /*自订字段-Textedit                      */
nngud02     varchar2(40),            /*自订字段-文字                          */
nngud03     varchar2(40),            /*自订字段-文字                          */
nngud04     varchar2(40),            /*自订字段-文字                          */
nngud05     varchar2(40),            /*自订字段-文字                          */
nngud06     varchar2(40),            /*自订字段-文字                          */
nngud07     number(15,3),            /*自订字段-数值                          */
nngud08     number(15,3),            /*自订字段-数值                          */
nngud09     number(15,3),            /*自订字段-数值                          */
nngud10     number(10),              /*自订字段-整数                          */
nngud11     number(10),              /*自订字段-整数                          */
nngud12     number(10),              /*自订字段-整数                          */
nngud13     date,                    /*自订字段-日期                          */
nngud14     date,                    /*自订字段-日期                          */
nngud15     date,                    /*自订字段-日期                          */
nnglegal    varchar2(10) NOT NULL,   /*所属法人                               */
nngoriu     varchar2(10),            /*资料建立者                             */
nngorig     varchar2(10)             /*资料建立部门                           */
);

create        index nng_02 on nng_file (nngglno);
alter table nng_file add  constraint nng_pk primary key  (nng01) enable validate;
grant select on nng_file to tiptopgp;
grant update on nng_file to tiptopgp;
grant delete on nng_file to tiptopgp;
grant insert on nng_file to tiptopgp;
grant index on nng_file to public;
grant select on nng_file to ods;
