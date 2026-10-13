/*
================================================================================
檔案代號:ocf_file
檔案名稱:客户唛头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ocf_file
(
ocf01       varchar2(10) NOT NULL,   /*客户编号                               */
                                     /*客戶編號                               */
ocf02       varchar2(10) NOT NULL,   /*唛头编号                               */
                                     /*嘜頭代號                               */
ocf101      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
ocf102      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
ocf103      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
ocf104      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
ocf105      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
ocf106      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
ocf107      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
ocf108      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
ocf109      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
ocf110      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
ocf111      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
ocf112      varchar2(30),            /*正唛                                   */
                                     /*正嘜                                   */
ocf201      varchar2(30),            /*侧唛                                   */
                                     /*側嘜                                   */
ocf202      varchar2(30),            /*侧唛                                   */
                                     /*側嘜                                   */
ocf203      varchar2(30),            /*侧唛                                   */
                                     /*側嘜                                   */
ocf204      varchar2(30),            /*侧唛                                   */
                                     /*側嘜                                   */
ocf205      varchar2(30),            /*侧唛                                   */
                                     /*側嘜                                   */
ocf206      varchar2(30),            /*侧唛                                   */
                                     /*側嘜                                   */
ocf207      varchar2(30),            /*侧唛                                   */
                                     /*側嘜                                   */
ocf208      varchar2(30),            /*侧唛                                   */
                                     /*側嘜                                   */
ocf209      varchar2(30),            /*侧唛                                   */
                                     /*側嘜                                   */
ocf210      varchar2(30),            /*侧唛                                   */
                                     /*側嘜                                   */
ocf211      varchar2(30),            /*侧唛                                   */
                                     /*側嘜                                   */
ocf212      varchar2(30)             /*侧唛                                   */
                                     /*側嘜                                   */
);

alter table ocf_file add  constraint ocf_pk primary key  (ocf01,ocf02) enable validate;
grant select on ocf_file to tiptopgp;
grant update on ocf_file to tiptopgp;
grant delete on ocf_file to tiptopgp;
grant insert on ocf_file to tiptopgp;
grant index on ocf_file to public;
grant select on ocf_file to ods;
