/*
================================================================================
檔案代號:imn_file
檔案名稱:库存调拨单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table imn_file
(
imn01       varchar2(20) NOT NULL,   /*调拨单号                               */
                                     /*調撥單號                               */
imn02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
imn03       varchar2(40),            /*料号                                   */
                                     /*料號                                   */
                                     /*------------來源------------------------*/
imn041      varchar2(10),            /*拨出营运中心编号                       */
                                     /*撥出工廠別                             */
                                     /*若為二階段調撥其調出工廠等於調入工廠   */
imn04       varchar2(10),            /*拨出仓库                               */
                                     /*撥出倉庫別                             */
imn05       varchar2(10),            /*拨出库位                               */
                                     /*撥出儲位                               */
imn06       varchar2(24),            /*拨出批号                               */
                                     /*撥出批號                               */
imn07       varchar2(24),            /*会计科目                               */
                                     /*會計科目                               */
imn08       varchar2(10),            /*项目号码                               */
                                     /*專案號碼                               */
imn09       varchar2(4),             /*库存单位                               */
                                     /*庫存單位                               */
imn091      number(20,6),            /*单价                                   */
                                     /*單價                                   */
imn092      number(20,6),            /*金额                                   */
                                     /*金額                                   */
imn10       number(15,3),            /*拨出数量(预计)                         */
                                     /*撥出數量(預計)                         */
imn11       number(15,3),            /*累计实拨数量(实际)/异动后库            */
                                     /*Accu.Actl.Trs.Q(Actl)/Inv.Q af Tran(1-Step*/
imn12       varchar2(1),             /*确认码                                 */
                                     /*確認碼                                 */
                                     /*二階段調撥適用                         */
imn13       varchar2(10),            /*审核人                                 */
                                     /*確認人                                 */
                                     /*二階段調撥適用                         */
imn14       date,                    /*审核日期                               */
                                     /*確認日期 (出)                          */
                                     /*二階段調撥適用                         */
                                     /*------------目的------------------------*/
imn151      varchar2(10),            /*拨入营运中心编号                       */
                                     /*撥入工廠別                             */
                                     /*若為二階段調撥其調出工廠等於調入工廠   */
imn15       varchar2(10),            /*拨入仓库                               */
                                     /*撥入倉庫別                             */
imn16       varchar2(10),            /*拨入库位                               */
                                     /*撥入儲位                               */
imn17       varchar2(24),            /*拨入批号                               */
                                     /*撥入批號                               */
imn18       varchar2(24),            /*会计科目                               */
                                     /*會計科目                               */
imn19       varchar2(10),            /*项目号码                               */
                                     /*專案號碼                               */
imn20       varchar2(4),             /*库存单位                               */
                                     /*庫存單位                               */
imn201      varchar2(10),            /*库存等级                               */
                                     /*庫存等級                               */
imn202      varchar2(4),             /*外观编号                               */
                                     /*外觀代號                               */
imn21       number(20,8),            /*单位转换率                             */
                                     /*單位轉換率(撥出/撥入)                  */
imn22       number(15,3),            /*转换后数量                             */
                                     /*轉換後數量(撥出數量* imn21 )           */
imn23       number(15,3),            /*累计实拨数量(实际)/异动后库            */
                                     /*Accu.Actl.Trs.Q(Actl)/Inv.Q af Tran(1-Step*/
imn24       varchar2(1),             /*确认码                                 */
                                     /*確認碼                                 */
                                     /*二階段調撥適用                         */
imn25       varchar2(10),            /*审核人                                 */
                                     /*確認人                                 */
                                     /*二階段調撥適用                         */
imn26       date,                    /*审核日期                               */
                                     /*確認日期(入)                           */
                                     /*二階段調撥適用                         */
imn27       varchar2(1),             /*结案否                                 */
                                     /*結案否(Y/N)                            */
imn28       varchar2(10),            /*调拨理由                               */
                                     /*調撥理由                               */
imn30       varchar2(4),             /*单位一 (来源)                          */
imn31       number(20,8),            /*单位一换算率(与库存单位)(来            */
imn32       number(15,3),            /*单位一数量(来源)                       */
imn33       varchar2(4),             /*单位二(来源)                           */
imn34       number(20,8),            /*单位二换算率(与库存单位)(来            */
imn35       number(15,3),            /*单位二数量(来源)                       */
imn40       varchar2(4),             /*单位一(目的)                           */
imn41       number(20,8),            /*单位一换算率(与库存单位)(目            */
imn42       number(15,3),            /*单位一数量(目的)                       */
imn43       varchar2(4),             /*单位二(目的)                           */
imn44       number(20,8),            /*单位二换算率(与库存单位)(目            */
imn45       number(15,3),            /*单位二数量(目的)                       */
imn51       number(20,8),            /*来源单位一与目的单位一的转             */
imn52       number(20,8),            /*来源单位二与目的单位二的转             */
imn29       varchar2(1),             /*检验否                                 */
imn9301     varchar2(10),            /*拨出成本中心                           */
imn9302     varchar2(10),            /*拨入成本中心                           */
imnud01     varchar2(255),           /*自订字段-Textedit                      */
imnud02     varchar2(40),            /*自订字段-文字                          */
imnud03     varchar2(40),            /*自订字段-文字                          */
imnud04     varchar2(40),            /*自订字段-文字                          */
imnud05     varchar2(40),            /*自订字段-文字                          */
imnud06     varchar2(40),            /*自订字段-文字                          */
imnud07     number(15,3),            /*自订字段-数值                          */
imnud08     number(15,3),            /*自订字段-数值                          */
imnud09     number(15,3),            /*自订字段-数值                          */
imnud10     number(10),              /*自订字段-整数                          */
imnud11     number(10),              /*自订字段-整数                          */
imnud12     number(10),              /*自订字段-整数                          */
imnud13     date,                    /*自订字段-日期                          */
imnud14     date,                    /*自订字段-日期                          */
imnud15     date,                    /*自订字段-日期                          */
imnplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
imnlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table imn_file add  constraint imn_pk primary key  (imn01,imn02) enable validate;
grant select on imn_file to tiptopgp;
grant update on imn_file to tiptopgp;
grant delete on imn_file to tiptopgp;
grant insert on imn_file to tiptopgp;
grant index on imn_file to public;
grant select on imn_file to ods;
