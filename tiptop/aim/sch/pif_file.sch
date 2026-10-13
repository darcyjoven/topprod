/*
================================================================================
檔案代號:pif_file
檔案名稱:盘点过账错误信息档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table pif_file
(
pif01       varchar2(20),            /*标签编号                               */
                                     /*標籤編號                               */
pif02       varchar2(40),            /*料件编号                               */
                                     /*料件編號                               */
pif03       varchar2(1500),          /*错误信息                               */
                                     /*錯誤訊息                               */
pifplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
piflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

grant select on pif_file to tiptopgp;
grant update on pif_file to tiptopgp;
grant delete on pif_file to tiptopgp;
grant insert on pif_file to tiptopgp;
grant index on pif_file to public;
grant select on pif_file to ods;
