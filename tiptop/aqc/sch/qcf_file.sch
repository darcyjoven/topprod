/*
================================================================================
檔案代號:qcf_file
檔案名稱:FQC 质量检验单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qcf_file
(
qcf00       varchar2(1),             /*资料来源                               */
                                     /*資料來源  1:工單 2.自行輸入            */
qcf01       varchar2(20) NOT NULL,   /*来源单号                               */
                                     /*來源單號                               */
qcf02       varchar2(20),            /*工单编号                               */
                                     /*工單編號                               */
qcf021      varchar2(40),            /*料件编号                               */
                                     /*料件編號                               */
qcf03       varchar2(23),            /*Run Card                               */
qcf04       date,                    /*检验日期                               */
                                     /*檢驗日期                               */
qcf041      varchar2(8),             /*检验时间                               */
                                     /*檢驗時間                               */
qcf05       number(5),               /*检验编号                               */
                                     /*檢驗編號                               */
qcf06       number(15,3),            /*检验量                                 */
                                     /*檢驗量                                 */
qcf061      number(12,3),            /*No Use                                 */
qcf062      varchar2(4),             /*No Use                                 */
qcf071      number(12,3),            /*No Use                                 */
qcf072      varchar2(4),             /*No Use                                 */
qcf081      number(12,3),            /*No Use                                 */
qcf082      varchar2(4),             /*No Use                                 */
qcf09       varchar2(1),             /*判定结果                               */
                                     /*判定結果                               */
                                     /*1.合格    2.退貨   3.特採              */
qcf091      number(15,3),            /*合格数量                               */
                                     /*合格數量                               */
qcf10       varchar2(10),            /*No Use                                 */
qcf101      number(5),               /*No Use                                 */
qcf11       varchar2(1),             /*No Use                                 */
qcf12       varchar2(255),           /*备注栏                                 */
                                     /*備註欄                                 */
qcf13       varchar2(10),            /*检验员                                 */
                                     /*檢驗員                                 */
qcf14       varchar2(1),             /*确认码                                 */
                                     /*確認碼(Y/N/X)                          */
qcf15       date,                    /*审核日期                               */
                                     /*確認日期                               */
qcf16       varchar2(1),             /*No Use                                 */
qcf17       varchar2(1),             /*级数                                   */
                                     /*級數                                   */
qcf18       varchar2(19),            /*1:工单 FQC 2:Run Card FQC              */
                                     /*1:工單 FQC 2:Run Card FQC              */
qcf19       varchar2(10),            /*起始箱号                               */
                                     /*起始箱號                               */
qcf20       varchar2(10),            /*截止箱号                               */
                                     /*截止箱號                               */
qcf21       varchar2(1),             /*FQC 检验类型代码                       */
                                     /*FQC 檢驗型態代碼                       */
qcf22       number(15,3),            /*送验量                                 */
                                     /*送驗量                                 */
qcfprno     number(5),               /*打印次数                               */
                                     /*列印次數                               */
qcfacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
qcfuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
qcfgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
qcfmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
qcfdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
qcf30       varchar2(4),             /*单位一(送验量)                         */
qcf31       number(20,8),            /*单位一转换率(送验量)                   */
qcf32       number(15,3),            /*单位一送验量                           */
qcf33       varchar2(4),             /*单位二(送验量)                         */
qcf34       number(20,8),            /*单位二转换率(送验量)                   */
qcf35       number(15,3),            /*单位二送验量                           */
qcf36       varchar2(4),             /*单位一(合格量)                         */
qcf37       number(20,8),            /*单位一转换率(合格量)                   */
qcf38       number(15,3),            /*单位一合格量                           */
qcf39       varchar2(4),             /*单位二(合格量)                         */
qcf40       number(20,8),            /*单位二转换率(合格量)                   */
qcf41       number(15,3),            /*单位二合格量                           */
qcfspc      varchar2(1),             /*SPC抛转码 0/1/2                        */
qcfud01     varchar2(255),           /*自订字段-Textedit                      */
qcfud02     varchar2(40),            /*自订字段-文字                          */
qcfud03     varchar2(40),            /*自订字段-文字                          */
qcfud04     varchar2(40),            /*自订字段-文字                          */
qcfud05     varchar2(40),            /*自订字段-文字                          */
qcfud06     varchar2(40),            /*自订字段-文字                          */
qcfud07     number(15,3),            /*自订字段-数值                          */
qcfud08     number(15,3),            /*自订字段-数值                          */
qcfud09     number(15,3),            /*自订字段-数值                          */
qcfud10     number(10),              /*自订字段-整数                          */
qcfud11     number(10),              /*自订字段-整数                          */
qcfud12     number(10),              /*自订字段-整数                          */
qcfud13     date,                    /*自订字段-日期                          */
qcfud14     date,                    /*自订字段-日期                          */
qcfud15     date,                    /*自订字段-日期                          */
qcfplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
qcflegal    varchar2(10) NOT NULL,   /*所属法人                               */
qcforiu     varchar2(10),            /*资料建立者                             */
qcforig     varchar2(10)             /*资料建立部门                           */
);

alter table qcf_file add  constraint qcf_pk primary key  (qcf01) enable validate;
grant select on qcf_file to tiptopgp;
grant update on qcf_file to tiptopgp;
grant delete on qcf_file to tiptopgp;
grant insert on qcf_file to tiptopgp;
grant index on qcf_file to public;
grant select on qcf_file to ods;
