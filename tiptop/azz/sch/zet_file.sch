/*
================================================================================
檔案代號:zet_file
檔案名稱:错误信息档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:Y
============.========================.==========================================
*/
create table zet_file
(
zet01       varchar2(7) NOT NULL,    /*错误信息编号                           */
                                     /*錯誤訊息代號                           */
                                     /*________________________________________*/
zet02       varchar2(1) NOT NULL,    /*语言别                                 */
                                     /*語言別(0/1/2)                          */
                                     /*  0:中文                               */
                                     /*  1:英文                               */
zet03       varchar2(255)            /*错误信息内容                           */
                                     /*錯誤訊息內容                           */
);

alter table zet_file add  constraint zet_pk primary key  (zet01,zet02) enable validate;
grant select on zet_file to tiptopgp;
grant update on zet_file to tiptopgp;
grant delete on zet_file to tiptopgp;
grant insert on zet_file to tiptopgp;
grant index on zet_file to public;
grant select on zet_file to ods;
