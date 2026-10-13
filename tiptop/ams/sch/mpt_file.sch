/*
================================================================================
檔案代號:mpt_file
檔案名稱:MPS 供需明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table mpt_file
(
mpt_v       varchar2(10),            /*模拟版本                               */
                                     /*模擬版本                               */
mpt01       varchar2(40),            /*料号                                   */
                                     /*料號                                   */
mpt02       varchar2(10),            /*No Use                                 */
mpt03       date,                    /*供需日期                               */
                                     /*供需日期(依時距)                       */
mpt04       date,                    /*供需日期                               */
                                     /*供需日期(實際)                         */
mpt05       varchar2(2),             /*供需类型                               */
                                     /*供需類別                               */
                                     /*  39 : 預測量                          */
                                     /*  40 : 安全庫存量                      */
                                     /*  41 : 獨立需求                        */
                                     /*  42 : 受訂量                          */
                                     /*  43 : 計劃備料量 (MPS 計劃下階料展出) */
                                     /*  44 : 工單備料量 (實際工單下階料展出) */
                                     /*  45 : PLM 備料量 (PLM 工單下階料展出) */
                                     /*  46 : 受訂量(相依需求)                */
                                     /*  51 : 庫存量                          */
                                     /*  52 : 在驗量                          */
                                     /*  53 : 替代料庫存量                    */
                                     /*  61 : 請購量                          */
                                     /*  62 : 在採量                          */
                                     /*  63 : 在外量                          */
                                     /*  64 : 在製量                          */
                                     /*  65 : 計劃產                          */
mpt06       varchar2(20),            /*来源单号                               */
                                     /*來源單號                               */
mpt061      number(5),               /*来源项次                               */
                                     /*來源項次                               */
mpt06_fz    varchar2(1),             /*冻结交期否                             */
                                     /*(Frozen)凍結交期否(Y/N)(For PR/PO/WO)  */
mpt07       varchar2(40),            /*来源料号                               */
                                     /*Source Itm#(Up Lv Semi-/Product Req Pegging Itm#*/
mpt08       number(15,3),            /*数量                                   */
                                     /*數量                                   */
mptplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
mptlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index mpt_01 on mpt_file (mpt01,mpt03);
create        index mpt_02 on mpt_file (mpt06);
grant select on mpt_file to tiptopgp;
grant update on mpt_file to tiptopgp;
grant delete on mpt_file to tiptopgp;
grant insert on mpt_file to tiptopgp;
grant index on mpt_file to public;
grant select on mpt_file to ods;
