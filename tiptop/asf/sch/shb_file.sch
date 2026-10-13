/*
================================================================================
檔案代號:shb_file
檔案名稱:工单生产日报维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table shb_file
(
shb01       varchar2(20) NOT NULL,   /*移转单号                               */
                                     /*移轉單號                               */
shb02       date,                    /*开工日期                               */
                                     /*開工日期                               */
shb021      varchar2(8),             /*开工时间                               */
                                     /*開工時間                               */
shb03       date,                    /*完工日期                               */
shb031      varchar2(8),             /*完工时间                               */
                                     /*完工時間                               */
shb04       varchar2(10),            /*员工编号                               */
                                     /*員工編號                               */
shb05       varchar2(20),            /*工单编号                               */
                                     /*工單編號                               */
shb06       number(5),               /*工艺序号                               */
                                     /*製程序號                               */
shb07       varchar2(10),            /*工作中心                               */
shb08       varchar2(10),            /*线/班别                                */
                                     /*線/班別                                */
shb081      varchar2(6),             /*作业编号                               */
                                     /*作業編號     ecm04                     */
shb082      varchar2(80),            /*作业名称                               */
                                     /*作業名稱     ecm45                     */
shb09       varchar2(10),            /*机台编号                               */
                                     /*機台編號                               */
shb10       varchar2(40),            /*生产料件                               */
                                     /*生產料件                               */
shb111      number(15,3),            /*良品转出数量                           */
                                     /*良品轉出數量                           */
shb112      number(15,3),            /*当站报废数量                           */
                                     /*當站報廢數量                           */
shb113      number(15,3),            /*返工转出数量                           */
                                     /*重工轉出數量                           */
shb114      number(15,3),            /*当站下线数量                           */
                                     /*當站下線數量                           */
shb115      number(15,3),            /*Bonus   数量                           */
                                     /*Bonus   數量                           */
shb12       number(5),               /*返工转出下工艺序                       */
                                     /*重工轉出下製程序                       */
shb13       varchar2(20),            /*领料单号                               */
                                     /*領料單號                               */
shb14       varchar2(20),            /*入库单号                               */
                                     /*入庫單號                               */
shb15       number(5),               /*项次                                   */
                                     /*項次                                   */
shb16       varchar2(23),            /*Run Card                               */
shb17       number(15,3),            /*工单转出量                             */
                                     /*工單轉出量                             */
shb18       varchar2(20),            /*移转单号                               */
shb19       varchar2(1),             /*No Use                                 */
shb20       varchar2(1),             /*No Use                                 */
shbinp      date,                    /*录入日期                               */
                                     /*輸入日期                               */
shbacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
shbuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護                               */
shbgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護                               */
shbmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護                               */
shbdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
                                     /*系統維護                               */
shbud01     varchar2(255),           /*自订字段-Textedit                      */
shbud02     varchar2(40),            /*是否已转委外                           */
shbud03     varchar2(40),            /*自订字段-文字                          */
shbud04     varchar2(40),            /*自订字段-文字                          */
shbud05     varchar2(40),            /*自订字段-文字                          */
shbud06     varchar2(40),            /*自订字段-文字                          */
shbud07     number(15,3),            /*转维修站                               */
shbud08     number(15,3),            /*自订字段-数值                          */
shbud09     number(15,3),            /*自订字段-数值                          */
shbud10     number(10),              /*自订字段-整数                          */
shbud11     number(10),              /*自订字段-整数                          */
shbud12     number(10),              /*自订字段-整数                          */
shbud13     date,                    /*自订字段-日期                          */
shbud14     date,                    /*自订字段-日期                          */
shbud15     date,                    /*自订字段-日期                          */
shb21       varchar2(20),            /*生产入库单号                           */
shb22       varchar2(20),            /*FQC单号                                */
shbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
shblegal    varchar2(10) NOT NULL,   /*所属法人                               */
shboriu     varchar2(10),            /*资料建立者                             */
shborig     varchar2(10),            /*资料建立部门                           */
shb012      varchar2(10),            /*工艺段号                               */
shb121      varchar2(10),            /*重工转出下工艺段号                     */
shb23       varchar2(20),            /*PBI单号                                */
shb24       number(5),               /*PBI报工项次                            */
shb25       varchar2(20),            /*号机                                   */
shb26       varchar2(1) DEFAULT ' ' NOT NULL, /*下道工序是否委外*/
shb27       varchar2(10),            /*委外厂商                               */
shb28       varchar2(20),            /*委外采购单号                           */
shb29       varchar2(20),            /*委外收货单号                           */
shb30       varchar2(1) DEFAULT ' ' NOT NULL, /*自動報工否*/
shb31       varchar2(1) DEFAULT ' ' NOT NULL, /*本道工序是否委外*/
shb32       date,                    /*审核日                                 */
shbconf     varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
shb34       varchar2(4),             /*单位                                   */
shb032      number(15,3),            /*投入工时                               */
                                     /*投入工時                               */
shb033      number(15,3)             /*投入机时                               */
);

create        index shb_03 on shb_file (shb16);
create        index shb_02 on shb_file (shb05);
alter table shb_file add  constraint shb_pk primary key  (shb01) enable validate;
grant select on shb_file to tiptopgp;
grant update on shb_file to tiptopgp;
grant delete on shb_file to tiptopgp;
grant insert on shb_file to tiptopgp;
grant index on shb_file to public;
grant select on shb_file to ods;
