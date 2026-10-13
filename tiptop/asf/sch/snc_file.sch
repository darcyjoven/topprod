/*
================================================================================
檔案代號:snc_file
檔案名稱:工单变更单备注档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table snc_file
(
snc01       varchar2(20) NOT NULL,   /*工单单号                               */
                                     /*工單單號                               */
snc02       number(5) NOT NULL,      /*变更序号                               */
                                     /*變更序號                               */
snc03       varchar2(40),            /*料件编号                               */
                                     /*料件編號                               */
snc08       varchar2(6),             /*作业编号                               */
                                     /*作業編號                               */
snc12       varchar2(4),             /*发料单位                               */
                                     /*發料單位                               */
snc05       number(5) NOT NULL,      /*行序                                   */
snc06       varchar2(255),           /*备注说明                               */
                                     /*備註說明                               */
sncplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
snclegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table snc_file add  constraint snc_pk primary key  (snc01,snc02,snc05) enable validate;
grant select on snc_file to tiptopgp;
grant update on snc_file to tiptopgp;
grant delete on snc_file to tiptopgp;
grant insert on snc_file to tiptopgp;
grant index on snc_file to public;
grant select on snc_file to ods;
