/*
================================================================================
檔案代號:bgi_file
檔案名稱:付款方式档 (Payment Term Code File)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bgi_file
(
bgi01       varchar2(10) NOT NULL,   /*版本                                   */
bgi02       varchar2(10) NOT NULL,   /*付款条件                               */
                                     /*付款條件                               */
bgi03       varchar2(80),            /*付款说明                               */
                                     /*付款說明                               */
bgi04       number(9,4),             /*占百分比                               */
bgi05       varchar2(1)              /*No Use                                 */
);

alter table bgi_file add  constraint bgi_pk primary key  (bgi01,bgi02) enable validate;
grant select on bgi_file to tiptopgp;
grant update on bgi_file to tiptopgp;
grant delete on bgi_file to tiptopgp;
grant insert on bgi_file to tiptopgp;
grant index on bgi_file to public;
grant select on bgi_file to ods;
