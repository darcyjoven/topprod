/*
================================================================================
檔案代號:fcm_file
檔案名稱:固定资产投资抵减享用年度档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fcm_file
(
fcm01       varchar2(20) NOT NULL,   /*申请编号                               */
fcm02       number(5) NOT NULL,      /*项次                                   */
fcm03       varchar2(1),             /*处份否                                 */
fcm04       number(20,6),            /*抵减金额                               */
fcm05       number(5) NOT NULL,      /*享用年度                               */
fcmconf     varchar2(1),             /*确认码                                 */
fcmlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table fcm_file add  constraint fcm_pk primary key  (fcm01,fcm02,fcm05) enable validate;
grant select on fcm_file to tiptopgp;
grant update on fcm_file to tiptopgp;
grant delete on fcm_file to tiptopgp;
grant insert on fcm_file to tiptopgp;
grant index on fcm_file to public;
grant select on fcm_file to ods;
