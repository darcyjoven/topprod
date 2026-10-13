/*
================================================================================
檔案代號:bmf_file
檔案名稱:ECN 产品结构说明资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bmf_file
(
bmf01       varchar2(20) NOT NULL,   /*ECN单号                                */
                                     /*ECN單號                                */
bmf02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
bmf03       number(5) NOT NULL,      /*行序号                                 */
                                     /*行序號                                 */
                                     /*儲存該產品結構組合的項次說明的行序，可 */
                                     /*作為顯示時的順序。                     */
bmf04       varchar2(255),           /*说明                                   */
                                     /*說明                                   */
                                     /*儲存該產品結構組合的項次說明。         */
bmfplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bmflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table bmf_file add  constraint bmf_pk primary key  (bmf01,bmf02,bmf03) enable validate;
grant select on bmf_file to tiptopgp;
grant update on bmf_file to tiptopgp;
grant delete on bmf_file to tiptopgp;
grant insert on bmf_file to tiptopgp;
grant index on bmf_file to public;
grant select on bmf_file to ods;
