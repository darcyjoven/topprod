/*
================================================================================
檔案代號:tas_file
檔案名稱:会计科目币种每日余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table tas_file
(
tas00       varchar2(5) NOT NULL,    /*帐套编号                               */
                                     /*帳別編號                               */
tas01       varchar2(24) NOT NULL,   /*科目编号                               */
                                     /*科目編號                               */
tas02       date NOT NULL,           /*日期                                   */
tas04       number(20,6),            /*借方金额                               */
                                     /*借方金額                               */
tas05       number(20,6),            /*贷方金额                               */
                                     /*貸方金額                               */
tas06       number(10),              /*借方笔数                               */
                                     /*借方筆數                               */
tas07       number(10),              /*贷方笔数                               */
                                     /*貸方筆數                               */
tas08       varchar2(4) NOT NULL,    /*币种                                   */
                                     /*幣別                           02/02/26*/
tas09       number(20,6),            /*原币借方金额                           */
                                     /*原幣借方金額                   02/02/26*/
tas10       number(20,6),            /*原币贷方金额                           */
                                     /*原幣貸方金額                   02/02/26*/
taslegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table tas_file add  constraint tas_pk primary key  (tas01,tas02,tas08,tas00) enable validate;
grant select on tas_file to tiptopgp;
grant update on tas_file to tiptopgp;
grant delete on tas_file to tiptopgp;
grant insert on tas_file to tiptopgp;
grant index on tas_file to public;
grant select on tas_file to ods;
