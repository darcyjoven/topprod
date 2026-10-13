/*
================================================================================
檔案代號:oad_file
檔案名稱:单位运费档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oad_file
(
oad01       varchar2(10) NOT NULL,   /*起运地点                               */
                                     /*起運地點                               */
oad02       varchar2(10) NOT NULL,   /*到达地点                               */
                                     /*到達地點                               */
oad041      number(20,6) NOT NULL,   /*第一类每公斤单位运费                   */
                                     /*第一類每公斤單位運費                   */
oad042      number(20,6) NOT NULL,   /*第二类每公斤单位运费                   */
                                     /*第二類每公斤單位運費                   */
oad043      number(20,6) NOT NULL,   /*第三类每公斤单位运费                   */
                                     /*第三類每公斤單位運費                   */
oad051      number(20,6) NOT NULL,   /*第一类每公斤单位运费(退货)             */
                                     /*第一類每公斤單位運費(退貨)             */
oad052      number(20,6) NOT NULL,   /*第二类每公斤单位运费                   */
                                     /*第二類每公斤單位運費(退貨)             */
oad053      number(20,6) NOT NULL    /*第三类每公斤单位运费                   */
                                     /*第三類每公斤單位運費(退貨)             */
);

alter table oad_file add  constraint oad_pk primary key  (oad01,oad02) enable validate;
grant select on oad_file to tiptopgp;
grant update on oad_file to tiptopgp;
grant delete on oad_file to tiptopgp;
grant insert on oad_file to tiptopgp;
grant index on oad_file to public;
grant select on oad_file to ods;
