/*
================================================================================
檔案代號:cjp_file
檔案名稱:联产品入库比例档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cjp_file
(
cjp01       varchar2(40) NOT NULL,   /*主件料件编号                           */
                                     /*主件料件編號                           */
                                     /*儲存該產品結構組合的主件料件編號。     */
                                     /*主件料件編號需在料件基本資料主檔中。   */
cjp02       number(5) NOT NULL,      /*年度                                   */
cjp03       number(5) NOT NULL,      /*月份                                   */
cjp04       varchar2(40) NOT NULL,   /*联产品料件号编号                       */
                                     /*聯產品料件號編號                       */
                                     /*儲存該主件聯產品料號                   */
                                     /*元件料件編號需在料件基本資料主檔中。   */
cjp05       varchar2(4),             /*联产品单位                             */
                                     /*聯產品單位                             */
                                     /*儲存該聯產品的單位                     */
cjp06       number(9,4)              /*分配率                                 */
);

alter table cjp_file add  constraint cjp_pk primary key  (cjp01,cjp02,cjp03,cjp04) enable validate;
grant select on cjp_file to tiptopgp;
grant update on cjp_file to tiptopgp;
grant delete on cjp_file to tiptopgp;
grant insert on cjp_file to tiptopgp;
grant index on cjp_file to public;
grant select on cjp_file to ods;
