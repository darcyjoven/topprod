/*
================================================================================
檔案代號:xmf_file
檔案名稱:产品价格单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table xmf_file
(
xmf01       varchar2(6) NOT NULL,    /*价格条件编号                           */
                                     /*價格條件編號   Ex:FOB  CIF C與F CIF與C5*/
xmf02       varchar2(4) NOT NULL,    /*币种                                   */
                                     /*幣別                                   */
xmf03       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
xmf04       varchar2(4) NOT NULL,    /*单位                                   */
                                     /*單位                                   */
xmf05       date NOT NULL,           /*生效日期                               */
xmf06       date,                    /*No Use                                 */
xmf07       number(20,6),            /*税前单价                               */
                                     /*訂價                                   */
xmf08       number(15,3),            /*折扣                                   */
ta_xmf01    varchar2(10),            /*客户编号                               */
ta_xmf02    varchar2(4) NOT NULL,    /*税种码                                 */
ta_xmf03    number(20,6),            /*含税单价                               */
ta_xmf04    number(20,6),            /*SMT税前材料价                          */
ta_xmf05    number(20,6)             /*SMT税前组装单价                        */
);

alter table xmf_file add  constraint xmf_pk primary key  (xmf01,xmf02,xmf03,xmf04,xmf05,ta_xmf02) enable validate;
grant select on xmf_file to tiptopgp;
grant update on xmf_file to tiptopgp;
grant delete on xmf_file to tiptopgp;
grant insert on xmf_file to tiptopgp;
grant index on xmf_file to public;
grant select on xmf_file to ods;
