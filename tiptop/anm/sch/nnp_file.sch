/*
================================================================================
檔案代號:nnp_file
檔案名稱:合约借款额度单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nnp_file
(
nnp01       varchar2(10) NOT NULL,   /*合约号码                               */
                                     /*合約號碼                               */
nnp02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
nnp03       varchar2(10),            /*融资种类                               */
                                     /*融資種類                               */
nnp04       varchar2(1),             /*综合                                   */
                                     /*綜合                                   */
nnp05       number(20,6) DEFAULT '0' NOT NULL, /*利率*/
                                     /*利率              #No:7354             */
nnp06       number(9,4),             /*费率                                   */
                                     /*費率                                   */
nnp07       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
nnp08       number(20,10),           /*额汇                                   */
                                     /*額匯 No.B254 原為匯率010430改成額匯    */
nnp09       number(20,6),            /*授信额度                               */
                                     /*授信額度                               */
nnp10       varchar2(1),             /*No Use                                 */
nnp11       varchar2(1),             /*No Use                                 */
nnp12       varchar2(1),             /*No Use                                 */
nnp13       varchar2(1),             /*No Use                                 */
nnpud01     varchar2(255),           /*自订字段-Textedit                      */
nnpud02     varchar2(40),            /*自订字段-文字                          */
nnpud03     varchar2(40),            /*自订字段-文字                          */
nnpud04     varchar2(40),            /*自订字段-文字                          */
nnpud05     varchar2(40),            /*自订字段-文字                          */
nnpud06     varchar2(40),            /*自订字段-文字                          */
nnpud07     number(15,3),            /*自订字段-数值                          */
nnpud08     number(15,3),            /*自订字段-数值                          */
nnpud09     number(15,3),            /*自订字段-数值                          */
nnpud10     number(10),              /*自订字段-整数                          */
nnpud11     number(10),              /*自订字段-整数                          */
nnpud12     number(10),              /*自订字段-整数                          */
nnpud13     date,                    /*自订字段-日期                          */
nnpud14     date,                    /*自订字段-日期                          */
nnpud15     date                     /*自订字段-日期                          */
);

alter table nnp_file add  constraint nnp_pk primary key  (nnp01,nnp02) enable validate;
grant select on nnp_file to tiptopgp;
grant update on nnp_file to tiptopgp;
grant delete on nnp_file to tiptopgp;
grant insert on nnp_file to tiptopgp;
grant index on nnp_file to public;
grant select on nnp_file to ods;
