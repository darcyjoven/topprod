/*
================================================================================
檔案代號:apr_file
檔案名稱:AAP-账款类型档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table apr_file
(
apr01       varchar2(10) NOT NULL,   /*帐款类型编号                           */
                                     /*                                       */
                                     /*                                       */
apr02       varchar2(80),            /*类型名称                               */
                                     /*                                       */
                                     /*                                       */
apracti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
apruser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
aprgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
aprmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
aprdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
aprorig     varchar2(10),            /*资料建立部门                           */
aproriu     varchar2(10)             /*资料建立者                             */
);

alter table apr_file add  constraint apr_pk primary key  (apr01) enable validate;
grant select on apr_file to tiptopgp;
grant update on apr_file to tiptopgp;
grant delete on apr_file to tiptopgp;
grant insert on apr_file to tiptopgp;
grant index on apr_file to public;
grant select on apr_file to ods;
