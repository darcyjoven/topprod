/*
================================================================================
檔案代號:smd_file
檔案名稱:料件单位换算资料档   PART'S UNIT OF
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table smd_file
(
smd01       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
                                     /*part number                            */
smd02       varchar2(4) NOT NULL,    /*'来源'计算单位                         */
                                     /*'來源'計算單位                         */
                                     /*source unit of measure                 */
smd03       varchar2(4) NOT NULL,    /*'目的'计算单位                         */
                                     /*'目的'計算單位                         */
                                     /*traget unit of measure                 */
smd04       number(15,3),            /*'来源单位'兑换数量                     */
                                     /*'來源單位'兌換數量                     */
                                     /*source changing quantity               */
smd06       number(15,3),            /*'目的单位'兑换数量                     */
                                     /*'目的單位'兌換數量                     */
                                     /*target changing quantity               */
smd05       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
                                     /*comment                                */
smdacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*Active/Inactive Flag                   */
smdpos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
smddate     date                     /*最近更改日                             */
);

alter table smd_file add  constraint smd_pk primary key  (smd01,smd02,smd03) enable validate;
grant select on smd_file to tiptopgp;
grant update on smd_file to tiptopgp;
grant delete on smd_file to tiptopgp;
grant insert on smd_file to tiptopgp;
grant index on smd_file to public;
grant select on smd_file to ods;
