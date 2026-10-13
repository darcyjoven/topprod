/*
================================================================================
檔案代號:obk_file
檔案名稱:产品客户档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table obk_file
(
obk01       varchar2(40) NOT NULL,   /*产品编号                               */
                                     /*產品編號                               */
obk02       varchar2(10) NOT NULL,   /*客户编号                               */
                                     /*客戶編號                               */
obk03       varchar2(40),            /*客户的产品编号                         */
                                     /*客戶的產品編號                         */
obk04       date,                    /*最近订单日                             */
                                     /*最近訂單日                             */
obk05       varchar2(4) NOT NULL,    /*最近订单币种                           */
                                     /*最近訂單幣別                           */
obk06       varchar2(4),             /*最近订单税种                           */
                                     /*最近訂單稅別                           */
obk07       varchar2(4),             /*最近订单销售单位                       */
                                     /*最近訂單銷售單位                       */
obk08       number(20,6),            /*最近订单单价                           */
                                     /*最近訂單單價                           */
obk09       number(15,3),            /*最近订单数量                           */
                                     /*最近訂單數量                           */
obk10       number(20,6),            /*最近订单金额                           */
                                     /*最近訂單金額                           */
obk11       varchar2(1),             /*检验否 Y:需入库检验 N:免检             */
obk12       varchar2(1),             /*检验程度 N.正常检验 T.加严检           */
obk13       varchar2(1),             /*检验水准 1.一般    2.特殊              */
obk14       varchar2(1),             /*级数                                   */
obkacti     varchar2(1),             /*资料有效码                             */
obkdate     date,                    /*最近更改日                             */
obkgrup     varchar2(10),            /*资料所有部门                           */
obkuser     varchar2(10),            /*资料所有者                             */
obkmodu     varchar2(10),            /*资料更改者                             */
obkorig     varchar2(10),            /*资料建立部门                           */
obkoriu     varchar2(10)             /*资料建立者                             */
);

alter table obk_file add  constraint obk_pk primary key  (obk01,obk02,obk05) enable validate;
grant select on obk_file to tiptopgp;
grant update on obk_file to tiptopgp;
grant delete on obk_file to tiptopgp;
grant insert on obk_file to tiptopgp;
grant index on obk_file to public;
grant select on obk_file to ods;
