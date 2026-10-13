/*
================================================================================
檔案代號:omm_file
檔案名稱:信用评等及备抵呆账提列率档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table omm_file
(
omm00       varchar2(10) DEFAULT ' ' NOT NULL, /*信用评等类别*/
omm01       varchar2(10),            /*第一段分类                             */
omm011      number(15,6),            /*第一段计提率                           */
omm02       varchar2(10),            /*第二段分类                             */
omm021      number(15,6),            /*第二段计提率                           */
omm03       varchar2(10),            /*第三段分类                             */
omm031      number(15,6),            /*第三段计提率                           */
omm04       varchar2(10),            /*第四段分类                             */
omm041      number(15,6),            /*第四段计提率                           */
omm05       varchar2(10),            /*第五段分类                             */
omm051      number(15,6),            /*第五段计提率                           */
omm06       varchar2(10),            /*第六段分类                             */
omm061      number(15,6),            /*第六段计提率                           */
omm07       varchar2(10),            /*第七段分类                             */
omm071      number(15,6),            /*第七段计提率                           */
omm08       varchar2(10),            /*第八段分类                             */
omm081      number(15,6),            /*第八段计提率                           */
omm09       varchar2(10),            /*第九段分类                             */
omm091      number(15,6),            /*第九段计提率                           */
omm10       varchar2(10),            /*第十段分类                             */
omm101      number(15,6)             /*第十段计提率                           */
);

alter table omm_file add  constraint omm_pk primary key  (omm00) enable validate;
grant select on omm_file to tiptopgp;
grant update on omm_file to tiptopgp;
grant delete on omm_file to tiptopgp;
grant insert on omm_file to tiptopgp;
grant index on omm_file to public;
grant select on omm_file to ods;
