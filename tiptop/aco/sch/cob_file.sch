/*
================================================================================
檔案代號:cob_file
檔案名稱:商品编号
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cob_file
(
cob01       varchar2(40) NOT NULL,   /*商品编号                               */
cob02       varchar2(120),           /*品名                                   */
cob021      varchar2(120),           /*规格                                   */
cob03       varchar2(4),             /*类型                                   */
cob04       varchar2(4),             /*合同单位                               */
cob05       number(16,8),            /*数量                                   */
cob06       varchar2(40),            /*电脑料号                               */
cob07       number(15,3),            /*No Use                                 */
cob08       varchar2(255),           /*备注                                   */
cob09       varchar2(20),            /*HS Code                                */
cob10       varchar2(10),            /*产销国                                 */
cobacti     varchar2(1),             /*资料有效码                             */
cobuser     varchar2(10),            /*资料所有者                             */
cobgrup     varchar2(10),            /*资料所有部门                           */
cobmodu     varchar2(10),            /*资料更改者                             */
cobdate     date,                    /*最近更改日                             */
cobud01     varchar2(255),           /*自订字段-Textedit                      */
cobud02     varchar2(40),            /*自订字段-文字                          */
cobud03     varchar2(40),            /*自订字段-文字                          */
cobud04     varchar2(40),            /*自订字段-文字                          */
cobud05     varchar2(40),            /*自订字段-文字                          */
cobud06     varchar2(40),            /*自订字段-文字                          */
cobud07     number(15,3),            /*自订字段-数值                          */
cobud08     number(15,3),            /*自订字段-数值                          */
cobud09     number(15,3),            /*自订字段-数值                          */
cobud10     number(10),              /*自订字段-整数                          */
cobud11     number(10),              /*自订字段-整数                          */
cobud12     number(10),              /*自订字段-整数                          */
cobud13     date,                    /*自订字段-日期                          */
cobud14     date,                    /*自订字段-日期                          */
cobud15     date,                    /*自订字段-日期                          */
coborig     varchar2(10),            /*资料建立部门                           */
coboriu     varchar2(10)             /*资料建立者                             */
);

alter table cob_file add  constraint cob_pk primary key  (cob01) enable validate;
grant select on cob_file to tiptopgp;
grant update on cob_file to tiptopgp;
grant delete on cob_file to tiptopgp;
grant insert on cob_file to tiptopgp;
grant index on cob_file to public;
grant select on cob_file to ods;
