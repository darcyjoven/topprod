/*
================================================================================
檔案代號:ksd_file
檔案名稱:拆件式工单完工入库单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ksd_file
(
ksd01       varchar2(20) NOT NULL,   /*入库编号                               */
                                     /*入庫編號                               */
ksd03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
ksd04       varchar2(40),            /*料号                                   */
                                     /*料號                                   */
ksd05       varchar2(10),            /*仓库                                   */
                                     /*倉庫                                   */
ksd06       varchar2(10),            /*库位                                   */
                                     /*儲位                                   */
ksd07       varchar2(24),            /*批号                                   */
                                     /*批號                                   */
ksd08       varchar2(4),             /*库存单位                               */
                                     /*庫存單位                               */
ksd09       number(15,3),            /*入库量                                 */
                                     /*入庫量                                 */
ksd11       varchar2(20),            /*拆件式工单编号                         */
                                     /*拆件式工單編號                         */
ksd12       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
ksd13       number(15,3),            /*报废量                                 */
ksd14       number(5),               /*作业序号                               */
ksd15       number(5),               /*下一作业序号                           */
ksd16       varchar2(1),             /*No Use                                 */
ksd17       varchar2(20),            /*FQC单号                                */
ksd18       varchar2(1),             /*No Use                                 */
ksd19       varchar2(1),             /*No Use                                 */
ksd20       varchar2(1),             /*No Use                                 */
ksd30       varchar2(4),             /*单位一                                 */
ksd31       number(20,8),            /*单位一换算率(与生产单位)               */
ksd32       number(15,3),            /*单位一数量                             */
ksd33       varchar2(4),             /*单位二                                 */
ksd34       number(20,8),            /*单位二换算率(与生产单位)               */
ksd35       number(15,3),            /*单位二数量                             */
ksd930      varchar2(10),            /*成本中心                               */
ksdud01     varchar2(255),           /*自订字段-Textedit                      */
ksdud02     varchar2(40),            /*自订字段-文字                          */
ksdud03     varchar2(40),            /*自订字段-文字                          */
ksdud04     varchar2(40),            /*自订字段-文字                          */
ksdud05     varchar2(40),            /*自订字段-文字                          */
ksdud06     varchar2(40),            /*自订字段-文字                          */
ksdud07     number(15,3),            /*自订字段-数值                          */
ksdud08     number(15,3),            /*自订字段-数值                          */
ksdud09     number(15,3),            /*自订字段-数值                          */
ksdud10     number(10),              /*自订字段-整数                          */
ksdud11     number(10),              /*自订字段-整数                          */
ksdud12     number(10),              /*自订字段-整数                          */
ksdud13     date,                    /*自订字段-日期                          */
ksdud14     date,                    /*自订字段-日期                          */
ksdud15     date,                    /*自订字段-日期                          */
ksdplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ksdlegal    varchar2(10) NOT NULL,   /*所属法人                               */
ksd46       varchar2(10),            /*QC判定结果编码                         */
ksd47       number(5),               /*QC判定结果项次                         */
ksd36       varchar2(10)             /*理由码                                 */
);

alter table ksd_file add  constraint ksd_pk primary key  (ksd01,ksd03) enable validate;
grant select on ksd_file to tiptopgp;
grant update on ksd_file to tiptopgp;
grant delete on ksd_file to tiptopgp;
grant insert on ksd_file to tiptopgp;
grant index on ksd_file to public;
grant select on ksd_file to ods;
