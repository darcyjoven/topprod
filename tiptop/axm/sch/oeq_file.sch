/*
================================================================================
檔案代號:oeq_file
檔案名稱:订单变更单单身
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oeq_file
(
oeq01       varchar2(20) NOT NULL,   /*订单单号                               */
                                     /*訂單單號                               */
oeq02       number(5) NOT NULL,      /*变更序号                               */
                                     /*變更序號                               */
oeq03       number(5) NOT NULL,      /*订单项次                               */
                                     /*訂單項次                               */
oeq04b      varchar2(40),            /*变更前料号                             */
                                     /*變更前料號                             */
oeq041b     varchar2(120),           /*变更前品名规格                         */
                                     /*變更前品名規格                         */
oeq05b      varchar2(4),             /*变更前订单单位                         */
                                     /*變更前訂單單位                         */
oeq12b      number(15,3),            /*变更前数量                             */
                                     /*變更前數量                             */
oeq13b      number(20,6),            /*变更前单价                             */
                                     /*變更前單價                             */
oeq14b      number(20,6),            /*变更前税前金额                         */
                                     /*變更前未稅金額                         */
oeq14tb     number(20,6),            /*变更前含税金额                         */
                                     /*變更前含稅金額                         */
oeq15b      date,                    /*变更前原始交货日期                     */
                                     /*變更前原始交貨日期                     */
oeq04a      varchar2(40),            /*变更后料号                             */
                                     /*變更後料號                             */
oeq041a     varchar2(120),           /*变更后品名规格                         */
                                     /*變更後品名規格                         */
oeq05a      varchar2(4),             /*变更后订单单位                         */
                                     /*變更後訂單單位                         */
oeq12a      number(15,3),            /*变更后订购量                           */
                                     /*變更後訂購量                           */
oeq13a      number(20,6),            /*变更后单价                             */
                                     /*變更後單價                             */
oeq14a      number(20,6),            /*变更后税前金额                         */
                                     /*變更後未稅金額                         */
oeq14ta     number(20,6),            /*变更后含税金额                         */
                                     /*變更後含稅金額                         */
oeq15a      date,                    /*变更后原始交货日期                     */
                                     /*變更後原始交貨日期                     */
oeq50       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
oeq20b      varchar2(4),             /*变更前单位一                           */
oeq21b      number(20,8),            /*变更前单位一转换率(与销售单            */
oeq22b      number(15,3),            /*变更前单位一数量                       */
oeq23b      varchar2(4),             /*变更前单位二                           */
oeq24b      number(20,8),            /*变更前单位二转换率(与销售单            */
oeq25b      number(15,3),            /*变更前单位二数量                       */
oeq26b      varchar2(4),             /*变更前计价单位                         */
oeq27b      number(15,3),            /*变更前计价数量                         */
oeq20a      varchar2(4),             /*变更后单位一                           */
oeq21a      number(20,8),            /*变更后单位一转换率(与销售单            */
oeq22a      number(15,3),            /*变更后单位一数量                       */
oeq23a      varchar2(4),             /*变更后单位二                           */
oeq24a      number(20,8),            /*变更后单位二转换率(与销售单            */
oeq25a      number(15,3),            /*变更后单位二数量                       */
oeq26a      varchar2(4),             /*变更后计价单位                         */
oeq27a      number(15,3),            /*变更后计价数量                         */
oeq28a      date,                    /*变更后预计归还日                       */
oeq28b      date,                    /*变更前预计归还日                       */
oeq29a      varchar2(10),            /*变更后展延原因码                       */
oeq29b      varchar2(10),            /*变更前展延原因码                       */
oequd01     varchar2(255),           /*自订字段-Textedit                      */
oequd02     varchar2(40),            /*自订字段-文字                          */
oequd03     varchar2(40),            /*自订字段-文字                          */
oequd04     varchar2(40),            /*自订字段-文字                          */
oequd05     varchar2(40),            /*自订字段-文字                          */
oequd06     varchar2(40),            /*自订字段-文字                          */
oequd07     number(15,3),            /*自订字段-数值                          */
oequd08     number(15,3),            /*自订字段-数值                          */
oequd09     number(15,3),            /*自订字段-数值                          */
oequd10     number(10),              /*自订字段-整数                          */
oequd11     number(10),              /*自订字段-整数                          */
oequd12     number(10),              /*自订字段-整数                          */
oequd13     date,                    /*自订字段-日期                          */
oequd14     date,                    /*自订字段-日期                          */
oequd15     date,                    /*自订字段-日期                          */
oeqplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oeqlegal    varchar2(10) NOT NULL,   /*所属法人                               */
oeq30a      varchar2(10),            /*变更后原因码                           */
oeq30b      varchar2(10),            /*变更前原因码                           */
oeq31a      varchar2(10),            /*變更後專案代號                         */
oeq31b      varchar2(10),            /*變更前專案代號                         */
oeq32a      varchar2(30),            /*變更後WBS編碼                          */
oeq32b      varchar2(30),            /*變更前WBS編碼                          */
oeq33a      varchar2(4),             /*變更後活動代號                         */
oeq33b      varchar2(4),             /*變更前活動代號                         */
oeq37a      number(20,6) DEFAULT '0' NOT NULL, /*变更后基础价格*/
oeq37b      number(20,6) DEFAULT '0' NOT NULL, /*变更前基础价格*/
oeq11a      varchar2(40),            /*变更后客户产品编号                     */
oeq11b      varchar2(40)             /*变更前客户产品编号                     */
);

alter table oeq_file add  constraint oeq_pk primary key  (oeq01,oeq02,oeq03) enable validate;
grant select on oeq_file to tiptopgp;
grant update on oeq_file to tiptopgp;
grant delete on oeq_file to tiptopgp;
grant insert on oeq_file to tiptopgp;
grant index on oeq_file to public;
grant select on oeq_file to ods;
