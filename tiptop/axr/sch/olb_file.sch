/*
================================================================================
檔案代號:olb_file
檔案名稱:销售信用状单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table olb_file
(
olb01       varchar2(20) NOT NULL,   /*收状单号                               */
                                     /*收狀單號                               */
olb02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
olb03       varchar2(4),             /*单位                                   */
                                     /*單位                                   */
olb04       varchar2(20),            /*订单单号                               */
                                     /*訂單單號                               */
olb05       number(5),               /*订单项次                               */
                                     /*訂單項次                               */
olb06       number(20,6),            /*单价                                   */
                                     /*單價                                   */
olb07       number(15,3),            /*数量                                   */
                                     /*數量                                   */
olb08       number(20,6),            /*金额                                   */
                                     /*金額                                   */
olb09       number(15,3),            /*押汇数量                               */
                                     /*押匯數量                               */
olb10       number(20,6),            /*押汇金额                               */
                                     /*押匯金額                               */
olb11       varchar2(40),            /*料件编号                               */
                                     /*料件編號                               */
olb12       varchar2(1),             /*No Use                                 */
olb13       varchar2(1),             /*No Use                                 */
olb14       varchar2(1),             /*No Use                                 */
olb15       varchar2(1),             /*No Use                                 */
olb16       varchar2(1),             /*No Use                                 */
olb17       varchar2(1),             /*No Use                                 */
olb18       varchar2(1),             /*No Use                                 */
olb19       varchar2(1),             /*No Use                                 */
olb20       varchar2(1),             /*No Use                                 */
olb930      varchar2(10),            /*成本中心                               */
olbud01     varchar2(255),           /*自订字段-Textedit                      */
olbud02     varchar2(40),            /*自订字段-文字                          */
olbud03     varchar2(40),            /*自订字段-文字                          */
olbud04     varchar2(40),            /*自订字段-文字                          */
olbud05     varchar2(40),            /*自订字段-文字                          */
olbud06     varchar2(40),            /*自订字段-文字                          */
olbud07     number(15,3),            /*自订字段-数值                          */
olbud08     number(15,3),            /*自订字段-数值                          */
olbud09     number(15,3),            /*自订字段-数值                          */
olbud10     number(10),              /*自订字段-整数                          */
olbud11     number(10),              /*自订字段-整数                          */
olbud12     number(10),              /*自订字段-整数                          */
olbud13     date,                    /*自订字段-日期                          */
olbud14     date,                    /*自订字段-日期                          */
olbud15     date,                    /*自订字段-日期                          */
olblegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index olb_02 on olb_file (olb04,olb05);
alter table olb_file add  constraint olb_pk primary key  (olb01,olb02) enable validate;
grant select on olb_file to tiptopgp;
grant update on olb_file to tiptopgp;
grant delete on olb_file to tiptopgp;
grant insert on olb_file to tiptopgp;
grant index on olb_file to public;
grant select on olb_file to ods;
