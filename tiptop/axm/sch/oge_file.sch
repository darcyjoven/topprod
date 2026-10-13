/*
================================================================================
檔案代號:oge_file
檔案名稱:出货唛头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oge_file
(
oge01       varchar2(20) NOT NULL,   /*出货单号                               */
                                     /*出貨單號                               */
oge101      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
oge102      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
oge103      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
oge104      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
oge105      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
oge106      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
oge107      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
oge108      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
oge109      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
oge110      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
oge111      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
oge112      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
oge201      varchar2(30),            /*侧唛                                   */
                                     /*側嘜                                   */
oge202      varchar2(30),            /*侧唛                                   */
                                     /*側嘜                                   */
oge203      varchar2(30),            /*侧唛                                   */
                                     /*側嘜                                   */
oge204      varchar2(30),            /*侧唛                                   */
                                     /*側嘜                                   */
oge205      varchar2(30),            /*侧唛                                   */
                                     /*側嘜                                   */
oge206      varchar2(30),            /*侧唛                                   */
                                     /*側嘜                                   */
oge207      varchar2(30),            /*侧唛                                   */
                                     /*側嘜                                   */
oge208      varchar2(30),            /*侧唛                                   */
                                     /*側嘜                                   */
oge209      varchar2(30),            /*侧唛                                   */
                                     /*側嘜                                   */
oge210      varchar2(30),            /*侧唛                                   */
                                     /*側嘜                                   */
oge211      varchar2(30),            /*侧唛                                   */
                                     /*側嘜                                   */
oge212      varchar2(30)             /*侧唛                                   */
                                     /*側嘜                                   */
);

alter table oge_file add  constraint oge_pk primary key  (oge01) enable validate;
grant select on oge_file to tiptopgp;
grant update on oge_file to tiptopgp;
grant delete on oge_file to tiptopgp;
grant insert on oge_file to tiptopgp;
grant index on oge_file to public;
grant select on oge_file to ods;
