/*
================================================================================
檔案代號:nnf_file
檔案名稱:短期融资应付票据资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nnf_file
(
nnf01       varchar2(20) NOT NULL,   /*融资单号                               */
                                     /*融資單號                               */
nnf02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
nnf03       date,                    /*到期日                                 */
nnf04f      number(20,6),            /*原币票面金额                           */
                                     /*原幣票面金額                           */
nnf04       number(20,6),            /*本币票面金额                           */
                                     /*本幣票面金額                           */
nnf05       varchar2(20),            /*付款银行                               */
                                     /*付款銀行                               */
nnf06       varchar2(20),            /*开票单号                               */
                                     /*開票單號                               */
nnf07       varchar2(20),            /*支票号码                               */
                                     /*支票號碼                               */
nnf08       varchar2(1),             /*种类                                   */
                                     /*種類 1.支票 2.CP本票       #5543       */
nnflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table nnf_file add  constraint nnf_pk primary key  (nnf01,nnf02) enable validate;
grant select on nnf_file to tiptopgp;
grant update on nnf_file to tiptopgp;
grant delete on nnf_file to tiptopgp;
grant insert on nnf_file to tiptopgp;
grant index on nnf_file to public;
grant select on nnf_file to ods;
