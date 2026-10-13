/*
================================================================================
檔案代號:cbc_file
檔案名稱:FAS 暂存料号资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cbc_file
(
cbc01       varchar2(40),            /*暂时料件                               */
                                     /*暫時料件                               */
cbc02       varchar2(20),            /*订单单号                               */
                                     /*訂單單號 oea01                         */
cbc03       number(5),               /*项次                                   */
                                     /*項次                                   */
cbc04       varchar2(40)             /*FAS 料件                               */
);

grant select on cbc_file to tiptopgp;
grant update on cbc_file to tiptopgp;
grant delete on cbc_file to tiptopgp;
grant insert on cbc_file to tiptopgp;
grant index on cbc_file to public;
grant select on cbc_file to ods;
