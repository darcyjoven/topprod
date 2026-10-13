/*
================================================================================
檔案代號:bmg_file
檔案名稱:工程变异单说明档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bmg_file
(
bmg01       varchar2(20) NOT NULL,   /*工程变异单单号                         */
                                     /*工程變異單單號                         */
                                     /*儲存工程變異單單號。                   */
bmg02       number(5) NOT NULL,      /*行序号                                 */
                                     /*行序號                                 */
                                     /*儲存工程變異說明行序，可作為顯示時的出 */
                                     /*現順序。                               */
bmg03       varchar2(255),           /*行说明                                 */
                                     /*行說明                                 */
                                     /*儲存工程變異說明。                     */
bmgplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bmglegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table bmg_file add  constraint bmg_pk primary key  (bmg01,bmg02) enable validate;
grant select on bmg_file to tiptopgp;
grant update on bmg_file to tiptopgp;
grant delete on bmg_file to tiptopgp;
grant insert on bmg_file to tiptopgp;
grant index on bmg_file to public;
grant select on bmg_file to ods;
