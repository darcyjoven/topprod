/*
================================================================================
檔案代號:nqf_file
檔案名稱:资金模拟版本
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nqf_file
(
nqf00       varchar2(10) NOT NULL,   /*模拟版本                               */
nqf01_1     varchar2(10),            /*模拟营运中心                           */
nqf01_2     varchar2(10),            /*模拟营运中心                           */
nqf01_3     varchar2(10),            /*模拟营运中心                           */
nqf01_4     varchar2(10),            /*模拟营运中心                           */
nqf01_5     varchar2(10),            /*模拟营运中心                           */
nqf01_6     varchar2(10),            /*模拟营运中心                           */
nqf01_7     varchar2(10),            /*模拟营运中心                           */
nqf01_8     varchar2(10),            /*模拟营运中心                           */
nqf01_9     varchar2(10),            /*模拟营运中心                           */
nqf01_10    varchar2(10),            /*模拟营运中心                           */
nqf01_11    varchar2(10),            /*模拟营运中心                           */
nqf01_12    varchar2(10),            /*模拟营运中心                           */
nqf01_13    varchar2(10),            /*模拟营运中心                           */
nqf01_14    varchar2(10),            /*模拟营运中心                           */
nqf01_15    varchar2(10),            /*模拟营运中心                           */
nqf01_16    varchar2(10),            /*模拟营运中心                           */
nqf02       date,                    /*模拟截止日期                           */
nqf03       varchar2(1),             /*订单(+)                                */
nqf04       varchar2(1),             /*销货单(+)                              */
nqf05       varchar2(1),             /*应收帐款(+)                            */
nqf06       varchar2(1),             /*应收票据(+)                            */
nqf07       varchar2(1),             /*采购(委外采购)单(-)                    */
nqf08       varchar2(1),             /*入库单(-)                              */
nqf09       varchar2(1),             /*应付帐款(-)                            */
nqf10       varchar2(1),             /*应付票据(-)                            */
nqf11       varchar2(1),             /*应收利息(+)                            */
nqf12       varchar2(1),             /*短期融资到期(-)                        */
nqf13       varchar2(1),             /*长期融资到期(-)                        */
nqf14       varchar2(1),             /*应付利息(-)                            */
nqfacti     varchar2(1),             /*资料有效码                             */
nqfuser     varchar2(10),            /*资料所有者                             */
nqfgrup     varchar2(10),            /*资料所有群                             */
nqfmodu     varchar2(10),            /*资料更改者                             */
nqfdate     date,                    /*最近更改日                             */
nqf15       varchar2(1),             /*投资                                   */
nqf16       varchar2(1),             /*外汇                                   */
nqforig     varchar2(10),            /*资料建立部门                           */
nqforiu     varchar2(10)             /*资料建立者                             */
);

alter table nqf_file add  constraint nqf_pk primary key  (nqf00) enable validate;
grant select on nqf_file to tiptopgp;
grant update on nqf_file to tiptopgp;
grant delete on nqf_file to tiptopgp;
grant insert on nqf_file to tiptopgp;
grant index on nqf_file to public;
grant select on nqf_file to ods;
