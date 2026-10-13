/*
================================================================================
檔案代號:ofq_file
檔案名稱:潜在客户来源资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ofq_file
(
ofq01       varchar2(4) NOT NULL,    /*潜在客户来源                           */
                                     /*潛在客戶來源                           */
ofq02       varchar2(255),           /*说明                                   */
                                     /*說明                                   */
ofqacti     varchar2(1),             /*资料有效码                             */
ofquser     varchar2(10),            /*资料所有者                             */
ofqgrup     varchar2(10),            /*资料所有群                             */
ofqmodu     varchar2(10),            /*资料更改者                             */
ofqdate     date,                    /*最近更改日                             */
ofqorig     varchar2(10),            /*资料建立部门                           */
ofqoriu     varchar2(10)             /*资料建立者                             */
);

alter table ofq_file add  constraint ofq_pk primary key  (ofq01) enable validate;
grant select on ofq_file to tiptopgp;
grant update on ofq_file to tiptopgp;
grant delete on ofq_file to tiptopgp;
grant insert on ofq_file to tiptopgp;
grant index on ofq_file to public;
grant select on ofq_file to ods;
