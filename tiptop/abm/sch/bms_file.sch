/*
================================================================================
檔案代號:bms_file
檔案名稱:设计变更申请说明资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bms_file
(
bms01       varchar2(20) NOT NULL,   /*设计变更申请单号                       */
                                     /*設計變更申請單號                       */
bms02       number(5) NOT NULL,      /*行序                                   */
                                     /*儲存工程變異申請說明行序，可作為顯示時 */
                                     /*的順序。                               */
bms03       varchar2(255),           /*说明                                   */
                                     /*說明                                   */
                                     /*儲存工程變異申請說明。                 */
bmsplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bmslegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table bms_file add  constraint bms_pk primary key  (bms01,bms02) enable validate;
grant select on bms_file to tiptopgp;
grant update on bms_file to tiptopgp;
grant delete on bms_file to tiptopgp;
grant insert on bms_file to tiptopgp;
grant index on bms_file to public;
grant select on bms_file to ods;
