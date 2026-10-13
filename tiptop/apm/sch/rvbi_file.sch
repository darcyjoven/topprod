/*
================================================================================
檔案代號:rvbi_file
檔案名稱:收货单单身档(行业别档)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rvbi_file
(
rvbi01      varchar2(20) DEFAULT ' ' NOT NULL, /*收货单号*/
rvbi02      number(5) DEFAULT '0' NOT NULL, /*收货项次*/
rvbiicd01   varchar2(20),            /*订单单号                               */
rvbiicd02   number(5),               /*订单项次                               */
rvbiicd03   varchar2(10),            /*ICD作业编号                            */
rvbiicd04   varchar2(1),             /*New Code                               */
rvbiicd05   varchar2(1),             /*Low Yield                              */
rvbiicd06   number(15,3),            /*不良品数                               */
rvbiicd07   number(15,3),            /*报废数量                               */
rvbiicd08   varchar2(80),            /*Datecode                               */
rvbiicd09   varchar2(1),             /*回货否                                 */
rvbiicd10   varchar2(1),             /*Matel Layer                            */
rvbiicd11   varchar2(20),            /*Tap Reel                               */
rvbiicd12   varchar2(10),            /*Wafer Site                             */
rvbiicd13   varchar2(1),             /*委外TKY非最终站否(Y:委外TKY非          */
rvbiicd14   varchar2(40),            /*内编母体料号                           */
rvbiicd15   varchar2(40),            /*最终料号                               */
rvbiicd16   varchar2(24),            /*母批                                   */
rvbiicd17   varchar2(10),            /*TLY作业编号(存原委外工单之作           */
rvbiplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
rvbilegal   varchar2(10) NOT NULL,   /*所属法人                               */
rvbislk01   varchar2(40),            /*料件编号                               */
rvbislk02   number(5)                /*项次                                   */
);

alter table rvbi_file add  constraint rvbi_pk primary key  (rvbi01,rvbi02) enable validate;
grant select on rvbi_file to tiptopgp;
grant update on rvbi_file to tiptopgp;
grant delete on rvbi_file to tiptopgp;
grant insert on rvbi_file to tiptopgp;
grant index on rvbi_file to public;
grant select on rvbi_file to ods;
