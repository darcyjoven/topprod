/*
================================================================================
檔案代號:cne_file
檔案名稱:成品进出口报关日统计档
檔案目的:记录每笔成品进出口报关之统计资料
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cne_file
(
cne01       varchar2(20) NOT NULL,   /*手册编号                               */
cne02       varchar2(40) NOT NULL,   /*商品编号                               */
cne03       date NOT NULL,           /*日期                                   */
cne04       number(5),               /*No Use                                 */
cne05       number(15,3),            /*本日直接出口数量                       */
cne06       number(15,3),            /*本日国外退货数量                       */
cne07       number(15,3),            /*本日转厂出口数量                       */
cne08       number(15,3),            /*本日转厂退货数量                       */
cne09       number(15,3),            /*本日内销出货数量                       */
cne10       number(15,3),            /*本日内销退货数量                       */
cne11       number(15,3),            /*No Use                                 */
cne12       number(15,3),            /*本日结余数量                           */
cne13       number(15,3),            /*No Use                                 */
cne14       number(15,3),            /*No Use                                 */
cne15       number(15,3),            /*No Use                                 */
cneplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cnelegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cne_file add  constraint cne_pk primary key  (cne01,cne02,cne03) enable validate;
grant select on cne_file to tiptopgp;
grant update on cne_file to tiptopgp;
grant delete on cne_file to tiptopgp;
grant insert on cne_file to tiptopgp;
grant index on cne_file to public;
grant select on cne_file to ods;
