/*
================================================================================
檔案代號:fbp_file
檔案名稱:资产族群编号异动单单身
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fbp_file
(
fbp01       varchar2(16) DEFAULT ' ' NOT NULL, /*异动单号*/
fbp02       number(5) DEFAULT '0' NOT NULL, /*项次*/
fbp03       varchar2(10),            /*财产编号                               */
fbp031      varchar2(4),             /*附号                                   */
fbp04       varchar2(10),            /*原族群编号                             */
fbp05       varchar2(10),            /*变更后族群编号                         */
fbplegal    varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

alter table fbp_file add  constraint fbp_pk primary key  (fbp01,fbp02) enable validate;
grant select on fbp_file to tiptopgp;
grant update on fbp_file to tiptopgp;
grant delete on fbp_file to tiptopgp;
grant insert on fbp_file to tiptopgp;
grant index on fbp_file to public;
grant select on fbp_file to ods;
