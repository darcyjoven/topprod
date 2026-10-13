/*
================================================================================
檔案代號:ogg_file
檔案名稱:出货单身库存异动明细档  for 双单位
檔案目的:储存出货产品的多库位多单位异动明细资料
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ogg_file
(
ogg01       varchar2(20) NOT NULL,   /*出货单号                               */
ogg03       number(5) NOT NULL,      /*项次                                   */
ogg09       varchar2(10) NOT NULL,   /*仓库                                   */
ogg091      varchar2(10) NOT NULL,   /*库位                                   */
ogg092      varchar2(24) NOT NULL,   /*批号                                   */
ogg10       varchar2(4) NOT NULL,    /*出货单位                               */
ogg12       number(15,3) NOT NULL,   /*销售数量                               */
ogg15       varchar2(4),             /*库存明细单位                           */
ogg15_fac   number(20,8) NOT NULL,   /*出货单位/库存明细单位转换率            */
ogg16       number(15,3) NOT NULL,   /*数量 (依库存明细单位)                  */
ogg20       number(5),               /*标识 1.第一单位  2.第二单位            */
ogg17       varchar2(40) DEFAULT ' ' NOT NULL, /*产品编号*/
ogg18       number(5),               /*多仓位批序号                           */
oggplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ogglegal    varchar2(10) NOT NULL,   /*所属法人                               */
ogg13       number(15,3) DEFAULT '0' NOT NULL /*簽退數量*/
);

alter table ogg_file add  constraint ogg_pk primary key  (ogg01,ogg03,ogg09,ogg091,ogg092,ogg10,ogg17) enable validate;
grant select on ogg_file to tiptopgp;
grant update on ogg_file to tiptopgp;
grant delete on ogg_file to tiptopgp;
grant insert on ogg_file to tiptopgp;
grant index on ogg_file to public;
grant select on ogg_file to ods;
