/*
================================================================================
檔案代號:inb_file
檔案名稱:库存异动单据单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table inb_file
(
inb01       varchar2(20) NOT NULL,   /*单据编号                               */
                                     /*單據編號                               */
inb03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
inb04       varchar2(40),            /*料号                                   */
                                     /*料號                                   */
inb05       varchar2(10),            /*仓库                                   */
                                     /*倉庫                                   */
inb06       varchar2(10),            /*库位                                   */
                                     /*儲位                                   */
inb07       varchar2(24),            /*批号                                   */
                                     /*批號  No.+024                          */
inb08       varchar2(4),             /*单位                                   */
                                     /*單位                                   */
inb08_fac   number(20,8) NOT NULL,   /*异动/库存单位的换算率                  */
                                     /*異動/庫存單位的換算率 (To img09)       */
inb09       number(15,3) NOT NULL,   /*异动数量                               */
                                     /*異動數量                               */
inb10       varchar2(1),             /*检验否                                 */
inb11       varchar2(20),            /*来源单号                               */
                                     /*來源單號                               */
inb12       varchar2(20),            /*参考单号                               */
                                     /*參考單號                               */
inb13       number(20,6),            /*单价                                   */
                                     /*單價 (調入/借料/暫估)                  */
inb14       number(20,6),            /*金额                                   */
                                     /*金額                                   */
inb15       varchar2(10),            /*理由码                                 */
                                     /*異動原因                               */
inb901      varchar2(20),            /*手册编号                               */
inb902      varchar2(4),             /*单位一                                 */
inb903      number(20,8),            /*单位一换算率(与库存单位)               */
inb904      number(15,3),            /*单位一数量                             */
inb905      varchar2(4),             /*单位二                                 */
inb906      number(20,8),            /*单位二换算率(与库存单位)               */
inb907      number(15,3),            /*单位二数量                             */
inb908      number(5),               /*年度                                   */
inb909      number(5),               /*月份                                   */
inb910      varchar2(10),            /*成本中心                               */
inb1001     varchar2(10),            /*订价编号                               */
inb1002     varchar2(20),            /*提案编号                               */
inb1003     number(20,6),            /*单价(非成本)                           */
inb1004     varchar2(4),             /*计价单位                               */
inb1005     number(15,3),            /*计价数量                               */
inb1006     number(20,6),            /*金额                                   */
inb930      varchar2(10),            /*成本中心                               */
inb911      varchar2(20),            /*保税受托加工订单编号                   */
inb912      number(5),               /*保税受托加工订单项次                   */
inb41       varchar2(10),            /*项目编号                               */
inb42       varchar2(30),            /*WBS编码                                */
inb43       varchar2(4),             /*活动编号                               */
inbud01     varchar2(255),           /*自订字段-Textedit                      */
inbud02     varchar2(40),            /*自订字段-文字                          */
inbud03     varchar2(40),            /*自订字段-文字                          */
inbud04     varchar2(40),            /*自订字段-文字                          */
inbud05     varchar2(40),            /*自订字段-文字                          */
inbud06     varchar2(40),            /*自订字段-文字                          */
inbud07     number(15,3),            /*自订字段-数值                          */
inbud08     number(15,3),            /*自订字段-数值                          */
inbud09     number(15,3),            /*自订字段-数值                          */
inbud10     number(10),              /*自订字段-整数                          */
inbud11     number(10),              /*自订字段-整数                          */
inbud12     number(10),              /*自订字段-整数                          */
inbud13     date,                    /*自订字段-日期                          */
inbud14     date,                    /*自订字段-日期                          */
inbud15     date,                    /*自订字段-日期                          */
inb16       number(15,3),            /*申请数量                               */
inb922      varchar2(4),             /*申请单位一                             */
inb923      number(20,8),            /*申请单位一换算率                       */
inb924      number(15,3),            /*申请单位一数量                         */
inb925      varchar2(4),             /*申请单位二                             */
inb926      number(20,8),            /*申请单位二换算率                       */
inb927      number(15,3),            /*申请单位二数量                         */
inbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
inblegal    varchar2(10) NOT NULL,   /*所属法人                               */
inb132      number(20,6),            /*人工单价                               */
inb133      number(20,6),            /*制费一单价                             */
inb134      number(20,6),            /*加工单价                               */
inb135      number(20,6),            /*制费二单价                             */
inb136      number(20,6),            /*制费三单价                             */
inb137      number(20,6),            /*制费四单价                             */
inb138      number(20,6),            /*制费五单价                             */
inb46       varchar2(10),            /*QC判定结果编码                         */
inb47       number(5),               /*QC判定结果项次                         */
inb44       varchar2(20),            /*QC单号                                 */
inb45       number(5),               /*QC项次                                 */
inb48       number(5)                /*检验批号                               */
);

create        index inb_02 on inb_file (inb04);
alter table inb_file add  constraint inb_pk primary key  (inb01,inb03) enable validate;
grant select on inb_file to tiptopgp;
grant update on inb_file to tiptopgp;
grant delete on inb_file to tiptopgp;
grant insert on inb_file to tiptopgp;
grant index on inb_file to public;
grant select on inb_file to ods;
