/*
================================================================================
檔案代號:ttd_file
檔案名稱:销货成本表统计资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ttd_file
(
ttd01       varchar2(10) NOT NULL,   /*产品别                                 */
                                     /*產品別(其他分群碼一ima09)              */
ttd02       number(5) NOT NULL,      /*年度                                   */
ttd03       number(5) NOT NULL,      /*月份                                   */
ttd04       number(20,6),            /*材料:期初存料                          */
                                     /*材料:期初存料(csdr300)                 */
ttd05       number(20,6),            /*标准调整差异                           */
                                     /*     標準調整差異(csdr360)             */
ttd06       number(20,6),            /*加:本期进料--实际                      */
                                     /*  加:本期進料--實際(csdr120+價差)      */
ttd07       number(20,6),            /*价差                                   */
                                     /*               價差(csdr100)           */
ttd08       number(20,6),            /*价差                                   */
                                     /*               價差(csdr810)           */
ttd09       number(20,6),            /*他厂转入--标准                         */
                                     /*     他廠轉入--標準(csdr120)           */
ttd10       number(20,6),            /*半成品入库                             */
                                     /*     半成品入庫(csdr210)               */
ttd11       number(20,6),            /*减:部门领用                            */
                                     /*  減:部門領用(csdr160)                 */
ttd12       number(20,6),            /*出售                                   */
                                     /*     出售(csdr180)                     */
ttd13       number(20,6),            /*出售退回                               */
                                     /*     出售退回(csdr183)                 */
ttd14       number(20,6),            /*样品出货                               */
                                     /*     樣品出貨(csdr133)                 */
ttd15       number(20,6),            /*期末存料                               */
                                     /*     期末存料(csdr300)                 */
ttd16       number(20,6),            /*加减:数量差异                          */
                                     /*  加減:數量差異(csdr200)               */
ttd17       number(20,6),            /*本期成品投入                           */
                                     /*  本期成品投入(csdr200='F')            */
ttd18       number(20,6),            /*直接人工                               */
                                     /*  直接人工(csdr220)                    */
ttd19       number(20,6),            /*直接人工                               */
                                     /*  直接人工(csdp110)                    */
ttd20       number(20,6),            /*制造费用                               */
                                     /*  製造費用(csdr220)                    */
ttd21       number(20,6),            /*制造费用                               */
                                     /*  製造費用(csdp110)                    */
ttd22       number(20,6),            /*加减:人工成本差异                      */
                                     /*  加減:人工成本差異(csdr200)           */
ttd23       number(20,6),            /*加减:人工成本差异                      */
                                     /*  加減:人工成本差異(csdr230)           */
ttd24       number(20,6),            /*加减:费用成本差异                      */
                                     /*  加減:費用成本差異(csdr200)           */
ttd25       number(20,6),            /*加减:费用成本差异                      */
                                     /*  加減:費用成本差異(csdr230)           */
ttd26       number(20,6),            /*加:期初在制品                          */
                                     /*  加:期初在製品(csdr220)               */
ttd27       number(20,6),            /*减:期末在制品                          */
                                     /*  減:期末在製品(csdr220)               */
ttd28       number(20,6),            /*成品:期初存货                          */
                                     /*  成品:期初存貨(csdr300)               */
ttd29       number(20,6),            /*标准调整差异                           */
                                     /*       標準調整差異(csdr360)           */
ttd30       number(20,6),            /*加:市购成品--实际                      */
                                     /*    加:巿購成品--實際(csdr120)         */
ttd31       number(20,6),            /*市购成品--价差                         */
                                     /*       巿購成品--價差(capr100)         */
ttd32       number(20,6),            /*市购成品--价差                         */
                                     /*       巿購成品--價差(capr810)         */
ttd33       number(20,6),            /*减:部门领用                            */
                                     /*    減:部門領用(csdr160)               */
ttd34       number(20,6),            /*半成品入库                             */
                                     /*       半成品入庫(csdr210)             */
ttd35       number(20,6),            /*销货退回                               */
                                     /*       銷貨退回(csdr143)               */
ttd36       number(20,6),            /*样品出货                               */
                                     /*       樣品出貨(csdr130)               */
ttd37       number(20,6),            /*样品出货                               */
                                     /*       樣品出貨(csdr133)               */
ttd38       number(20,6),            /*期末存货                               */
                                     /*       期末存貨(csdr300)               */
ttd39       number(20,6),            /*三角贸易:成品:出售                     */
                                     /*三角貿易:成品:出售(cxrr370)            */
ttd40       number(20,6),            /*退回                                   */
                                     /*              退回(cxrr370b)           */
ttd41       number(20,6),            /*材料:出售                              */
                                     /*         材料:出售(cxrr370a)           */
ttdplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ttdlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table ttd_file add  constraint ttd_pk primary key  (ttd02,ttd03,ttd01) enable validate;
grant select on ttd_file to tiptopgp;
grant update on ttd_file to tiptopgp;
grant delete on ttd_file to tiptopgp;
grant insert on ttd_file to tiptopgp;
grant index on ttd_file to public;
grant select on ttd_file to ods;
