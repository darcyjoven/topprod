/*
================================================================================
檔案代號:bml_file
檔案名稱:元件厂牌资料明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bml_file
(
bml01       varchar2(40) NOT NULL,   /*元件料件编号                           */
                                     /*元件料件編號                           */
                                     /*儲存廠牌搭配的料件編號。               */
                                     /*主件料件編號需在料件基本資料主檔中。   */
bml02       varchar2(40) NOT NULL,   /*主件料件编号                           */
                                     /*主件料件編號                           */
                                     /*儲存該搭配料件在產品結構組合中上階的主 */
                                     /*件料件編號。                           */
                                     /* 'ALL'表示全部相關產品結構皆適用。     */
                                     /*主件料件編號需在料件基本資料主檔中。   */
bml03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
                                     /*儲存廠牌的搭配順序。                   */
bml04       varchar2(24),            /*元件厂牌                               */
                                     /*元件廠牌                               */
                                     /*儲存搭配廠牌的資料。                   */
bml05       varchar2(30),            /*核准文号                               */
                                     /*核准文號                               */
bml06       varchar2(10)             /*主要供应商                             */
                                     /*主要供應商                             */
);

alter table bml_file add  constraint bml_pk primary key  (bml01,bml02,bml03) enable validate;
grant select on bml_file to tiptopgp;
grant update on bml_file to tiptopgp;
grant delete on bml_file to tiptopgp;
grant insert on bml_file to tiptopgp;
grant index on bml_file to public;
grant select on bml_file to ods;
