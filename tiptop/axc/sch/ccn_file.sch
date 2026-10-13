/*
================================================================================
檔案代號:ccn_file
檔案名稱:标准BOM元件单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ccn_file
(
ccn01       varchar2(40) NOT NULL,   /*主件料号                               */
                                     /*主件料號                               */
ccn02       varchar2(10) NOT NULL,   /*标准成本版本                           */
                                     /*標準成本版本                           */
ccn03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
ccn04       varchar2(40),            /*元件料号                               */
                                     /*元件料號                               */
ccn05       number(16,8),            /*标准 QPA                               */
                                     /*標準 QPA                               */
ccn06       number(9,4),             /*损耗率                                 */
                                     /*損耗率                                 */
ccndate     date                     /*最近更改日期                           */
                                     /*最近修改日期                           */
);

alter table ccn_file add  constraint ccn_pk primary key  (ccn01,ccn02,ccn03) enable validate;
grant select on ccn_file to tiptopgp;
grant update on ccn_file to tiptopgp;
grant delete on ccn_file to tiptopgp;
grant insert on ccn_file to tiptopgp;
grant index on ccn_file to public;
grant select on ccn_file to ods;
