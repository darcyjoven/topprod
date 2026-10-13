/*
================================================================================
檔案代號:src_file
檔案名稱:机台(生产线)换料资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table src_file
(
src01       varchar2(10) NOT NULL,   /*机台生产线                             */
src02       varchar2(40) NOT NULL,   /*生产料号                               */
src03       varchar2(40) NOT NULL,   /*换线品号                               */
src04       number(15,3),            /*维修时间(分钟)                         */
srcacti     varchar2(1)              /*有效否                                 */
);

alter table src_file add  constraint src_pk primary key  (src01,src02,src03) enable validate;
grant select on src_file to tiptopgp;
grant update on src_file to tiptopgp;
grant delete on src_file to tiptopgp;
grant insert on src_file to tiptopgp;
grant index on src_file to public;
grant select on src_file to ods;
