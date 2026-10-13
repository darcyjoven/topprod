/*
================================================================================
檔案代號:mai_file
檔案名稱:报表结构单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table mai_file
(
mai01       varchar2(6) NOT NULL,    /*报表编号                               */
                                     /*報表編號                               */
mai02       varchar2(80),            /*报表名称                               */
                                     /*報表名稱                               */
mai03       varchar2(1),             /*报表性质                               */
                                     /*報表性質(1/2/3/4)                      */
                                     /* 1:Trial Balance                       */
                                     /* 2:Balance Sheet                       */
                                     /* 3:Income Statement                    */
                                     /* 4:OTHER                               */
maiacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
maiuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
maigrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
maimodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
maidate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
mai00       varchar2(5),             /*帐套                                   */
maioriu     varchar2(10),            /*资料建立者                             */
maiorig     varchar2(10),            /*资料建立部门                           */
mai04       varchar2(5)              /*对应账别                               */
);

alter table mai_file add  constraint mai_pk primary key  (mai01) enable validate;
grant select on mai_file to tiptopgp;
grant update on mai_file to tiptopgp;
grant delete on mai_file to tiptopgp;
grant insert on mai_file to tiptopgp;
grant index on mai_file to public;
grant select on mai_file to ods;
