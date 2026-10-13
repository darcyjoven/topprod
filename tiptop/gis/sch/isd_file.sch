/*
================================================================================
檔案代號:isd_file
檔案名稱:销项发票汇入历史记录单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table isd_file
(
isd00       varchar2(1) NOT NULL,    /*0.已开发票  1.作废发票                 */
                                     /*0.已開發票  1.作廢發票                 */
isd01       varchar2(20) NOT NULL,   /*发票号码                               */
                                     /*發票號碼                               */
isd02       varchar2(20) NOT NULL,   /*单据号码                               */
                                     /*單據號碼                               */
isd03       varchar2(80) NOT NULL,   /*货物名称                               */
                                     /*貨物名稱                               */
isd04       varchar2(120),           /*规格                                   */
                                     /*規格                                   */
isd05       varchar2(6),             /*单位                                   */
                                     /*單位                                   */
isd06       number(16,6),            /*数量                                   */
                                     /*數量                                   */
isd07       number(20,6),            /*金额                                   */
                                     /*金額                                   */
isd08       varchar2(5),             /*商品类型                               */
                                     /*商品類別                               */
isd09       varchar2(1),             /*标志位                                 */
                                     /*標志位                                 */
isdlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table isd_file add  constraint isd_pk primary key  (isd01,isd02,isd03,isd00) enable validate;
grant select on isd_file to tiptopgp;
grant update on isd_file to tiptopgp;
grant delete on isd_file to tiptopgp;
grant insert on isd_file to tiptopgp;
grant index on isd_file to public;
grant select on isd_file to ods;
