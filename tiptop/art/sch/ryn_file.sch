/*
================================================================================
檔案代號:ryn_file
檔案名稱:采购类型变更资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ryn_file
(
ryn01       varchar2(20) DEFAULT ' ' NOT NULL, /*采购类型变更单单号*/
ryn02       varchar2(1) DEFAULT ' ' NOT NULL, /*变更类型*/
                                     /*Modify Type 1:Modify 2:Add             */
ryn03       varchar2(10) DEFAULT ' ' NOT NULL, /*变更营运中心*/
ryn04       varchar2(40) DEFAULT ' ' NOT NULL, /*产品编号*/
ryn05       varchar2(1),             /*采购类型                               */
                                     /*Purchase Type 1:Self-defined 2:PO 3:Provider 4:Purchase*/
ryn06       varchar2(10),            /*配送中心                               */
ryn07       varchar2(10),            /*主供应商                               */
ryn08       varchar2(1),             /*经营方式                               */
                                     /*Running Mode 1:Sell 2:Sell Goods On a Commission Basis (Cost) */
                                     /*3:Sell Goods On a Commission Basis (Deduction%) 4:Pool*/
ryn09       number(5,2),             /*可超交比率                             */
ryn10       number(15,3),            /*安全库存量                             */
ryn11       number(15,3),            /*再补货点量                             */
ryn12       varchar2(8),             /*采购多角贸易流程                       */
ryn13       varchar2(8),             /*退货多角贸易流程                       */
ryn14       varchar2(1),             /*有效否                                 */
ryn15       varchar2(10),            /*采购中心                               */
rynlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rynplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table ryn_file add  constraint ryn_pk primary key  (ryn01,ryn03,ryn04) enable validate;
grant select on ryn_file to tiptopgp;
grant update on ryn_file to tiptopgp;
grant delete on ryn_file to tiptopgp;
grant insert on ryn_file to tiptopgp;
grant index on ryn_file to public;
grant select on ryn_file to ods;
