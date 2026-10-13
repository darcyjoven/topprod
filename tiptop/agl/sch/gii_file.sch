/*
================================================================================
檔案代號:gii_file
檔案名稱:采购料明细档 (单身)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gii_file
(
gii01       varchar2(6) NOT NULL,    /*预测编号                               */
                                     /*預測編號                               */
gii02       varchar2(1) NOT NULL,    /*类型                                   */
                                     /*類別                                   */
gii03       varchar2(10) NOT NULL,   /*部门编号                               */
                                     /*部門編號                               */
gii04       number(5) NOT NULL,      /*预测年度                               */
                                     /*預測年度                               */
gii05       number(5) NOT NULL,      /*预测期别                               */
                                     /*預測期別                               */
gii06       number(20,6),            /*预测金额                               */
                                     /*預測金額                               */
gii07       number(9,4)              /*机率                                   */
                                     /*機率                                   */
);

alter table gii_file add  constraint gii_pk primary key  (gii01,gii02,gii03,gii04,gii05) enable validate;
grant select on gii_file to tiptopgp;
grant update on gii_file to tiptopgp;
grant delete on gii_file to tiptopgp;
grant insert on gii_file to tiptopgp;
grant index on gii_file to public;
grant select on gii_file to ods;
