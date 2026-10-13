/*
================================================================================
檔案代號:rty_file
檔案名稱:商品采购类型资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rty_file
(
rty01       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心代码*/
rty02       varchar2(40) DEFAULT ' ' NOT NULL, /*产品编号*/
rty03       varchar2(1),             /*采购类型                               */
                                     /*PO Type                                */
                                     /*1:Indent 2:Unit PO Immediacy Provide   */
                                     /*3:Unit PO-Distribute 4:Monopoly Purchase and Purchase*/
rty04       varchar2(10),            /*配送中心                               */
rty05       varchar2(10),            /*主供应商                               */
rty06       varchar2(1),             /*经营方式                               */
                                     /*Running Mode 1:Sell 2:Sell Goods On a Commission Basis (Cost) */
                                     /*3:Sell Goods On a Commission Basis (Deduction%) 4:Pool*/
rty07       number(5),               /*可超交比率%                            */
rty08       number(5),               /*安全库存量                             */
rty09       number(5),               /*再补货点量                             */
rty10       varchar2(8),             /*采购多角贸易流程                       */
rty11       varchar2(8),             /*退货多角贸易流程                       */
rty12       varchar2(10),            /*采购中心                               */
rtyacti     varchar2(1),             /*有效否                                 */
rty13       number(15,3),            /*最高存量                               */
rty14       varchar2(10),            /*预设成本仓                             */
rty15       varchar2(10)             /*预设非成本仓                           */
);

alter table rty_file add  constraint rty_pk primary key  (rty01,rty02) enable validate;
grant select on rty_file to tiptopgp;
grant update on rty_file to tiptopgp;
grant delete on rty_file to tiptopgp;
grant insert on rty_file to tiptopgp;
grant index on rty_file to public;
grant select on rty_file to ods;
