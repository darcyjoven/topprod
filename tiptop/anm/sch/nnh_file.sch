/*
================================================================================
檔案代號:nnh_file
檔案名稱:中长期贷款申请资料档单身
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nnh_file
(
nnh01       varchar2(20) NOT NULL,   /*合约编号                               */
                                     /*合約編號                               */
nnh02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
nnh03       date,                    /*到期日                                 */
nnh04f      number(20,6),            /*原币票面金额                           */
                                     /*原幣票面金額                           */
nnh04       number(20,6),            /*本币票面金额                           */
                                     /*本幣票面金額                           */
nnh05       varchar2(20),            /*付款银行                               */
                                     /*付款銀行                               */
nnh06       varchar2(20),            /*N/P 单号                               */
                                     /*N/P 單號                               */
nnh07       varchar2(1),             /*开票否                                 */
                                     /*開票否(Y:開票 N:未開票)     #03/01/20add*/
nnhud01     varchar2(255),           /*自订字段-Textedit                      */
nnhud02     varchar2(40),            /*自订字段-文字                          */
nnhud03     varchar2(40),            /*自订字段-文字                          */
nnhud04     varchar2(40),            /*自订字段-文字                          */
nnhud05     varchar2(40),            /*自订字段-文字                          */
nnhud06     varchar2(40),            /*自订字段-文字                          */
nnhud07     number(15,3),            /*自订字段-数值                          */
nnhud08     number(15,3),            /*自订字段-数值                          */
nnhud09     number(15,3),            /*自订字段-数值                          */
nnhud10     number(10),              /*自订字段-整数                          */
nnhud11     number(10),              /*自订字段-整数                          */
nnhud12     number(10),              /*自订字段-整数                          */
nnhud13     date,                    /*自订字段-日期                          */
nnhud14     date,                    /*自订字段-日期                          */
nnhud15     date,                    /*自订字段-日期                          */
nnhlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table nnh_file add  constraint nnh_pk primary key  (nnh01,nnh02) enable validate;
grant select on nnh_file to tiptopgp;
grant update on nnh_file to tiptopgp;
grant delete on nnh_file to tiptopgp;
grant insert on nnh_file to tiptopgp;
grant index on nnh_file to public;
grant select on nnh_file to ods;
