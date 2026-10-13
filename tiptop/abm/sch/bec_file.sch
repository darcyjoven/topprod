/*
================================================================================
檔案代號:bec_file
檔案名稱:工程产品结构说明资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bec_file
(
bec01       varchar2(40) NOT NULL,   /*主件料件编号                           */
                                     /*主件料件編號                           */
                                     /*儲存該產品結構組合的主件料件編號。     */
                                     /*主件料件編號需在料件基本資料主檔中。   */
bec011      varchar2(10) NOT NULL,   /*版本                                   */
bec02       number(5) NOT NULL,      /*组合项次                               */
                                     /*組合項次                               */
                                     /*儲存該產品結構組合的順序項次。         */
                                     /*可作為設定元件料件在該產品結構組合中的 */
                                     /*用料順序。                             */
bec021      varchar2(40) NOT NULL,   /*元件料件编号                           */
                                     /*元件料件編號                           */
                                     /*儲存該產品結構組合的項次中使用的元件料 */
                                     /*件編號。                               */
                                     /*元件料件編號需在料件基本資料主檔中。   */
bec03       date,                    /*No Use                                 */
bec04       number(5) NOT NULL,      /*行序号                                 */
                                     /*行序號                                 */
                                     /*儲存該產品結構組合的項次說明的行序，可 */
                                     /*作為顯示時的順序。                     */
bec05       varchar2(255),           /*说明                                   */
                                     /*說明                                   */
                                     /*儲存該產品結構組合的項次說明。         */
bec06       varchar2(20) NOT NULL    /*特性代码                               */
);

alter table bec_file add  constraint bec_pk primary key  (bec01,bec011,bec02,bec021,bec04,bec06) enable validate;
grant select on bec_file to tiptopgp;
grant update on bec_file to tiptopgp;
grant delete on bec_file to tiptopgp;
grant insert on bec_file to tiptopgp;
grant index on bec_file to public;
grant select on bec_file to ods;
