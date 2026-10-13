/*
================================================================================
檔案代號:boa_file
檔案名稱:上阶主件对元件群组关系档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table boa_file
(
boa01       varchar2(40) NOT NULL,   /*上阶主件编号                           */
                                     /*上階主件編號                           */
                                     /*儲存可做SET替代的主件料號。            */
                                     /*主件料號需在料件基本資料主檔中。       */
boa02       number(5) NOT NULL,      /*元件群组                               */
                                     /*元件群組                               */
                                     /*儲存該上階組件可以做SET替代的組合群組  */
                                     /*序號                                   */
boa03       varchar2(40) NOT NULL,   /*元件料件编号                           */
                                     /*元件料件編號                           */
                                     /*儲存該元件群組的元件料號。             */
boa04       varchar2(6) NOT NULL,    /*作业编号                               */
                                     /*作業編號                               */
                                     /*儲存該上階主件料號在工單備料中，預期投入*/
                                     /*生產的作業所屬作業編號                 */
boa05       varchar2(4) NOT NULL,    /*发料单位                               */
                                     /*發料單位                               */
                                     /*儲存該上階主件料號在工單備料中的發料單位*/
boa06       date,                    /*生效日期                               */
                                     /*儲存該元件群組SET替代的生效日期。      */
boa07       date,                    /*失效日期                               */
                                     /*儲存該元件群組SET替代的生效日期。      */
boa08       varchar2(80)             /*说明                                   */
                                     /*說明                                   */
                                     /*此欄位為開窗選擇替代群組時的提示資料   */
);

alter table boa_file add  constraint boa_pk primary key  (boa01,boa02,boa03,boa04,boa05) enable validate;
grant select on boa_file to tiptopgp;
grant update on boa_file to tiptopgp;
grant delete on boa_file to tiptopgp;
grant insert on boa_file to tiptopgp;
grant index on boa_file to public;
grant select on boa_file to ods;
