/*
================================================================================
檔案代號:xmc_file
檔案名稱:特卖产品价格单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table xmc_file
(
xmc01       varchar2(6) NOT NULL,    /*价格条件                               */
                                     /*價格條件                               */
xmc02       varchar2(4) NOT NULL,    /*币种                                   */
                                     /*幣別                                   */
xmc03       date NOT NULL,           /*生效日期                               */
xmc04       varchar2(10) NOT NULL,   /*客户编号                               */
                                     /*客戶編號                               */
xmc05       varchar2(6) NOT NULL,    /*收款条件                               */
                                     /*收款條件                               */
xmc06       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
xmc07       varchar2(4) NOT NULL,    /*单位                                   */
                                     /*單位                                   */
xmc08       number(20,6),            /*单价                                   */
                                     /*單價                                   */
xmc09       number(9,4)              /*折扣                                   */
);

alter table xmc_file add  constraint xmc_pk primary key  (xmc01,xmc02,xmc03,xmc04,xmc05,xmc06,xmc07) enable validate;
grant select on xmc_file to tiptopgp;
grant update on xmc_file to tiptopgp;
grant delete on xmc_file to tiptopgp;
grant insert on xmc_file to tiptopgp;
grant index on xmc_file to public;
grant select on xmc_file to ods;
