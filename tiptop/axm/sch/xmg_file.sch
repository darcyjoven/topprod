/*
================================================================================
檔案代號:xmg_file
檔案名稱:产品数量价格折扣档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table xmg_file
(
xmg01       varchar2(6) NOT NULL,    /*价格条件编号                           */
                                     /*價格條件編號                           */
xmg02       varchar2(4) NOT NULL,    /*币种                                   */
                                     /*幣別                                   */
xmg03       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
xmg04       varchar2(4) NOT NULL,    /*单位                                   */
                                     /*單位                                   */
xmg05       date NOT NULL,           /*生效日期                               */
xmg06       number(15,6) NOT NULL,   /*最低数量                               */
                                     /*最低數量                               */
xmg07       number(9,4)              /*折扣                                   */
);

alter table xmg_file add  constraint xmg_pk primary key  (xmg01,xmg02,xmg03,xmg04,xmg05,xmg06) enable validate;
grant select on xmg_file to tiptopgp;
grant update on xmg_file to tiptopgp;
grant delete on xmg_file to tiptopgp;
grant insert on xmg_file to tiptopgp;
grant index on xmg_file to public;
grant select on xmg_file to ods;
