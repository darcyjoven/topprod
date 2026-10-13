/*
================================================================================
檔案代號:apd_file
檔案名稱:应付账款备注档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table apd_file
(
apd01       varchar2(20),            /*帐款单号                               */
                                     /*帳款單號                               */
apd02       number(5),               /*序号                                   */
                                     /*序號                                   */
apd03       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
apdlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index apd_01 on apd_file (apd01);
grant select on apd_file to tiptopgp;
grant update on apd_file to tiptopgp;
grant delete on apd_file to tiptopgp;
grant insert on apd_file to tiptopgp;
grant index on apd_file to public;
grant select on apd_file to ods;
