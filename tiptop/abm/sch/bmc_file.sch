/*
================================================================================
檔案代號:bmc_file
檔案名稱:产品结构说明资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bmc_file
(
bmc01       varchar2(40) NOT NULL,   /*主件料件编号                           */
                                     /*主件料件編號                           */
                                     /*儲存該產品結構組合的主件料件編號。     */
                                     /*主件料件編號需在料件基本資料主檔中。   */
bmc02       number(5) NOT NULL,      /*组合项次                               */
                                     /*組合項次                               */
                                     /*儲存該產品結構組合的順序項次。         */
                                     /*可作為設定元件料件在該產品結構組合中的 */
                                     /*用料順序。                             */
bmc021      varchar2(40) NOT NULL,   /*元件料件编号                           */
                                     /*元件料件編號                           */
                                     /*儲存該產品結構組合的項次中使用的元件料 */
                                     /*件編號。                               */
                                     /*元件料件編號需在料件基本資料主檔中。   */
bmc03       date NOT NULL,           /*生效日期                               */
                                     /*儲存該產品結構組合的項次的有效期間之起 */
                                     /*始日期。                               */
bmc04       number(5) NOT NULL,      /*行序号                                 */
                                     /*行序號                                 */
                                     /*儲存該產品結構組合的項次說明的行序，可 */
                                     /*作為顯示時的順序。                     */
bmc05       varchar2(255),           /*说明                                   */
                                     /*說明                                   */
                                     /*儲存該產品結構組合的項次說明。         */
bmc06       varchar2(20) NOT NULL    /*特性代码                               */
);

alter table bmc_file add  constraint bmc_pk primary key  (bmc01,bmc02,bmc021,bmc03,bmc04,bmc06) enable validate;
grant select on bmc_file to tiptopgp;
grant update on bmc_file to tiptopgp;
grant delete on bmc_file to tiptopgp;
grant insert on bmc_file to tiptopgp;
grant index on bmc_file to public;
grant select on bmc_file to ods;
