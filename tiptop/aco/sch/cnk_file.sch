/*
================================================================================
檔案代號:cnk_file
檔案名稱:成品进出囗报关月统计档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cnk_file
(
cnk01       varchar2(20) NOT NULL,   /*手册编号                               */
cnk02       varchar2(40) NOT NULL,   /*商品编号                               */
cnk03       number(5) NOT NULL,      /*年度                                   */
cnk04       number(5) NOT NULL,      /*期别                                   */
cnk05       number(15,3),            /*本期直接出口数量                       */
cnk06       number(15,3),            /*本期国外退货数量                       */
cnk07       number(15,3),            /*本期转厂出口数量                       */
cnk08       number(15,3),            /*本期转厂退货数量                       */
cnk09       number(15,3),            /*本期内销出货数量                       */
cnk10       number(15,3),            /*本期内销退货数量                       */
cnk11       number(15,3),            /*No Use                                 */
cnk12       number(15,3),            /*本期期末数量                           */
cnk13       number(15,3),            /*No Use                                 */
cnk14       number(15,3),            /*No Use                                 */
cnk15       number(15,3),            /*No Use                                 */
cnkplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cnklegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cnk_file add  constraint cnk_pk primary key  (cnk01,cnk02,cnk03,cnk04) enable validate;
grant select on cnk_file to tiptopgp;
grant update on cnk_file to tiptopgp;
grant delete on cnk_file to tiptopgp;
grant insert on cnk_file to tiptopgp;
grant index on cnk_file to public;
grant select on cnk_file to ods;
