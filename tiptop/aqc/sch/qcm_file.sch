/*
================================================================================
檔案代號:qcm_file
檔案名稱:PQC 质量检验单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qcm_file
(
qcm00       varchar2(1),             /*资料来源                               */
                                     /*資料來源  1:報工單 2.自行輸入          */
qcm01       varchar2(20) NOT NULL,   /*来源单号                               */
                                     /*來源單號                               */
qcm02       varchar2(20),            /*工单编号                               */
                                     /*工單編號                               */
qcm021      varchar2(40),            /*料件编号                               */
                                     /*料件編號                               */
qcm03       varchar2(23),            /*Run Card 编号                          */
                                     /*Run Card 編號                          */
qcm04       date,                    /*检验日期                               */
                                     /*檢驗日期                               */
qcm041      varchar2(8),             /*检验时间                               */
                                     /*檢驗時間                               */
qcm05       number(5),               /*工艺序                                 */
                                     /*製程序                                 */
qcm06       number(15,3),            /*检验量                                 */
                                     /*檢驗量                                 */
qcm061      number(12,3),            /*No Use                                 */
qcm062      varchar2(4),             /*No Use                                 */
qcm071      number(12,3),            /*No Use                                 */
qcm072      varchar2(4),             /*No Use                                 */
qcm081      number(12,3),            /*No Use                                 */
qcm082      varchar2(4),             /*No Use                                 */
qcm09       varchar2(1),             /*判定结果                               */
                                     /*判定結果                               */
                                     /*1.合格    2.退貨   3.特採              */
qcm091      number(15,3),            /*合格数量                               */
                                     /*合格數量                               */
qcm10       varchar2(10),            /*No Use                                 */
qcm101      number(5),               /*No Use                                 */
qcm11       varchar2(1),             /*No Use                                 */
qcm12       varchar2(255),           /*备注栏                                 */
                                     /*備註欄                                 */
qcm13       varchar2(10),            /*检验员                                 */
                                     /*檢驗員                                 */
qcm14       varchar2(1),             /*确认码                                 */
                                     /*確認碼(Y/N/X)                          */
qcm15       date,                    /*审核日期                               */
                                     /*確認日期                               */
qcm16       varchar2(1),             /*No Use                                 */
qcm17       varchar2(1),             /*级数                                   */
                                     /*級數                                   */
qcm18       varchar2(1),             /*1:工单工艺PQC 2:Run Card工艺PQC        */
                                     /*1:工單製程PQC 2:Run Card製程PQC        */
qcm19       varchar2(10),            /*No Use                                 */
qcm20       varchar2(10),            /*No Use                                 */
qcm21       varchar2(1),             /*PQC 检验类型代码                       */
                                     /*PQC 檢驗型態代碼                       */
qcm22       number(15,3),            /*送验量                                 */
                                     /*送驗量                                 */
qcmprno     number(5),               /*打印次数                               */
                                     /*列印次數                               */
qcmacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
qcmuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
qcmgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
qcmmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
qcmdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
qcmspc      varchar2(1),             /*SPC抛转码 0/1/2                        */
qcmud01     varchar2(255),           /*自订字段-Textedit                      */
qcmud02     varchar2(40),            /*自订字段-文字                          */
qcmud03     varchar2(40),            /*自订字段-文字                          */
qcmud04     varchar2(40),            /*自订字段-文字                          */
qcmud05     varchar2(40),            /*自订字段-文字                          */
qcmud06     varchar2(40),            /*自订字段-文字                          */
qcmud07     number(15,3),            /*自订字段-数值                          */
qcmud08     number(15,3),            /*自订字段-数值                          */
qcmud09     number(15,3),            /*自订字段-数值                          */
qcmud10     number(10),              /*自订字段-整数                          */
qcmud11     number(10),              /*自订字段-整数                          */
qcmud12     number(10),              /*自订字段-整数                          */
qcmud13     date,                    /*自订字段-日期                          */
qcmud14     date,                    /*自订字段-日期                          */
qcmud15     date,                    /*自订字段-日期                          */
qcmplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
qcmlegal    varchar2(10) NOT NULL,   /*所属法人                               */
qcmoriu     varchar2(10),            /*资料建立者                             */
qcmorig     varchar2(10),            /*资料建立部门                           */
qcm012      varchar2(10)             /*工艺段号                               */
);

alter table qcm_file add  constraint qcm_pk primary key  (qcm01) enable validate;
grant select on qcm_file to tiptopgp;
grant update on qcm_file to tiptopgp;
grant delete on qcm_file to tiptopgp;
grant insert on qcm_file to tiptopgp;
grant index on qcm_file to public;
grant select on qcm_file to ods;
