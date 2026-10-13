/*
================================================================================
檔案代號:nmh_file
檔案名稱:应收票据资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nmh_file
(
nmh01       varchar2(20) NOT NULL,   /*收票单号                               */
                                     /*收票單號                               */
nmh02       number(20,6),            /*原币金额                               */
                                     /*原幣金額                               */
nmh03       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
nmh04       date,                    /*收票日                                 */
nmh05       date,                    /*到期日                                 */
nmh06       varchar2(20),            /*付款银行                               */
                                     /*付款銀行                               */
nmh07       varchar2(30),            /*帐号                                   */
                                     /*帳號                                   */
nmh08       number(5),               /*入帐日数                               */
                                     /*入帳日數                               */
nmh09       date,                    /*预兑日                                 */
                                     /*預兌日                                 */
nmh10       varchar2(2),             /*票别一                                 */
                                     /*票別一                                 */
nmh11       varchar2(10),            /*客户编号                               */
                                     /*客戶編號                               */
nmh12       varchar2(4),             /*现金变动码                             */
                                     /*現金變動碼                             */
nmh13       varchar2(1),             /*客票                                   */
                                     /*客票(Y/N)                              */
nmh14       varchar2(80),            /*发票人                                 */
                                     /*發票人                                 */
nmh15       varchar2(10),            /*部门编号                               */
                                     /*部門編號                               */
nmh16       varchar2(10),            /*收款人员编号                           */
                                     /*收款人員編號                           */
nmh17       number(20,6),            /*已冲金额                               */
                                     /*Contra'd Amount                        */
                                     /*Be Contra Doc. No. Originally ,But Considered The Function Of Contra Multi-Customers, Change To Inputting Blank Mean Suspense Credit Note. Updated Contra Doc. No. To The Field After AXR Module Contra Processing Contra'd, So Blank Means Uncontra*/
nmh171      number(5),               /*冲帐单项次                             */
nmh18       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
nmh19       varchar2(1),             /*托贴别                                 */
                                     /*託貼別 只可為2,3,4                     */
                                     /*2_託收 3_質押 4_票貼                   */
nmh20       date,                    /*托贴日                                 */
                                     /*託貼日                                 */
nmh21       varchar2(20),            /*托贴银行                               */
                                     /*託貼銀行                               */
nmh22       varchar2(10),            /*转付厂商编号                           */
                                     /*轉付廠商編號                           */
nmh23       varchar2(80),            /*转付厂商简称                           */
nmh24       varchar2(1),             /*当前票况                               */
                                     /*目前票況                               */
                                     /* 1.未異動 2.託貼 3.質押 4.票貼         */
                                     /* 5.轉付   6:撤票 7:退票 8:兌現         */
nmh25       date,                    /*异动日期                               */
                                     /*異動日期                               */
nmh26       varchar2(24),            /*票据科目                               */
                                     /*票據科目                               */
nmh27       varchar2(24),            /*收票贷方科目                           */
                                     /*收票貸方科目                           */
nmh28       number(20,10),           /*最近异动汇率                           */
                                     /*最近異動匯率                           */
nmh29       varchar2(2),             /*票别二                                 */
                                     /*票別二                                 */
nmh30       varchar2(40),            /*客户简称                               */
                                     /*客戶簡稱                               */
nmh31       varchar2(20),            /*票号                                   */
                                     /*票號                                   */
nmh32       number(20,6),            /*收票本币金额                           */
                                     /*收票本幣金額                           */
nmh33       varchar2(20),            /*收票凭证编号                           */
                                     /*收票傳票編號                           */
nmh34       date,                    /*收票凭证日                             */
                                     /*收票傳票日                             */
nmh35       date,                    /*结案日期                               */
                                     /*結案日期                               */
nmh36       varchar2(12),            /*No Use                                 */
nmh37       date,                    /*No Use                                 */
nmh38       varchar2(1),             /*确认码                                 */
                                     /*確認碼(Y/N/X)                          */
                                     /*財務確認作業                           */
nmh39       number(20,10),           /*重估汇率                               */
nmh40       number(20,6),            /*本币未冲金额                           */
nmhuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
nmhgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
nmhmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
nmhdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
nmh261      varchar2(24),            /*票据科目二                             */
nmh271      varchar2(24),            /*收票贷方科目二                         */
nmhud01     varchar2(255),           /*自订字段-Textedit                      */
nmhud02     varchar2(40),            /*自订字段-文字                          */
nmhud03     varchar2(40),            /*自订字段-文字                          */
nmhud04     varchar2(40),            /*自订字段-文字                          */
nmhud05     varchar2(40),            /*自订字段-文字                          */
nmhud06     varchar2(40),            /*自订字段-文字                          */
nmhud07     number(15,3),            /*自订字段-数值                          */
nmhud08     number(15,3),            /*自订字段-数值                          */
nmhud09     number(15,3),            /*自订字段-数值                          */
nmhud10     number(10),              /*自订字段-整数                          */
nmhud11     number(10),              /*自订字段-整数                          */
nmhud12     number(10),              /*自订字段-整数                          */
nmhud13     date,                    /*自订字段-日期                          */
nmhud14     date,                    /*自订字段-日期                          */
nmhud15     date,                    /*自订字段-日期                          */
nmh41       varchar2(1) DEFAULT ' ' NOT NULL, /*暂收*/
nmhlegal    varchar2(10) NOT NULL,   /*所属法人                               */
nmhoriu     varchar2(10),            /*资料建立者                             */
nmhorig     varchar2(10),            /*资料建立部门                           */
nmh42       number(20,6) DEFAULT '0' NOT NULL /*转付金额*/
);

create        index nmh_06 on nmh_file (nmh33);
create        index nmh_04 on nmh_file (nmh05);
create        index nmh_03 on nmh_file (nmh04);
create        index nmh_02 on nmh_file (nmh31);
create        index nmh_05 on nmh_file (nmh09);
alter table nmh_file add  constraint nmh_pk primary key  (nmh01) enable validate;
grant select on nmh_file to tiptopgp;
grant update on nmh_file to tiptopgp;
grant delete on nmh_file to tiptopgp;
grant insert on nmh_file to tiptopgp;
grant index on nmh_file to public;
grant select on nmh_file to ods;
