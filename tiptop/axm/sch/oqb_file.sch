/*
================================================================================
檔案代號:oqb_file
檔案名稱:估价单单身资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oqb_file
(
oqb01       varchar2(20) NOT NULL,   /*估价单号                               */
                                     /*估價單號                               */
oqb02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
oqb03       varchar2(40),            /*产品编号                               */
                                     /*產品編號                               */
oqb031      varchar2(120),           /*品名                                   */
oqb032      varchar2(120),           /*规格                                   */
                                     /*規格                                   */
oqb04       varchar2(4),             /*单位                                   */
                                     /*單位                                   */
oqb05       number(15,3),            /*数量                                   */
                                     /*數量                                   */
oqb06       varchar2(1),             /*客户供料                               */
                                     /*客戶供料(Y/N)                          */
oqb07       varchar2(4),             /*原币币种                               */
                                     /*原幣幣別                               */
oqb08       number(20,10),           /*汇率                                   */
                                     /*匯率(原幣幣別對估價幣別之相對匯率)     */
oqb09       number(20,6),            /*单价                                   */
                                     /*單價(原幣單價)                         */
oqb10       number(20,6),            /*估价单价                               */
                                     /*估價單價(換算成估價幣別之單價)         */
oqb11       number(20,6),            /*估价金额                               */
                                     /*估價金額                               */
oqb12       varchar2(20),            /*参考单据                               */
                                     /*參考單據(採購單號)                     */
oqb13       date,                    /*参考日期                               */
                                     /*參考日期(採購日期)                     */
oqbud01     varchar2(255),           /*自订字段-Textedit                      */
oqbud02     varchar2(40),            /*自订字段-文字                          */
oqbud03     varchar2(40),            /*自订字段-文字                          */
oqbud04     varchar2(40),            /*自订字段-文字                          */
oqbud05     varchar2(40),            /*自订字段-文字                          */
oqbud06     varchar2(40),            /*自订字段-文字                          */
oqbud07     number(15,3),            /*自订字段-数值                          */
oqbud08     number(15,3),            /*自订字段-数值                          */
oqbud09     number(15,3),            /*自订字段-数值                          */
oqbud10     number(10),              /*自订字段-整数                          */
oqbud11     number(10),              /*自订字段-整数                          */
oqbud12     number(10),              /*自订字段-整数                          */
oqbud13     date,                    /*自订字段-日期                          */
oqbud14     date,                    /*自订字段-日期                          */
oqbud15     date,                    /*自订字段-日期                          */
oqbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oqblegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table oqb_file add  constraint oqb_pk primary key  (oqb01,oqb02) enable validate;
grant select on oqb_file to tiptopgp;
grant update on oqb_file to tiptopgp;
grant delete on oqb_file to tiptopgp;
grant insert on oqb_file to tiptopgp;
grant index on oqb_file to public;
grant select on oqb_file to ods;
