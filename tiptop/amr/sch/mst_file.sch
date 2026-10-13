/*
================================================================================
檔案代號:mst_file
檔案名稱:LRP 供需明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table mst_file
(
mst_v       varchar2(10),            /*模拟版本                               */
                                     /*模擬版本                               */
mst01       varchar2(40),            /*料号                                   */
                                     /*料號                                   */
mst02       varchar2(10),            /*厂商编号                               */
                                     /*廠商編號                               */
mst03       date,                    /*供需日期                               */
                                     /*供需日期(依時距)                       */
mst04       date,                    /*供需日期                               */
                                     /*供需日期(實際)                         */
mst05       varchar2(2),             /*供需类型                               */
                                     /*供需類別                               */
                                     /*  40 : 安全庫存量                      */
                                     /*  41 : 獨立需求                        */
                                     /*  42 : 受訂量/MDS需求量                */
                                     /*  43 : 計劃備料量 (MPS 計劃下階料展出) */
                                     /*  44 : 工單備料量 (實際工單下階料展出) */
                                     /*  45 : PLM 備料量 (PLM 工單下階料展出) */
                                     /*  46 : 備品需求量                      */
                                     /*  51 : 庫存量                          */
                                     /*  52 : 在驗量                          */
                                     /*  53 : 替代料庫存量                    */
                                     /*  61 : 請購量                          */
                                     /*  62 : 在採量                          */
                                     /*  63 : 在外量                          */
                                     /*  64 : 在製量                          */
                                     /*  65 : 計劃產                          */
mst06       varchar2(20),            /*来源单号                               */
                                     /*來源單號                               */
mst061      number(5),               /*来源项次                               */
                                     /*來源項次                               */
mst06_fz    varchar2(1),             /*冻结交期否                             */
                                     /*(Frozen)凍結交期否(Y/N)(For PR/PO/WO)  */
mst07       varchar2(40),            /*来源料号                               */
                                     /*來源料號 (上階半/成品需求追索料號)     */
mst08       number(15,3),            /*数量                                   */
                                     /*數量                                   */
                                     /*型態 int -> dec(12,3)           No.7087*/
mstplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
mstlegal    varchar2(10) NOT NULL,   /*所属法人                               */
mst09       varchar2(1) DEFAULT ' ' NOT NULL
);

create        index mst_02 on mst_file (mst06);
create        index mst_01 on mst_file (mst01,mst03,mst02);
grant select on mst_file to tiptopgp;
grant update on mst_file to tiptopgp;
grant delete on mst_file to tiptopgp;
grant insert on mst_file to tiptopgp;
grant index on mst_file to public;
grant select on mst_file to ods;
