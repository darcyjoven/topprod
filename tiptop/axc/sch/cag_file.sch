/*
================================================================================
檔案代號:cag_file
檔案名稱:工单转入资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cag_file
(
cag01       varchar2(20) NOT NULL,   /*转入工单编号                           */
                                     /*轉入工單編號                           */
cag02       number(5) NOT NULL,      /*年度                                   */
cag03       number(5) NOT NULL,      /*月份                                   */
cag04       varchar2(40),            /*料件编号                               */
                                     /*料件編號                               */
                                     /*需存在在料件基本資料主檔               */
                                     /*為該工單生產料件編號                   */
cag05       number(5) NOT NULL,      /*转入工单之工艺序号                     */
                                     /*轉入工單之製程序號                     */
                                     /*料件被製作程序過程中的生產活動順序編號 */
cag06       varchar2(6),             /*转入工单之作业编号                     */
                                     /*轉入工單之作業編號                     */
                                     /*料件被製作程序過程中的生產活動編號     */
cag11       varchar2(20),            /*转出工单编号                           */
                                     /*轉出工單編號                           */
cag15       number(5),               /*转出工单之工艺序号                     */
                                     /*轉出工單之製程序號                     */
                                     /*料件被製作程序過程中的生產活動順序編號 */
cag16       varchar2(6),             /*转出工单之作业编号                     */
                                     /*轉出工單之作業編號                     */
                                     /*料件被製作程序過程中的生產活動編號     */
cag20       number(15,3),            /*工单转入量       (+)                   */
                                     /*工單轉入量       (+)                   */
cagdate     date,                    /*首次报工日                             */
                                     /*首次報工日                             */
caglegal    varchar2(10) NOT NULL,   /*所属法人                               */
cag112      varchar2(10),            /*转出工艺段号                           */
cag012      varchar2(10) DEFAULT ' ' NOT NULL /*转入工艺段号*/
);

alter table cag_file add  constraint cag_pk primary key  (cag01,cag02,cag03,cag05,cag012) enable validate;
grant select on cag_file to tiptopgp;
grant update on cag_file to tiptopgp;
grant delete on cag_file to tiptopgp;
grant insert on cag_file to tiptopgp;
grant index on cag_file to public;
grant select on cag_file to ods;
