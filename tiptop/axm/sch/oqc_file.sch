/*
================================================================================
檔案代號:oqc_file
檔案名稱:人工/制费估价资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oqc_file
(
oqc01       varchar2(20) NOT NULL,   /*估价单号                               */
                                     /*估價單號                               */
oqc02       number(5) NOT NULL,      /*序号                                   */
                                     /*序號(可利用參數 oaz25 指定產生時之間隔數*/
oqc03       varchar2(6),             /*作业编号                               */
                                     /*作業編號(可為 MISC)                    */
oqc031      varchar2(80),            /*作业名称                               */
                                     /*作業名稱                               */
oqc04       varchar2(40),            /*生产料号                               */
                                     /*生產料號                               */
oqc05       number(15,3),            /*生产数量                               */
                                     /*生產數量                               */
oqc06       varchar2(10),            /*工作中心                               */
oqc07       number(9,3),             /*人工工时                               */
                                     /*人工工時                               */
oqc08       number(9,3),             /*机器工时                               */
                                     /*機器工時                               */
oqc09       number(12,3),            /*直接人工工资率                         */
                                     /*直接人工工資率                         */
oqc10       number(12,3),            /*间接制费分摊率                         */
                                     /*間接製費分攤率                         */
oqc11       number(20,6),            /*本弊金额(人工)                         */
                                     /*本弊金額(人工)                         */
oqc12       number(20,6),            /*本弊金额(制费)                         */
                                     /*本弊金額(製費)                         */
oqc13       number(20,6),            /*估价金额                               */
                                     /*估價金額(人工)                         */
oqc14       number(20,6),            /*估价金额                               */
                                     /*估價金額(製費)                         */
oqc15       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
oqcplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oqclegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table oqc_file add  constraint oqc_pk primary key  (oqc01,oqc02) enable validate;
grant select on oqc_file to tiptopgp;
grant update on oqc_file to tiptopgp;
grant delete on oqc_file to tiptopgp;
grant insert on oqc_file to tiptopgp;
grant index on oqc_file to public;
grant select on oqc_file to ods;
