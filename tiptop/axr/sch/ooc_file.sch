/*
================================================================================
檔案代號:ooc_file
檔案名稱:科目类型目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ooc_file
(
ooc01       varchar2(1) NOT NULL,    /*科目类型                               */
                                     /*科目類別                               */
ooc02       varchar2(80),            /*科目类型说明                           */
                                     /*科目類別說明                           */
ooc03       varchar2(24),            /*科目编号                               */
                                     /*科目編號                               */
ooc04       varchar2(24)             /*第二科目编码                           */
);

alter table ooc_file add  constraint ooc_pk primary key  (ooc01) enable validate;
grant select on ooc_file to tiptopgp;
grant update on ooc_file to tiptopgp;
grant delete on ooc_file to tiptopgp;
grant insert on ooc_file to tiptopgp;
grant index on ooc_file to public;
grant select on ooc_file to ods;
