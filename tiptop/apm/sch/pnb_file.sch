/*
================================================================================
檔案代號:pnb_file
檔案名稱:采购变更单身头
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pnb_file
(
pnb01       varchar2(20) NOT NULL,   /*采购单号                               */
                                     /*採購單號                               */
pnb02       number(5) NOT NULL,      /*变更序号                               */
                                     /*變更序號                               */
pnb03       number(5) NOT NULL,      /*采购单项次                             */
                                     /*採購單項次                             */
pnb04b      varchar2(40),            /*变更前料号                             */
                                     /*變更前料號                             */
pnb041b     varchar2(120),           /*变更前品名规格                         */
                                     /*變更前品名規格                         */
pnb07b      varchar2(4),             /*变更前采购单位                         */
                                     /*變更前採購單位                         */
pnb20b      number(15,3),            /*变更前订购量                           */
                                     /*變更前訂購量                           */
pnb31b      number(20,6),            /*变更前税前单价                         */
                                     /*變更前單價                             */
pnb33b      date,                    /*变更前原始交货日期                     */
                                     /*變更前原始交貨日期                     */
pnb04a      varchar2(40),            /*变更后料号                             */
                                     /*變更後料號                             */
pnb041a     varchar2(120),           /*变更后品名规格                         */
                                     /*變更後品名規格                         */
pnb07a      varchar2(4),             /*变更后采购单位                         */
                                     /*變更後採購單位                         */
pnb20a      number(15,3),            /*变更后订购量                           */
                                     /*變更後訂購量                           */
pnb31a      number(20,6),            /*变更后税前单价                         */
                                     /*變更後單價                             */
pnb33a      date,                    /*变更后原始交货日期                     */
                                     /*變更後原始交貨日期                     */
pnb50       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
pnb51       varchar2(1),             /*No Use                                 */
pnb32a      number(20,6),            /*变更后含税单价                         */
pnb32b      number(20,6),            /*变更前含税单价                         */
pnb80b      varchar2(4),             /*变更前单位一                           */
pnb81b      number(20,8),            /*变更前单位一换算率(与采购单            */
pnb82b      number(15,3),            /*变更前单位一数量                       */
pnb83b      varchar2(4),             /*变更前单位二                           */
pnb84b      number(20,8),            /*变更前单位二换算率(与采购单            */
pnb85b      number(15,3),            /*变更前单位二数量                       */
pnb86b      varchar2(4),             /*变更前计价单位                         */
pnb87b      number(15,3),            /*变更前计价数量                         */
pnb80a      varchar2(4),             /*变更后单位一                           */
pnb81a      number(20,8),            /*变更后单位一换算率(与采购单            */
pnb82a      number(15,3),            /*变更后单位一数量                       */
pnb83a      varchar2(4),             /*变更后单位二                           */
pnb84a      number(20,8),            /*变更后单位二换算率(与采购单            */
pnb85a      number(15,3),            /*变更后单位二数量                       */
pnb86a      varchar2(4),             /*变更后计价单位                         */
pnb87a      number(15,3),            /*变更后计价数量                         */
pnb90       varchar2(20),            /*请购单号                               */
pnb91       number(5),               /*请购单项次                             */
pnbud01     varchar2(255),           /*自订字段-Textedit                      */
pnbud02     varchar2(40),            /*自订字段-文字                          */
pnbud03     varchar2(40),            /*自订字段-文字                          */
pnbud04     varchar2(40),            /*自订字段-文字                          */
pnbud05     varchar2(40),            /*自订字段-文字                          */
pnbud06     varchar2(40),            /*自订字段-文字                          */
pnbud07     number(15,3),            /*自订字段-数值                          */
pnbud08     number(15,3),            /*自订字段-数值                          */
pnbud09     number(15,3),            /*自订字段-数值                          */
pnbud10     number(10),              /*自订字段-整数                          */
pnbud11     number(10),              /*自订字段-整数                          */
pnbud12     number(10),              /*自订字段-整数                          */
pnbud13     date,                    /*自订字段-日期                          */
pnbud14     date,                    /*自订字段-日期                          */
pnbud15     date,                    /*自订字段-日期                          */
pnbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pnblegal    varchar2(10) NOT NULL,   /*所属法人                               */
pnb34a      varchar2(10),            /*变更后项目编号                         */
pnb34b      varchar2(10),            /*變更前專案代號                         */
pnb35a      varchar2(30),            /*变更后WBS编码                          */
pnb35b      varchar2(30),            /*變更前WBS編碼                          */
pnb36a      varchar2(4),             /*变更后活动编号                         */
pnb36b      varchar2(4)              /*變更前活動代號                         */
);

alter table pnb_file add  constraint pnb_pk primary key  (pnb01,pnb02,pnb03) enable validate;
grant select on pnb_file to tiptopgp;
grant update on pnb_file to tiptopgp;
grant delete on pnb_file to tiptopgp;
grant insert on pnb_file to tiptopgp;
grant index on pnb_file to public;
grant select on pnb_file to ods;
