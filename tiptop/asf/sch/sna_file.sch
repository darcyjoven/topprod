/*
================================================================================
檔案代號:sna_file
檔案名稱:工单变更单单身
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sna_file
(
sna01       varchar2(20) NOT NULL,   /*工单单号                               */
                                     /*工單單號                               */
sna02       number(5) NOT NULL,      /*变更序号                               */
                                     /*變更序號                               */
sna022      date,                    /*变更日期                               */
                                     /*變更日期                               */
sna04       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
sna10       varchar2(1),             /*单身变异码                             */
                                     /*單身變異別(1/2/3/4)                    */
                                     /*當單頭變更類型(snb04)='2',此欄位才可維護*/
                                     /*變更類型(snb04)='2'單頭變更,此欄位值為 */
                                     /*1.新憎 2.修改 3.取替代                 */
                                     /*變更類型(snb04)='1'單身變更,此欄位值為 */
                                     /*4.單頭變更,影響單身變更                */
sna03b      varchar2(40),            /*变更前料件编号                         */
                                     /*變更前料件編號                         */
sna05b      number(15,3),            /*变更前应发数量                         */
                                     /*變更前應發數量                         */
sna06b      number(15,3),            /*变更前已发数量                         */
                                     /*變更前已發數量                         */
sna062b     number(15,3),            /*变更前超领数量                         */
                                     /*變更前超領數量                         */
sna065b     number(15,3),            /*变更前委外代买数量                     */
                                     /*變更前委外代買數量                     */
sna07b      number(15,3),            /*变更前欠料数量                         */
                                     /*變更前欠料數量                         */
sna08b      varchar2(6),             /*变更前作业编号                         */
                                     /*變更前作業編號                         */
sna100b     number(9,4),             /*变更前发料误差容许率                   */
                                     /*變更前發料誤差容許率                   */
sna11b      varchar2(1),             /*变更前旗标                             */
                                     /*變更前旗標                             */
sna12b      varchar2(4),             /*变更前发料单位                         */
                                     /*變更前發料單位                         */
sna13b      number(20,8),            /*变更发料单位/库存单位换算率            */
                                     /*變更發料單位/庫存單位換算率            */
                                     /*ex.發料單位=kg 庫存單位=g              */
                                     /* 1000/1=1000(換算率)                   */
sna161b     number(16,8),            /*变更前实际单位用量                     */
                                     /*變更前實際單位用量                     */
sna26b      varchar2(1),             /*变更前替代码                           */
                                     /*變更前替代碼                           */
sna27b      varchar2(40),            /*变更前替代料号                         */
                                     /*變更前替代料號                         */
sna28b      number(15,6),            /*变更前替代率                           */
                                     /*變更前替代率                           */
sna30b      varchar2(10),            /*变更前指定仓库                         */
                                     /*變更前指定倉庫                         */
sna31b      varchar2(10),            /*变更前指定库位                         */
                                     /*變更前指定儲位                         */
sna03a      varchar2(40),            /*变更后料件编号                         */
                                     /*變更後料件編號                         */
sna05a      number(15,3),            /*变更后应发数量                         */
                                     /*變更後應發數量                         */
sna06a      number(15,3),            /*变更后已发数量                         */
                                     /*變更後已發數量                         */
sna062a     number(15,3),            /*变更后超领数量                         */
                                     /*變更後超領數量                         */
sna065a     number(15,3),            /*变更后委外代买数量                     */
                                     /*變更後委外代買數量                     */
sna07a      number(15,3),            /*变更后欠料数量                         */
                                     /*變更後欠料數量                         */
sna08a      varchar2(6),             /*变更后作业编号                         */
                                     /*變更後作業編號                         */
sna100a     number(9,4),             /*变更后发料误差容许率                   */
                                     /*變更後發料誤差容許率                   */
sna11a      varchar2(1),             /*变更后旗标                             */
                                     /*變更後旗標                             */
sna12a      varchar2(4),             /*变更后发料单位                         */
                                     /*變更後發料單位                         */
sna13a      number(20,8),            /*变更后料单位/库存单位换算率            */
                                     /*變更後料單位/庫存單位換算率            */
                                     /*ex.發料單位=kg 庫存單位=g              */
                                     /* 1000/1=1000(換算率)                   */
sna161a     number(16,8),            /*变更后实际单位用量                     */
                                     /*變更後實際單位用量                     */
sna26a      varchar2(1),             /*变更后替代码                           */
                                     /*變更後替代碼                           */
sna27a      varchar2(40),            /*变更后替代料号                         */
                                     /*變更後替代料號                         */
sna28a      number(15,6),            /*变更后替代率                           */
                                     /*變更後替代率                           */
sna30a      varchar2(10),            /*变更后指定仓库                         */
                                     /*變更後指定倉庫                         */
sna31a      varchar2(10),            /*变更后指定库位                         */
                                     /*變更後指定儲位                         */
sna50       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
snaud01     varchar2(255),           /*自订字段-Textedit                      */
snaud02     varchar2(40),            /*自订字段-文字                          */
snaud03     varchar2(40),            /*自订字段-文字                          */
snaud04     varchar2(40),            /*自订字段-文字                          */
snaud05     varchar2(40),            /*自订字段-文字                          */
snaud06     varchar2(40),            /*自订字段-文字                          */
snaud07     number(15,3),            /*自订字段-数值                          */
snaud08     number(15,3),            /*自订字段-数值                          */
snaud09     number(15,3),            /*自订字段-数值                          */
snaud10     number(10),              /*自订字段-整数                          */
snaud11     number(10),              /*自订字段-整数                          */
snaud12     number(10),              /*自订字段-整数                          */
snaud13     date,                    /*自订字段-日期                          */
snaud14     date,                    /*自订字段-日期                          */
snaud15     date,                    /*自订字段-日期                          */
snaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
snalegal    varchar2(10) NOT NULL,   /*所属法人                               */
sna012a     varchar2(10),            /*变更后工艺段号                         */
sna012b     varchar2(10),            /*变更前工艺段号                         */
sna013b     number(5),               /*变更前工艺序                           */
sna013a     number(5),               /*变更后工艺序                           */
sna29a      varchar2(40),            /*变更后上阶料                           */
sna29b      varchar2(40)             /*变更前上阶料                           */
);

alter table sna_file add  constraint sna_pk primary key  (sna01,sna02,sna04) enable validate;
grant select on sna_file to tiptopgp;
grant update on sna_file to tiptopgp;
grant delete on sna_file to tiptopgp;
grant insert on sna_file to tiptopgp;
grant index on sna_file to public;
grant select on sna_file to ods;
