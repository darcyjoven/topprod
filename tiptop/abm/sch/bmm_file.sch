/*
================================================================================
檔案代號:bmm_file
檔案名稱:产品结构连产品资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bmm_file
(
bmm01       varchar2(40) NOT NULL,   /*主件料件编号                           */
                                     /*主件料件編號                           */
                                     /*儲存該產品結構組合的主件料件編號。     */
                                     /*主件料件編號需在料件基本資料主檔中。   */
bmm02       number(5) NOT NULL,      /*组合项次                               */
                                     /*組合項次                               */
                                     /*儲存該產品結構聯產品項次。             */
bmm03       varchar2(40),            /*联产品料件号编号                       */
                                     /*聯產品料件號編號                       */
                                     /*儲存該主件聯產品料號                   */
                                     /*元件料件編號需在料件基本資料主檔中。   */
bmm04       varchar2(4),             /*联产品单位                             */
                                     /*聯產品單位                             */
                                     /*儲存該聯產品的單位                     */
bmm05       varchar2(1),             /*有效否                                 */
                                     /*有效否(Y/N)                            */
bmm06       number(9,4),             /*分配率                                 */
bmm07       number(5)                /*No Use                                 */
);

alter table bmm_file add  constraint bmm_pk primary key  (bmm01,bmm02) enable validate;
grant select on bmm_file to tiptopgp;
grant update on bmm_file to tiptopgp;
grant delete on bmm_file to tiptopgp;
grant insert on bmm_file to tiptopgp;
grant index on bmm_file to public;
grant select on bmm_file to ods;
