/*
================================================================================
檔案代號:gxf_file
檔案名稱:定期存单资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table gxf_file
(
gxf011      varchar2(20) NOT NULL,   /*申请号码                               */
                                     /*申請號碼                               */
gxf01       varchar2(20),            /*存单号码                               */
                                     /*存單號碼                               */
gxf02       varchar2(20),            /*定存银行                               */
                                     /*定存銀行                               */
gxf021      number(20,6),            /*定存金额                               */
                                     /*定存金額                               */
gxf03       date,                    /*原存日期                               */
gxf04       number(5),               /*计息方式                               */
                                     /*計息方式                               */
                                     /*1.月付                                 */
                                     /*2.到期整付                             */
gxf05       date,                    /*到期日                                 */
gxf06       number(20,6) DEFAULT '0' NOT NULL, /*利率*/
                                     /*利率 No.7952          #No:7354         */
gxf07       varchar2(2),             /*核算项                                 */
gxf08       varchar2(10),            /*质押对象                               */
                                     /*質押對象                               */
gxf09       number(20,6),            /*质押金额                               */
                                     /*質押金額                               */
gxf10       varchar2(80),            /*质押性质                               */
                                     /*質押性質                               */
gxf11       number(5),               /*存单状态                               */
                                     /*存單狀態                               */
                                     /*0:存入                                 */
                                     /*1:質押                                 */
                                     /*2:解除質押                             */
                                     /*3:解約                                 */
                                     /*4:到期                                 */
gxf12       varchar2(80),            /*摘要                                   */
gxf13       varchar2(20),            /*存入凭证编号                           */
                                     /*存入傳票編號                           */
gxf14       date,                    /*存入凭证日期                           */
                                     /*存入傳票日期                           */
gxf15       varchar2(20),            /*解约凭证编号                           */
                                     /*解約傳票編號                           */
gxf16       date,                    /*解约凭证日期                           */
                                     /*解約傳票日期                           */
gxf17       varchar2(20),            /*质押凭证编号                           */
                                     /*質押傳票編號                           */
gxf18       date,                    /*质押凭证日期                           */
                                     /*質押傳票日期                           */
gxf19       varchar2(20),            /*解除质押凭证编号                       */
                                     /*解除質押傳票編號                       */
gxf20       date,                    /*解除质押凭证日期                       */
                                     /*解除質押傳票日期                       */
gxf21       date,                    /*质押日期                               */
                                     /*質押日期                               */
gxf22       date,                    /*解除质押日期                           */
                                     /*解除質押日期                           */
gxf23       date,                    /*解约日期                               */
                                     /*解約日期                               */
gxf24       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
gxf25       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
gxf26       number(20,6),            /*本币金额                               */
                                     /*本幣金額                               */
gxf27       number(20,6),            /*到期收款原币金额                       */
                                     /*到期收款原幣金額                       */
gxf28       number(20,6),            /*到期收款本币金额                       */
                                     /*到期收款本幣金額                       */
gxf29       varchar2(20),            /*到期凭证                               */
                                     /*到期傳票                               */
gxf30       date,                    /*到期凭证日期                           */
                                     /*到期傳票日期                           */
gxf31       varchar2(24),            /*贷方科目                               */
                                     /*貸方科目(#02/12/03不使用,改用nma05)    */
gxf32       varchar2(20),            /*存出银行                               */
                                     /*存出銀行                   #02/12/03add*/
gxf33f      number(20,6),            /*提出原币金额                           */
                                     /*存出原币金额               #02/12/03add*/
gxf33       number(20,6),            /*提出本币金额                           */
                                     /*存出本币金额Noentry Default gxf26 #add */
gxf34       varchar2(2),             /*核算项                                 */
                                     /*異動碼                     #02/12/03add*/
gxf35       varchar2(4),             /*币种                                   */
                                     /*幣別                       #02/12/03add*/
gxf36       number(20,10),           /*汇率                                   */
                                     /*匯率                       #02/12/03add*/
gxf37       varchar2(80),            /*摘要                                   */
                                     /*摘要                       #02/12/03add*/
gxf38       varchar2(1),             /*状况                                   */
                                     /*Status'1' Time Deposit  '2' Extend  #02/12/03add*/
gxf39       varchar2(20),            /*原申请号码                             */
                                     /*Old Apply #(Use Record When Status Is Extend)  #add*/
gxf40       varchar2(20),            /*收款单号                               */
                                     /*Receipt No.  (Use Record When Status Is Extend)  #add*/
gxfconf     varchar2(1),             /*确认码                                 */
                                     /*確認碼(Y/N)                            */
gxfuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護。                             */
gxfgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護。                             */
gxfmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護。                             */
gxfdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
                                     /*系統維護。                             */
gxfacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護。                             */
gxf41       varchar2(1),             /*开帐否                                 */
gxfud01     varchar2(255),           /*自订字段-Textedit                      */
gxfud02     varchar2(40),            /*自订字段-文字                          */
gxfud03     varchar2(40),            /*自订字段-文字                          */
gxfud04     varchar2(40),            /*自订字段-文字                          */
gxfud05     varchar2(40),            /*自订字段-文字                          */
gxfud06     varchar2(40),            /*自订字段-文字                          */
gxfud07     number(15,3),            /*自订字段-数值                          */
gxfud08     number(15,3),            /*自订字段-数值                          */
gxfud09     number(15,3),            /*自订字段-数值                          */
gxfud10     number(10),              /*自订字段-整数                          */
gxfud11     number(10),              /*自订字段-整数                          */
gxfud12     number(10),              /*自订字段-整数                          */
gxfud13     date,                    /*自订字段-日期                          */
gxfud14     date,                    /*自订字段-日期                          */
gxfud15     date,                    /*自订字段-日期                          */
gxflegal    varchar2(10) NOT NULL,   /*所属法人                               */
gxforiu     varchar2(10),            /*资料建立者                             */
gxforig     varchar2(10)             /*资料建立部门                           */
);

create        index gxf_03 on gxf_file (gxf15);
create        index gxf_02 on gxf_file (gxf13);
create        index gxf_06 on gxf_file (gxf29);
create        index gxf_05 on gxf_file (gxf19);
create        index gxf_04 on gxf_file (gxf17);
alter table gxf_file add  constraint gxf_pk primary key  (gxf011) enable validate;
grant select on gxf_file to tiptopgp;
grant update on gxf_file to tiptopgp;
grant delete on gxf_file to tiptopgp;
grant insert on gxf_file to tiptopgp;
grant index on gxf_file to public;
grant select on gxf_file to ods;
