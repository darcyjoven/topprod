/*
================================================================================
檔案代號:oot_file
檔案名稱:应收/销退账款档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table oot_file
(
oot01       varchar2(20) NOT NULL,   /*销退帐款编号                           */
                                     /*銷退帳款編號                           */
                                     /*帳款類別 21.退貨折讓待抵               */
oot02       varchar2(10),            /*帐款客户编号                           */
                                     /*帳款客戶編號  occ01                    */
oot03       varchar2(20),            /*应收帐款编号                           */
                                     /*應收帳款編號                           */
oot04       number(20,6) NOT NULL,   /*原币税前金额                           */
                                     /*原幣未稅金額                           */
oot04x      number(20,6) NOT NULL,   /*原币税额                               */
                                     /*原幣稅額                               */
oot04t      number(20,6) NOT NULL,   /*原币含税金额                           */
                                     /*原幣含稅金額                           */
oot05       number(20,6) NOT NULL,   /*本币税前金额                           */
                                     /*本幣未稅金額                           */
oot05x      number(20,6) NOT NULL,   /*本币税额                               */
                                     /*本幣稅額                               */
oot05t      number(20,6) NOT NULL,   /*本币含税金额                           */
                                     /*本幣含稅金額                           */
oot06       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
ootlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index oot_02 on oot_file (oot03);
alter table oot_file add  constraint oot_pk primary key  (oot01) enable validate;
grant select on oot_file to tiptopgp;
grant update on oot_file to tiptopgp;
grant delete on oot_file to tiptopgp;
grant insert on oot_file to tiptopgp;
grant index on oot_file to public;
grant select on oot_file to ods;
