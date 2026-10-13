/*
================================================================================
檔案代號:nnm_file
檔案名稱:利息暂估资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nnm_file
(
nnm01       varchar2(20) NOT NULL,   /*融资单号/合约编号                      */
                                     /*融資單號/合約編號                      */
nnm02       number(5) NOT NULL,      /*年度                                   */
nnm03       number(5) NOT NULL,      /*月份                                   */
nnm04       varchar2(1),             /*1.融资 2.合约                          */
                                     /*1.融資 2.合約                          */
nnm05       date,                    /*起算日期                               */
nnm06       date,                    /*止算日期                               */
nnm07       number(10),              /*天数                                   */
                                     /*天數                                   */
nnm08       number(20,6) DEFAULT '0' NOT NULL, /*利率*/
nnm09       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
nnm10       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
nnm11       number(20,6),            /*暂估原币                               */
                                     /*暫估原幣       02/11/26 alter          */
nnm12       number(20,6),            /*暂估本币                               */
                                     /*暫估本幣       02/11/26 alter          */
nnm13       varchar2(20),            /*还息付款单号                           */
                                     /*還息付款單號                           */
nnm14       varchar2(20),            /*信贷银行                               */
                                     /*信貸銀行                               */
nnm15       varchar2(1),             /*利息暂估类型                           */
                                     /*利息暫估類別    add in 99/05/29        */
                                     /*1.短期  2.中長貸                       */
nnm16       varchar2(1),             /*'1' 本票折价(CP,银行承兑汇票)          */
nnm17       number(20,6),            /*暂估费用                               */
                                     /*暫估費用    02/11/26 alter             */
nnmglno     varchar2(20),            /*凭证编号                               */
                                     /*傳票編號                               */
nnmconf     varchar2(1),             /*确认码                                 */
                                     /*確認碼                          #No:8989*/
nnmuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
nnmgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
nnmmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
nnmdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
nnmud01     varchar2(255),           /*自订字段-Textedit                      */
nnmud02     varchar2(40),            /*自订字段-文字                          */
nnmud03     varchar2(40),            /*自订字段-文字                          */
nnmud04     varchar2(40),            /*自订字段-文字                          */
nnmud05     varchar2(40),            /*自订字段-文字                          */
nnmud06     varchar2(40),            /*自订字段-文字                          */
nnmud07     number(15,3),            /*自订字段-数值                          */
nnmud08     number(15,3),            /*自订字段-数值                          */
nnmud09     number(15,3),            /*自订字段-数值                          */
nnmud10     number(10),              /*自订字段-整数                          */
nnmud11     number(10),              /*自订字段-整数                          */
nnmud12     number(10),              /*自订字段-整数                          */
nnmud13     date,                    /*自订字段-日期                          */
nnmud14     date,                    /*自订字段-日期                          */
nnmud15     date,                    /*自订字段-日期                          */
nnmlegal    varchar2(10) NOT NULL,   /*所属法人                               */
nnmoriu     varchar2(10),            /*资料建立者                             */
nnmorig     varchar2(10)             /*资料建立部门                           */
);

create        index nnm_02 on nnm_file (nnmglno);
alter table nnm_file add  constraint nnm_pk primary key  (nnm01,nnm02,nnm03) enable validate;
grant select on nnm_file to tiptopgp;
grant update on nnm_file to tiptopgp;
grant delete on nnm_file to tiptopgp;
grant insert on nnm_file to tiptopgp;
grant index on nnm_file to public;
grant select on nnm_file to ods;
