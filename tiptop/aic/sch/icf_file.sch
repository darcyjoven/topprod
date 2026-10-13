/*
================================================================================
檔案代號:icf_file
檔案名稱:ICD料件BIN资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table icf_file
(
icf01       varchar2(80) NOT NULL,   /*Item                                   */
icf02       varchar2(5) NOT NULL,    /*Bin                                    */
icf03       varchar2(255),           /*Bin Desc                               */
icf04       varchar2(1),             /*Pass Bin                               */
icf05       varchar2(1),             /*Code                                   */
icf06       varchar2(255),           /*Remark                                 */
icf07       varchar2(40),            /*no use                                 */
icf08       varchar2(1),             /*no use                                 */
icf09       varchar2(1)              /*no use                                 */
);

alter table icf_file add  constraint icf_pk primary key  (icf01,icf02) enable validate;
grant select on icf_file to tiptopgp;
grant update on icf_file to tiptopgp;
grant delete on icf_file to tiptopgp;
grant insert on icf_file to tiptopgp;
grant index on icf_file to public;
grant select on icf_file to ods;
