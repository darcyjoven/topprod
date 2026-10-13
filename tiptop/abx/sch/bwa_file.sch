/*
================================================================================
檔案代號:bwa_file
檔案名稱:保税库存盘点资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bwa_file
(
bwa01       varchar2(20) NOT NULL,   /*标签编号                               */
bwa02       varchar2(40),            /*料件编号                               */
                                     /*儲存該筆「現有庫存」資料的庫存明細之「 */
                                     /*料件編號」。                           */
bwa03       varchar2(10),            /*仓库                                   */
                                     /*儲存該筆「現有庫存」資料的庫存明細所屬 */
                                     /*之「倉庫別」。                         */
bwa04       varchar2(10),            /*库位                                   */
                                     /*儲存該筆「現有庫存」資料的庫存明細所屬 */
                                     /*之「儲位」。                           */
bwa05       varchar2(24),            /*批号                                   */
                                     /*儲存該筆「現有庫存」資料的庫存明細所屬 */
                                     /*之「存放批號」。                       */
bwa06       number(15,3),            /*盘存数量                               */
                                     /*庫存單位                               */
bwa011      number(5) NOT NULL,      /*盘点年度                               */
bwa17       varchar2(1),             /*验收区否                               */
bwa18       varchar2(255),           /*备注                                   */
bwaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bwalegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table bwa_file add  constraint bwa_pk primary key  (bwa01,bwa011) enable validate;
grant select on bwa_file to tiptopgp;
grant update on bwa_file to tiptopgp;
grant delete on bwa_file to tiptopgp;
grant insert on bwa_file to tiptopgp;
grant index on bwa_file to public;
grant select on bwa_file to ods;
