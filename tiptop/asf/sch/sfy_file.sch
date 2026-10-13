/*
================================================================================
檔案代號:sfy_file
檔案名稱:自动生成工单关系档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sfy_file
(
sfy01       varchar2(20),            /*来源工单编号                           */
                                     /*來源工單編號                           */
                                     /*Parent Work Order                      */
sfy02       varchar2(20),            /*上阶工单编号                           */
                                     /*上階工單編號                           */
                                     /*Source Work Order                      */
sfy03       varchar2(20),            /*生成工单编号                           */
                                     /*產生工單編號                           */
                                     /*Target Work Order                      */
sfyplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sfylegal    varchar2(10) NOT NULL    /*所属法人                               */
);

grant select on sfy_file to tiptopgp;
grant update on sfy_file to tiptopgp;
grant delete on sfy_file to tiptopgp;
grant insert on sfy_file to tiptopgp;
grant index on sfy_file to public;
grant select on sfy_file to ods;
