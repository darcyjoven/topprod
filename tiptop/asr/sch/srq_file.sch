/*
================================================================================
檔案代號:srq_file
檔案名稱:FQC联产品资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table srq_file
(
srq01       varchar2(20) NOT NULL,   /*来源单号                               */
srq02       number(5) NOT NULL,      /*来源项次                               */
srq021      number(5) NOT NULL,      /*检验批号                               */
                                     /*QC Lot # (QC Sequence by Lot)          */
srq03       number(5) NOT NULL,      /*项次                                   */
srq04       date,                    /*检验日期                               */
srq05       varchar2(40),            /*联产品料号                             */
srq06       number(15,3),            /*数量                                   */
srq08       varchar2(255),           /*备注                                   */
srq09       varchar2(10),            /*仓库                                   */
srq10       varchar2(10),            /*库位                                   */
srq11       varchar2(24),            /*批量                                   */
srq12       varchar2(4),             /*联产品单位                             */
srq13       number(20,8),            /*联产品对主件转换率                     */
srqplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
srqlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table srq_file add  constraint srq_pk primary key  (srq01,srq02,srq021,srq03) enable validate;
grant select on srq_file to tiptopgp;
grant update on srq_file to tiptopgp;
grant delete on srq_file to tiptopgp;
grant insert on srq_file to tiptopgp;
grant index on srq_file to public;
grant select on srq_file to ods;
