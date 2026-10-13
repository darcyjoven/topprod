/*
================================================================================
檔案代號:ccx_file
檔案名稱:每月工单投入数量设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ccx_file
(
ccx01       varchar2(20) NOT NULL,   /*工单编号                               */
                                     /*工單編號                               */
ccx02       number(5) NOT NULL,      /*年度                                   */
ccx03       number(5) NOT NULL,      /*月份                                   */
ccx04       number(15,3) NOT NULL,   /*本月投入数量                           */
                                     /*本月投入數量                           */
ccxlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table ccx_file add  constraint ccx_pk primary key  (ccx01,ccx02,ccx03) enable validate;
grant select on ccx_file to tiptopgp;
grant update on ccx_file to tiptopgp;
grant delete on ccx_file to tiptopgp;
grant insert on ccx_file to tiptopgp;
grant index on ccx_file to public;
grant select on ccx_file to ods;
