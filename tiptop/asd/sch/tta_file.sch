/*
================================================================================
檔案代號:tta_file
檔案名稱:单位成本分析档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table tta_file
(
tta01       number(5) NOT NULL,      /*年度                                   */
tta02       varchar2(10) NOT NULL,   /*产品分类                               */
                                     /*產品分類                               */
tta03       number(15,3),            /*生产数量                               */
                                     /*生產數量                               */
tta04       number(20,6),            /*直接材料成本                           */
tta05       number(20,6),            /*直接人工成本                           */
tta06       number(20,6),            /*间接制造费用                           */
                                     /*間接製造費用                           */
tta07       number(20,6),            /*其他制造费用                           */
                                     /*其他製造費用                           */
tta08       number(20,6),            /*分摊后直接材料成本                     */
                                     /*分攤後直接材料成本                     */
tta09       number(20,6),            /*分摊后直接人工成本                     */
                                     /*分攤後直接人工成本                     */
tta10       number(20,6),            /*分摊后间接制造费用                     */
                                     /*分攤後間接製造費用                     */
tta11       number(20,6),            /*分摊后其他制造费用                     */
                                     /*分攤後其他製造費用                     */
ttaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ttalegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table tta_file add  constraint tta_pk primary key  (tta01,tta02) enable validate;
grant select on tta_file to tiptopgp;
grant update on tta_file to tiptopgp;
grant delete on tta_file to tiptopgp;
grant insert on tta_file to tiptopgp;
grant index on tta_file to public;
grant select on tta_file to ods;
