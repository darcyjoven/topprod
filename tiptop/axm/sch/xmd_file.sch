/*
================================================================================
檔案代號:xmd_file
檔案名稱:特卖产品数量价格折扣档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table xmd_file
(
xmd01       varchar2(6) NOT NULL,    /*价格条件                               */
                                     /*價格條件                               */
xmd02       varchar2(4) NOT NULL,    /*币种                                   */
                                     /*幣別                                   */
xmd03       date NOT NULL,           /*生效日期                               */
xmd04       varchar2(10) NOT NULL,   /*客户编号                               */
                                     /*客戶編號                               */
xmd05       varchar2(6) NOT NULL,    /*收款条件                               */
                                     /*收款條件                               */
xmd06       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
xmd07       varchar2(4) NOT NULL,    /*单位                                   */
                                     /*單位                                   */
xmd08       number(15,6) NOT NULL,   /*最低数量                               */
                                     /*最低數量                               */
xmd09       number(9,4)              /*折扣                                   */
);

alter table xmd_file add  constraint xmd_pk primary key  (xmd01,xmd02,xmd03,xmd04,xmd05,xmd06,xmd07,xmd08) enable validate;
grant select on xmd_file to tiptopgp;
grant update on xmd_file to tiptopgp;
grant delete on xmd_file to tiptopgp;
grant insert on xmd_file to tiptopgp;
grant index on xmd_file to public;
grant select on xmd_file to ods;
