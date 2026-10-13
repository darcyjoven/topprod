/*
================================================================================
檔案代號:lng_file
檔案名稱:正式商戶經營信息檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lng_file
(
lng00       varchar2(10),            /*来源门店编号                           */
lng01       varchar2(10) DEFAULT ' ' NOT NULL, /*商户号*/
lng02       varchar2(20),            /*版本号                                 */
lng03       varchar2(20) DEFAULT ' ' NOT NULL, /*证件编号*/
lng04       varchar2(20) DEFAULT ' ' NOT NULL, /*证件号码*/
lng05       varchar2(40),            /*经营人                                 */
lng06       date,                    /*有效期起日                             */
lng07       date                     /*有效期止日                             */
);

alter table lng_file add  constraint lng_pk primary key  (lng01,lng03,lng04) enable validate;
grant select on lng_file to tiptopgp;
grant update on lng_file to tiptopgp;
grant delete on lng_file to tiptopgp;
grant insert on lng_file to tiptopgp;
grant index on lng_file to public;
grant select on lng_file to ods;
