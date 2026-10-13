/*
================================================================================
檔案代號:pje_file
檔案名稱:工作项目名称档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pje_file
(
pje01       varchar2(10) NOT NULL,   /*工作项目                               */
                                     /*工作項目                               */
pje02       varchar2(80),            /*工作名称                               */
                                     /*工作名稱                               */
pjeacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
pjeuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
pjegrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
pjemodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
pjedate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
pjeorig     varchar2(10),            /*资料建立部门                           */
pjeoriu     varchar2(10)             /*资料建立者                             */
);

alter table pje_file add  constraint pje_pk primary key  (pje01) enable validate;
grant select on pje_file to tiptopgp;
grant update on pje_file to tiptopgp;
grant delete on pje_file to tiptopgp;
grant insert on pje_file to tiptopgp;
grant index on pje_file to public;
grant select on pje_file to ods;
