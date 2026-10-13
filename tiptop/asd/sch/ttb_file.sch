/*
================================================================================
檔案代號:ttb_file
檔案名稱:直接材料明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ttb_file
(
ttb01       number(5) NOT NULL,      /*年度                                   */
ttb02       varchar2(10) NOT NULL,   /*产品分类                               */
                                     /*產品分類                               */
ttb03       varchar2(40) NOT NULL,   /*料号                                   */
                                     /*料號                                   */
ttb04       number(20,8),            /*单位用量                               */
                                     /*單位用量                               */
ttb05       number(15,3),            /*使用数量                               */
                                     /*使用數量                               */
ttb06       number(20,6),            /*标准单位成本                           */
                                     /*標準單位成本                           */
ttb07       number(20,6),            /*分摊前直接材料成本                     */
                                     /*分攤前直接材料成本                     */
ttb08       number(20,6),            /*分摊后直接材料成本                     */
                                     /*分攤後直接材料成本                     */
ttbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ttblegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table ttb_file add  constraint ttb_pk primary key  (ttb01,ttb02,ttb03) enable validate;
grant select on ttb_file to tiptopgp;
grant update on ttb_file to tiptopgp;
grant delete on ttb_file to tiptopgp;
grant insert on ttb_file to tiptopgp;
grant index on ttb_file to public;
grant select on ttb_file to ods;
