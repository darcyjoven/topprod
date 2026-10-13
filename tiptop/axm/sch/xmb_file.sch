/*
================================================================================
檔案代號:xmb_file
檔案名稱:特卖产品价格单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table xmb_file
(
xmb01       varchar2(6) NOT NULL,    /*价格条件编号                           */
                                     /*價格條件編號   Ex:FOB  CIF C與F CIF與C5*/
xmb02       varchar2(4) NOT NULL,    /*币种                                   */
                                     /*幣別                                   */
xmb03       date NOT NULL,           /*生效日期                               */
xmb04       varchar2(10) NOT NULL,   /*客户编号                               */
                                     /*客戶代號                               */
xmb05       varchar2(6) NOT NULL,    /*收款条件                               */
                                     /*收款條件                               */
xmb06       date,                    /*失效日期                               */
xmb07       number(5),               /*No Use                                 */
xmb08       date,                    /*No Use                                 */
xmb09       varchar2(10),            /*No Use                                 */
xmb10       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
xmbuser     varchar2(10),            /*资料所有者                             */
xmbgrup     varchar2(10),            /*资料所有部门                           */
xmbmodu     varchar2(10),            /*资料更改者                             */
xmbdate     date,                    /*最近更改日                             */
xmboriu     varchar2(10),            /*资料建立者                             */
xmborig     varchar2(10),            /*资料建立部门                           */
xmb00       varchar2(1) DEFAULT ' ' NOT NULL /*单据性质*/
);

alter table xmb_file add  constraint xmb_pk primary key  (xmb00,xmb01,xmb02,xmb03,xmb04,xmb05) enable validate;
grant select on xmb_file to tiptopgp;
grant update on xmb_file to tiptopgp;
grant delete on xmb_file to tiptopgp;
grant insert on xmb_file to tiptopgp;
grant index on xmb_file to public;
grant select on xmb_file to ods;
