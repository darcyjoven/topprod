/*
================================================================================
檔案代號:bxe_file
檔案名稱:保税群组代码档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bxe_file
(
bxe01       varchar2(40) NOT NULL,   /*群组代码                               */
bxe02       varchar2(120),           /*群组品名                               */
bxe03       varchar2(120),           /*群组规格                               */
bxe04       varchar2(4),             /*群组单位                               */
bxe05       varchar2(20),            /*群组帐卡编号                           */
bxe06       varchar2(80),            /*工业局英文名称                         */
bxe07       varchar2(20),            /*ccc code                               */
                                     /*Chinese Commercial Codealso            */
                                     /*商品分類號列                           */
bxeacti     varchar2(1)              /*资料有效码                             */
);

alter table bxe_file add  constraint bxe_pk primary key  (bxe01) enable validate;
grant select on bxe_file to tiptopgp;
grant update on bxe_file to tiptopgp;
grant delete on bxe_file to tiptopgp;
grant insert on bxe_file to tiptopgp;
grant index on bxe_file to public;
grant select on bxe_file to ods;
