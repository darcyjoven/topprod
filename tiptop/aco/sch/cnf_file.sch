/*
================================================================================
檔案代號:cnf_file
檔案名稱:材料进出口报关日统计档
檔案目的:记录每笔材料进出口报关之统计资料
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cnf_file
(
cnf01       varchar2(20) NOT NULL,   /*手册编号                               */
cnf02       varchar2(40) NOT NULL,   /*商品编号                               */
cnf03       date NOT NULL,           /*日期                                   */
cnf04       number(5),               /*No Use                                 */
cnf05       number(15,3),            /*本日直接进口数量                       */
cnf06       number(15,3),            /*本日直接耗用数量                       */
cnf07       number(15,3),            /*本日国外退货数量                       */
cnf08       number(15,3),            /*本日转厂进口数量                       */
cnf09       number(15,3),            /*本日转厂耗用数量                       */
cnf10       number(15,3),            /*本日转厂退货数量                       */
cnf11       number(15,3),            /*本日国内采购数量                       */
cnf12       number(15,3),            /*本日内购退货数量                       */
cnf13       number(15,3),            /*本日内销耗用数量                       */
cnf14       number(15,3),            /*本地手册转出数量                       */
cnf15       number(15,3),            /*本地手册转入数量                       */
cnf16       number(15,3),            /*本日报废数量                           */
cnf17       number(15,3),            /*本日结余数量                           */
cnf18       number(15,3),            /*No Use                                 */
cnf19       number(15,3),            /*No Use                                 */
cnf20       number(15,3),            /*No Use                                 */
cnfplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cnflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cnf_file add  constraint cnf_pk primary key  (cnf01,cnf02,cnf03) enable validate;
grant select on cnf_file to tiptopgp;
grant update on cnf_file to tiptopgp;
grant delete on cnf_file to tiptopgp;
grant insert on cnf_file to tiptopgp;
grant index on cnf_file to public;
grant select on cnf_file to ods;
