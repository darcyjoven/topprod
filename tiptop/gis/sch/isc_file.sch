/*
================================================================================
檔案代號:isc_file
檔案名稱:销项发票汇入历史记录单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table isc_file
(
isc00       varchar2(1) NOT NULL,    /*0.已开发票  1.作废发票                 */
                                     /*0.已開發票  1.作廢發票                 */
isc01       varchar2(20) NOT NULL,   /*发票号码                               */
                                     /*發票號碼                               */
isc02       varchar2(4),             /*商品行数                               */
                                     /*商品行數                               */
isc03       date,                    /*开票日期                               */
                                     /*開票日期                               */
isc04       varchar2(20) NOT NULL,   /*单据编号                               */
                                     /*單據編號                               */
isc05       number(20,6),            /*发票总金额                             */
                                     /*發票總金額                             */
isc06       number(9,4),             /*税率                                   */
                                     /*稅率                                   */
isc07       varchar2(80),            /*客户全名                               */
                                     /*客戶全名                               */
isc08       varchar2(20),            /*客户税号                               */
                                     /*客戶統一編號                           */
isc09       varchar2(80),            /*客户发票地址及电话                     */
                                     /*客戶發票地址及電話                     */
isc10       varchar2(80),            /*客户开户银行及帐号                     */
                                     /*客戶開戶銀行及帳號                     */
isc11       varchar2(80),            /*本单位地址及电话                       */
                                     /*本單位地址及電話                       */
isc12       varchar2(80),            /*本单位开户银行及帐号                   */
                                     /*本單位開戶銀行及帳號                   */
isc13       varchar2(10),            /*开票人                                 */
                                     /*開票人                                 */
isc14       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
isc15       varchar2(10),            /*复核人                                 */
                                     /*複核人                                 */
isc16       varchar2(10),            /*收款人                                 */
isc17       varchar2(20),            /*发票代码                               */
                                     /*發票代碼                               */
isclegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table isc_file add  constraint isc_pk primary key  (isc01,isc04,isc00) enable validate;
grant select on isc_file to tiptopgp;
grant update on isc_file to tiptopgp;
grant delete on isc_file to tiptopgp;
grant insert on isc_file to tiptopgp;
grant index on isc_file to public;
grant select on isc_file to ods;
