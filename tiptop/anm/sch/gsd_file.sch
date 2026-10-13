/*
================================================================================
檔案代號:gsd_file
檔案名稱:票券外汇投资备注档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table gsd_file
(
gsd01       varchar2(20) NOT NULL,   /*投资单号                               */
                                     /*投資單號                               */
gsd02       number(5) NOT NULL,      /*行序                                   */
gsd03       varchar2(255),           /*说明                                   */
                                     /*說明                                   */
gsdlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table gsd_file add  constraint gsd_pk primary key  (gsd01,gsd02) enable validate;
grant select on gsd_file to tiptopgp;
grant update on gsd_file to tiptopgp;
grant delete on gsd_file to tiptopgp;
grant insert on gsd_file to tiptopgp;
grant index on gsd_file to public;
grant select on gsd_file to ods;
