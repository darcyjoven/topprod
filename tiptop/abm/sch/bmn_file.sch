/*
================================================================================
檔案代號:bmn_file
檔案名稱:测试BOM联产品资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bmn_file
(
bmn01       varchar2(40) NOT NULL,   /*主件料件编号                           */
                                     /*主件料件編號                           */
                                     /*儲存該產品結構組合的主件料件編號。     */
                                     /*主件料件編號需存在測試料號中。         */
bmn011      varchar2(10) NOT NULL,   /*版本                                   */
bmn02       number(5) NOT NULL,      /*组合项次                               */
                                     /*組合項次                               */
                                     /*儲存該測試BOM聯產品項次。              */
bmn03       varchar2(40),            /*联产品料件编号                         */
                                     /*聯產品料件編號                         */
                                     /*儲存該主件聯產品料號                   */
                                     /*元件料件編號需在測試料號或料件基本資料中*/
bmn04       varchar2(4),             /*联产品单位                             */
                                     /*聯產品單位                             */
                                     /*儲存該聯產品的單位                     */
bmn05       varchar2(1),             /*有效否                                 */
                                     /*有效否(Y/N)                            */
bmn06       number(9,4),             /*分配率                                 */
bmn07       number(5)                /*No Use                                 */
);

alter table bmn_file add  constraint bmn_pk primary key  (bmn01,bmn011,bmn02) enable validate;
grant select on bmn_file to tiptopgp;
grant update on bmn_file to tiptopgp;
grant delete on bmn_file to tiptopgp;
grant insert on bmn_file to tiptopgp;
grant index on bmn_file to public;
grant select on bmn_file to ods;
