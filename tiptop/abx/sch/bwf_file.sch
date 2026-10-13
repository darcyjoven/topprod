/*
================================================================================
檔案代號:bwf_file
檔案名稱:保税原料盘存统计档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table bwf_file
(
bwf01       varchar2(40) NOT NULL,   /*料件编号                               */
bwf02       number(15,3),            /*原料仓盘存数量                         */
bwf03       number(15,3),            /*生产线上原料类型                       */
bwf04       number(15,3),            /*生产线上成品,半成品折合                */
bwf05       number(15,3),            /*成品仓折合                             */
bwf011      number(5) NOT NULL,      /*年度                                   */
bwf06       number(15,3),            /*生产线上半成品折合                     */
bwf07       number(15,3),            /*生产线上成品折合                       */
bwf08       number(15,3),            /*托外工单折合原料数                     */
bwf09       number(15,3),            /*仓库半成品折合原料数                   */
bwfplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bwflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table bwf_file add  constraint bwf_pk primary key  (bwf01,bwf011) enable validate;
grant select on bwf_file to tiptopgp;
grant update on bwf_file to tiptopgp;
grant delete on bwf_file to tiptopgp;
grant insert on bwf_file to tiptopgp;
grant index on bwf_file to public;
grant select on bwf_file to ods;
