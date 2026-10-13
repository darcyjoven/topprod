/*
================================================================================
檔案代號:nnr_file
檔案名稱:应收账款质押贷款
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nnr_file
(
nnr01       varchar2(20) NOT NULL,   /*相关单号                               */
                                     /*相關單號                               */
nnr02       number(5) NOT NULL,      /*行序                                   */
nnr03       varchar2(20) NOT NULL,   /*帐单号码                               */
                                     /*帳單號碼                               */
nnr04       varchar2(10),            /*客户编号                               */
                                     /*客戶編號                               */
nnr041      varchar2(40),            /*客户简称                               */
                                     /*客戶簡稱                               */
nnr05       date,                    /*帐单日期                               */
                                     /*帳單日期                               */
nnr06       date,                    /*货款期限                               */
                                     /*貨款期限                               */
nnr07       varchar2(20),            /*INVOICE                                */
nnr08       number(20,6),            /*INVOICE 金额                           */
                                     /*INVOICE 金額                           */
nnr09       varchar2(20),            /*LC No                                  */
nnr10       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
nnr11       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
nnr12       number(20,6),            /*原币应收金额                           */
                                     /*原幣應收金額                           */
nnr13       number(20,6),            /*本币应收金额                           */
                                     /*本幣應收金額                           */
nnr14       varchar2(1),             /*No Use                                 */
nnr15       varchar2(1),             /*No Use                                 */
nnr16       varchar2(1),             /*No Use                                 */
nnr17       varchar2(1),             /*No Use                                 */
nnrlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table nnr_file add  constraint nnr_pk primary key  (nnr01,nnr02,nnr03) enable validate;
grant select on nnr_file to tiptopgp;
grant update on nnr_file to tiptopgp;
grant delete on nnr_file to tiptopgp;
grant insert on nnr_file to tiptopgp;
grant index on nnr_file to public;
grant select on nnr_file to ods;
