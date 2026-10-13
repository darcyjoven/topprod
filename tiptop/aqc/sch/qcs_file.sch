/*
================================================================================
檔案代號:qcs_file
檔案名稱:质量检验单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qcs_file
(
qcs00       varchar2(1),             /*资料来源                               */
                                     /*Data Source  IQC:1:Receipt 2.Manually Entered 7.Re. Product (aqct110)*/
                                     /*          OQC:5.Delivery Advice 6.Delivery Note (aqct700)*/
                                     /*          InvQC:A.Misc Issue Doc.            (aqct800)*/
                                     /*                B.Misc Issue Doc.      */
                                     /*                C.Warehouse Transfer(Out)*/
                                     /*                D.Inter-Plant Transfer(Out)*/
                                     /*                E.Bw.Itm               */
                                     /*                F.Repay Item           */
                                     /*                G.Warehouse QC Apply   */
                                     /*                Z.Other                */
qcs01       varchar2(20) NOT NULL,   /*来源单号                               */
                                     /*來源單號                     (key)     */
qcs02       number(5) NOT NULL,      /*来源项次                               */
                                     /*來源項次                     (key)     */
qcs021      varchar2(40),            /*料件编号                               */
                                     /*料件編號                               */
qcs03       varchar2(10),            /*厂商编号                               */
                                     /*廠商編號                               */
qcs04       date,                    /*检验日期                               */
                                     /*檢驗日期                               */
qcs041      varchar2(8),             /*检验时间                               */
                                     /*檢驗時間                               */
qcs05       number(5) NOT NULL,      /*检验批号                               */
                                     /*檢驗批號 (分批檢驗順序)      (key)     */
qcs06       number(15,3),            /*检验量                                 */
                                     /*檢驗量                                 */
qcs061      number(12,3),            /*No Use                                 */
qcs062      varchar2(4),             /*No Use                                 */
qcs071      number(12,3),            /*No Use                                 */
qcs072      varchar2(4),             /*No Use                                 */
qcs081      number(12,3),            /*No Use                                 */
qcs082      varchar2(4),             /*No Use                                 */
qcs09       varchar2(1),             /*判定结果                               */
                                     /*判定結果                               */
                                     /*1.合格    2.退貨   3.特採              */
qcs091      number(15,3),            /*合格数量                               */
                                     /*合格數量                               */
qcs10       varchar2(10),            /*承认文号                               */
qcs101      number(5),               /*No Use                                 */
qcs11       varchar2(1),             /*No Use                                 */
qcs12       varchar2(255),           /*备注栏                                 */
                                     /*備註欄                                 */
qcs13       varchar2(10),            /*检验员                                 */
                                     /*檢驗員                                 */
qcs14       varchar2(1),             /*确认码                                 */
                                     /*確認碼(Y/N/X)                          */
qcs15       date,                    /*审核日期                               */
                                     /*確認日期                               */
qcs16       varchar2(1),             /*急料否                                 */
qcs17       varchar2(1),             /*级数                                   */
                                     /*級數                                   */
qcs18       date,                    /*No Use                                 */
qcs19       varchar2(8),             /*No Use                                 */
qcs20       varchar2(30),            /*No Use                                 */
qcs21       varchar2(1),             /*IQC 检验类型代码                       */
                                     /*IQC 檢驗型態代碼                       */
qcs22       number(15,3),            /*送验量                                 */
                                     /*送驗量                                 */
qcsprno     number(5),               /*打印次数                               */
                                     /*列印次數                               */
qcsacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
qcsuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
qcsgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
qcsmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
qcsdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
qcs30       varchar2(4),             /*单位一                                 */
qcs31       number(20,8),            /*单位一换算率(与采购单位)               */
qcs32       number(15,3),            /*单位一数量                             */
qcs33       varchar2(4),             /*单位二                                 */
qcs34       number(20,8),            /*单位二换算率(与销售单位)               */
qcs35       number(15,3),            /*单位二数量                             */
qcs36       varchar2(4),             /*单位一(合格量)                         */
qcs37       number(20,8),            /*单位一转换率(合格量)                   */
qcs38       number(15,3),            /*单位一合格量                           */
qcs39       varchar2(4),             /*单位二(合格量)                         */
qcs40       number(20,8),            /*单位二转换率(合格量)                   */
qcs41       number(15,3),            /*单位二合格量                           */
qcsspc      varchar2(1),             /*SPC抛转码                              */
qcsud01     varchar2(255),           /*自订字段-Textedit                      */
qcsud02     varchar2(40),            /*有害物质检测                           */
qcsud03     varchar2(40),            /*批次号                                 */
qcsud04     varchar2(40),            /*自订字段-文字                          */
qcsud05     varchar2(40),            /*自订字段-文字                          */
qcsud06     varchar2(40),            /*自订字段-文字                          */
qcsud07     number(15,3),            /*留样数量                               */
qcsud08     varchar2(1800),          /*自订字段-数值                          */
qcsud09     varchar2(20),            /*自订字段-数值                          */
qcsud10     number(10),              /*自订字段-整数                          */
qcsud11     varchar2(180),           /*自订字段-整数                          */
qcsud12     varchar2(180),           /*自订字段-整数                          */
qcsud13     date,                    /*回复日期                               */
qcsud14     date,                    /*自订字段-日期                          */
qcsud15     date,                    /*自订字段-日期                          */
qcsplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
qcslegal    varchar2(10) NOT NULL,   /*所属法人                               */
qcsoriu     varchar2(10),            /*资料建立者                             */
qcsorig     varchar2(10)             /*资料建立部门                           */
);

alter table qcs_file add  constraint qcs_pk primary key  (qcs01,qcs02,qcs05) enable validate;
grant select on qcs_file to tiptopgp;
grant update on qcs_file to tiptopgp;
grant delete on qcs_file to tiptopgp;
grant insert on qcs_file to tiptopgp;
grant index on qcs_file to public;
grant select on qcs_file to ods;
