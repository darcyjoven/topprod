/*
================================================================================
檔案代號:ale_file
檔案名稱:到货料件单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ale_file
(
ale01       varchar2(20) NOT NULL,   /*到货单号                               */
                                     /*到貨單號                               */
ale02       number(5) NOT NULL,      /*序号                                   */
                                     /*序號                                   */
ale03       varchar2(20),            /*预购单号                               */
                                     /*預購單號(No use)                 (11/11)*/
ale04       number(5),               /*预购项次                               */
                                     /*預購項次(No use)                 (11/11)*/
ale05       number(20,6),            /*单价                                   */
                                     /*單價                                   */
ale06       number(15,3),            /*到货数量                               */
                                     /*到貨數量                               */
ale07       number(20,6),            /*金额                                   */
                                     /*金額                                   */
ale08       number(20,6),            /*分摊后单价                             */
                                     /*分攤後單價                             */
ale09       number(20,6),            /*分摊后金额                             */
                                     /*分攤後金額                             */
ale11       varchar2(40),            /*料号                                   */
                                     /*料號                                   */
ale13       varchar2(24),            /*会计科目                               */
                                     /*會計科目                         (11/11)*/
ale14       varchar2(20),            /*采购单号                               */
                                     /*採購單號                               */
ale15       number(5),               /*采购项次                               */
                                     /*採購項次                               */
ale16       varchar2(20),            /*入库单号                               */
                                     /*入庫單號                               */
ale17       number(5),               /*入库项次                               */
                                     /*入庫項次                               */
ale18       varchar2(1),             /*No Use                                 */
ale19       varchar2(1),             /*No Use                                 */
ale20       varchar2(1),             /*No Use                                 */
ale930      varchar2(10),            /*成本中心                               */
ale131      varchar2(24),            /*会计科目二                             */
ale80       varchar2(4),             /*单位一                                 */
ale81       number(20,8),            /*单位一换算率                           */
ale82       number(15,3),            /*单位一数量                             */
ale83       varchar2(4),             /*单位二                                 */
ale84       number(20,8),            /*单位二换算率(与库存单位)               */
ale85       number(15,3),            /*单位二数量                             */
ale86       varchar2(4),             /*计价单位                               */
ale87       number(15,3),            /*计价数量                               */
aleud01     varchar2(255),           /*自订字段-Textedit                      */
aleud02     varchar2(40),            /*自订字段-文字                          */
aleud03     varchar2(40),            /*自订字段-文字                          */
aleud04     varchar2(40),            /*自订字段-文字                          */
aleud05     varchar2(40),            /*自订字段-文字                          */
aleud06     varchar2(40),            /*自订字段-文字                          */
aleud07     number(15,3),            /*自订字段-数值                          */
aleud08     number(15,3),            /*自订字段-数值                          */
aleud09     number(15,3),            /*自订字段-数值                          */
aleud10     number(10),              /*自订字段-整数                          */
aleud11     number(10),              /*自订字段-整数                          */
aleud12     number(10),              /*自订字段-整数                          */
aleud13     date,                    /*自订字段-日期                          */
aleud14     date,                    /*自订字段-日期                          */
aleud15     date,                    /*自订字段-日期                          */
alelegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index ale_03 on ale_file (ale16);
create        index ale_02 on ale_file (ale03,ale04);
alter table ale_file add  constraint ale_pk primary key  (ale01,ale02) enable validate;
grant select on ale_file to tiptopgp;
grant update on ale_file to tiptopgp;
grant delete on ale_file to tiptopgp;
grant insert on ale_file to tiptopgp;
grant index on ale_file to public;
grant select on ale_file to ods;
