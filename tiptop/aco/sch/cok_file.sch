/*
================================================================================
檔案代號:cok_file
檔案名稱:材料进出囗明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cok_file
(
cok00       varchar2(20) NOT NULL,   /*海关手册                               */
cok01       varchar2(40) NOT NULL,   /*商品编号                               */
cok02       varchar2(4) NOT NULL,    /*单位                                   */
cok03       number(15,3),            /*合同进口                               */
cok04       number(15,3),            /*收货未结转                             */
cok05       number(15,3),            /*结转未收货                             */
cok06       number(15,3),            /*制造损耗                               */
cok07       number(15,3),            /*合同出口                               */
cok08       number(15,3),            /*送货未结转                             */
cok09       number(15,3),            /*结转未送货                             */
cok10       number(15,3),            /*委外加工折原料                         */
cok11       number(15,3),            /*在制工单折原料                         */
cok12       number(15,3),            /*原材料                                 */
cok13       number(15,3),            /*半成品折原料                           */
cok14       number(15,3),            /*库存成品折原料量                       */
cok15       number(15,3),            /*已结转已入库                           */
cok16       number(15,3),            /*已结转已出口                           */
cok17       number(15,3),            /*进口未退单                             */
cok18       number(15,3),            /*已出口未退单                           */
cok19       number(15,3),            /*短装数量                               */
cok20       number(15,3),            /*外销转内销                             */
cok21       number(15,3),            /*退运                                   */
cokplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
coklegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cok_file add  constraint cok_pk primary key  (cok00,cok01,cok02) enable validate;
grant select on cok_file to tiptopgp;
grant update on cok_file to tiptopgp;
grant delete on cok_file to tiptopgp;
grant insert on cok_file to tiptopgp;
grant index on cok_file to public;
grant select on cok_file to ods;
