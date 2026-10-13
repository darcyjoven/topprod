/*
================================================================================
檔案代號:smc_file
檔案名稱:单位换算资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table smc_file
(
smc01       varchar2(4) NOT NULL,    /*'来源'计算单位                         */
                                     /*'來源'計算單位                         */
                                     /*source unit of measure                 */
smc02       varchar2(4) NOT NULL,    /*'目的'计算单位                         */
                                     /*'目的'計算單位                         */
                                     /*target unit of measure                 */
smc03       number(15,3),            /*'来源单位'兑换数量                     */
                                     /*'來源單位'兌換數量                     */
                                     /*source changing quantity               */
smc04       number(15,3),            /*'目的单位'兑换数量                     */
                                     /*'目的單位'兌換數量                     */
                                     /*target changing quantity               */
smc05       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
                                     /*comment                                */
smcacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*Active/Inactive Flag                   */
smcpos      varchar2(1) DEFAULT 'N' NOT NULL /*已传POS否*/
);

alter table smc_file add  constraint smc_pk primary key  (smc01,smc02) enable validate;
grant select on smc_file to tiptopgp;
grant update on smc_file to tiptopgp;
grant delete on smc_file to tiptopgp;
grant insert on smc_file to tiptopgp;
grant index on smc_file to public;
grant select on smc_file to ods;
