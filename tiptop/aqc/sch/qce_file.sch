/*
================================================================================
檔案代號:qce_file
檔案名稱:不良原因代码说明资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table qce_file
(
qce01       varchar2(10) NOT NULL,   /*不良原因代码                           */
                                     /*不良原因代碼                           */
qce02       varchar2(1),             /*No Use                                 */
qce03       varchar2(80),            /*说明内容                               */
                                     /*說明內容                               */
qce04       varchar2(1),             /*No Use                                 */
qceacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
qceuser     varchar2(10),            /*原始资料建立者                         */
                                     /*原始資料建立者                         */
qcegrup     varchar2(10),            /*用户部门                               */
                                     /*使用者部門                             */
qcemodu     varchar2(10),            /*最后更改资料者                         */
                                     /*最後修改資料者                         */
qcedate     date,                    /*最后更改日期                           */
                                     /*最後修改日期                           */
qceorig     varchar2(10),            /*资料建立部门                           */
qceoriu     varchar2(10)             /*资料建立者                             */
);

alter table qce_file add  constraint qce_pk primary key  (qce01) enable validate;
grant select on qce_file to tiptopgp;
grant update on qce_file to tiptopgp;
grant delete on qce_file to tiptopgp;
grant insert on qce_file to tiptopgp;
grant index on qce_file to public;
grant select on qce_file to ods;
