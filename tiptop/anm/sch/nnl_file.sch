/*
================================================================================
檔案代號:nnl_file
檔案名稱:信贷还本付款单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nnl_file
(
nnl01       varchar2(20) NOT NULL,   /*付款单号                               */
                                     /*付款單號                               */
nnl02       number(5) NOT NULL,      /*序号                                   */
                                     /*序號                                   */
nnl03       varchar2(1),             /*1.融资 2.中长贷合约                    */
                                     /*1.融資 2.中長貸合約                    */
nnl04       varchar2(20),            /*融资/合约号码                          */
                                     /*融資/合約號碼                          */
nnl11       number(20,6),            /*应还原币                               */
                                     /*應還原幣                               */
nnl12       number(20,6),            /*实付原币                               */
                                     /*實付原幣                               */
nnl13       number(20,6),            /*应还本币                               */
                                     /*應還本幣                               */
nnl14       number(20,6),            /*实付本币                               */
                                     /*實付本幣                               */
nnl15       number(20,6),            /*应付利息原币                           */
                                     /*應付利息原幣                           */
nnl16       number(20,6),            /*汇差损失                               */
                                     /*匯差損失                               */
nnl17       number(20,6),            /*应付利息本币                           */
                                     /*應付利息本幣                           */
nnl18       number(20,10),           /*额度汇率                               */
                                     /*額度匯率(轉換信貸額度)                 */
nnl19       varchar2(1),             /*No Use                                 */
nnl20       varchar2(1),             /*No Use                                 */
nnlud01     varchar2(255),           /*自订字段-Textedit                      */
nnlud02     varchar2(40),            /*自订字段-文字                          */
nnlud03     varchar2(40),            /*自订字段-文字                          */
nnlud04     varchar2(40),            /*自订字段-文字                          */
nnlud05     varchar2(40),            /*自订字段-文字                          */
nnlud06     varchar2(40),            /*自订字段-文字                          */
nnlud07     number(15,3),            /*自订字段-数值                          */
nnlud08     number(15,3),            /*自订字段-数值                          */
nnlud09     number(15,3),            /*自订字段-数值                          */
nnlud10     number(10),              /*自订字段-整数                          */
nnlud11     number(10),              /*自订字段-整数                          */
nnlud12     number(10),              /*自订字段-整数                          */
nnlud13     date,                    /*自订字段-日期                          */
nnlud14     date,                    /*自订字段-日期                          */
nnlud15     date,                    /*自订字段-日期                          */
nnllegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index nnl_02 on nnl_file (nnl03);
alter table nnl_file add  constraint nnl_pk primary key  (nnl01,nnl02) enable validate;
grant select on nnl_file to tiptopgp;
grant update on nnl_file to tiptopgp;
grant delete on nnl_file to tiptopgp;
grant insert on nnl_file to tiptopgp;
grant index on nnl_file to public;
grant select on nnl_file to ods;
