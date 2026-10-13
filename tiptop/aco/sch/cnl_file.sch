/*
================================================================================
檔案代號:cnl_file
檔案名稱:材料进出囗报关月统计档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cnl_file
(
cnl01       varchar2(20) NOT NULL,   /*手册编号                               */
cnl02       varchar2(40) NOT NULL,   /*商品编号                               */
cnl03       number(5) NOT NULL,      /*年度                                   */
cnl04       number(5) NOT NULL,      /*期别                                   */
cnl05       number(15,3),            /*本期直接进口数量                       */
cnl06       number(15,3),            /*本期直接耗用数量                       */
cnl07       number(15,3),            /*本期国外退货数量                       */
cnl08       number(15,3),            /*本期转厂进口数量                       */
cnl09       number(15,3),            /*本期转厂耗用数量                       */
cnl10       number(15,3),            /*本期转厂退货数量                       */
cnl11       number(15,3),            /*本期国内采购数量                       */
cnl12       number(15,3),            /*本期内购退货数量                       */
cnl13       number(15,3),            /*本期内销耗用数量                       */
cnl14       number(15,3),            /*本期手册转出数量                       */
cnl15       number(15,3),            /*本期手册转入数量                       */
cnl16       number(15,3),            /*本期报废数量                           */
cnl17       number(15,3),            /*本期期末数量                           */
cnl18       number(15,3),            /*No Use                                 */
cnl19       number(15,3),            /*No Use                                 */
cnl20       number(15,3),            /*No Use                                 */
cnlplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cnllegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cnl_file add  constraint cnl_pk primary key  (cnl01,cnl02,cnl03,cnl04) enable validate;
grant select on cnl_file to tiptopgp;
grant update on cnl_file to tiptopgp;
grant delete on cnl_file to tiptopgp;
grant insert on cnl_file to tiptopgp;
grant index on cnl_file to public;
grant select on cnl_file to ods;
