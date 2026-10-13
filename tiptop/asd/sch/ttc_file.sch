/*
================================================================================
檔案代號:ttc_file
檔案名稱:成品生产数量档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ttc_file
(
ttc01       number(5) NOT NULL,      /*年度                                   */
ttc02       varchar2(10) NOT NULL,   /*产品分类                               */
                                     /*產品分類                               */
ttc03       varchar2(40) NOT NULL,   /*成品料号                               */
                                     /*成品料號                               */
ttc04       number(15,3),            /*生产数量                               */
                                     /*生產數量                               */
ttcplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ttclegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table ttc_file add  constraint ttc_pk primary key  (ttc01,ttc02,ttc03) enable validate;
grant select on ttc_file to tiptopgp;
grant update on ttc_file to tiptopgp;
grant delete on ttc_file to tiptopgp;
grant insert on ttc_file to tiptopgp;
grant index on ttc_file to public;
grant select on ttc_file to ods;
