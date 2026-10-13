/*
================================================================================
檔案代號:idk_file
檔案名稱:ICD厂商发票单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table idk_file
(
idk01       varchar2(20) DEFAULT ' ' NOT NULL, /*发票号码*/
idk02       date,                    /*发票日期                               */
idk03       varchar2(4),             /*税种                                   */
idk04       number(9,4),             /*税率                                   */
idk05       number(20,6),            /*税前金额(本币)                         */
idk05f      number(20,6),            /*税前金额(原币)                         */
                                     /*未稅金額(本幣)                         */
idk06       number(20,6),            /*税额    (本币)                         */
idk06f      number(20,6),            /*税额    (原币)                         */
                                     /*稅額    (本幣)                         */
idk07       varchar2(20),            /*发票代码                               */
idk08       varchar2(20) NOT NULL,   /*入库/退货单号                          */
idk09       number(5) NOT NULL,      /*项次                                   */
idk10       number(15,3),            /*数量                                   */
idk11       varchar2(4),             /*币种                                   */
idk12       number(20,10),           /*汇率                                   */
idk13       varchar2(1),             /*no use                                 */
idk14       varchar2(1),             /*no use                                 */
idk15       varchar2(1),             /*no use                                 */
idk16       varchar2(1),             /*no use                                 */
idk17       number(20,6),            /*原币税前单价                           */
idk18       varchar2(10),            /*facility                               */
idk19       varchar2(10),            /*site                                   */
idk21       varchar2(30),            /*invoice_no                             */
idk22       varchar2(30),            /*customer_po                            */
idk23       varchar2(30),            /*customer_pn                            */
idk24       varchar2(30),            /*mxic epn                               */
idk25       varchar2(30),            /*参考一                                 */
idk26       varchar2(30),            /*参考二                                 */
idk27       varchar2(30),            /*参考三                                 */
idk28       varchar2(30),            /*参考四                                 */
idk29       varchar2(1),             /*转入收货单                             */
idkplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
idklegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table idk_file add  constraint idk_pk primary key  (idk01,idk08,idk09) enable validate;
grant select on idk_file to tiptopgp;
grant update on idk_file to tiptopgp;
grant delete on idk_file to tiptopgp;
grant insert on idk_file to tiptopgp;
grant index on idk_file to public;
grant select on idk_file to ods;
