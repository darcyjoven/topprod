/*
================================================================================
檔案代號:ze_file
檔案名稱:错误信息档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table ze_file
(
ze01        varchar2(7) NOT NULL,    /*错误信息编号                           */
                                     /*錯誤訊息代號                           */
                                     /*________________________________________*/
ze02        varchar2(1) NOT NULL,    /*语言别                                 */
                                     /*語言別(0/1/2)                          */
                                     /*  0:中文                               */
                                     /*  1:英文                               */
ze03        varchar2(1500),          /*错误信息内容                           */
                                     /*錯誤訊息內容                           */
ze04        date,                    /*最后更改日期                           */
ze05        varchar2(1)              /*非背景作业下强制弹出视窗错             */
);

alter table ze_file add  constraint ze_pk primary key  (ze01,ze02) enable validate;
grant select on ze_file to tiptopgp;
grant update on ze_file to tiptopgp;
grant delete on ze_file to tiptopgp;
grant insert on ze_file to tiptopgp;
grant index on ze_file to public;
grant select on ze_file to ods;
