/*
================================================================================
檔案代號:ogc_file
檔案名稱:出货单身库存异动明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ogc_file
(
ogc01       varchar2(20) NOT NULL,   /*出货单号                               */
                                     /*出貨單號                               */
ogc03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
ogc09       varchar2(10) NOT NULL,   /*出货仓库编号                           */
                                     /*出貨倉庫編號                           */
ogc091      varchar2(10) NOT NULL,   /*出货库位编号                           */
                                     /*出貨儲位編號                           */
ogc092      varchar2(24) NOT NULL,   /*出货批号                               */
                                     /*出貨批號   No.+024                     */
ogc12       number(15,3) NOT NULL,   /*数量                                   */
                                     /*數量 (依銷售單位)                      */
ogc15       varchar2(4),             /*库存明细单位由厂/仓/位/批自            */
                                     /*庫存明細單位(img09)由廠/倉/儲/批自動得出*/
ogc15_fac   number(20,8) NOT NULL,   /*销售/库存明细单位换算率                */
                                     /*銷售/庫存明細單位換算率 (To ogc15)     */
ogc16       number(15,3) NOT NULL,   /*数量                                   */
                                     /*數量 (依庫存明細單位)                  */
ogc17       varchar2(40) NOT NULL,   /*产品编号                               */
ogc18       number(5),               /*多仓位批序号                           */
ogcplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ogclegal    varchar2(10) NOT NULL,   /*所属法人                               */
ogc13       number(15,3) DEFAULT '0' NOT NULL /*簽退數量*/
);

alter table ogc_file add  constraint ogc_pk primary key  (ogc01,ogc03,ogc09,ogc091,ogc092,ogc17) enable validate;
grant select on ogc_file to tiptopgp;
grant update on ogc_file to tiptopgp;
grant delete on ogc_file to tiptopgp;
grant insert on ogc_file to tiptopgp;
grant index on ogc_file to public;
grant select on ogc_file to ods;
