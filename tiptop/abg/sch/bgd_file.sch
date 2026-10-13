/*
================================================================================
檔案代號:bgd_file
檔案名稱:等级本薪资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bgd_file
(
bgd01       varchar2(10) NOT NULL,   /*版本                                   */
bgd02       varchar2(10) NOT NULL,   /*职等编号                               */
                                     /*職等代號                               */
bgd03       number(5) NOT NULL,      /*职级编号                               */
                                     /*職級代號                               */
bgd04       number(20,6),            /*标准本薪                               */
                                     /*標準本薪                               */
bgd05       number(20,6),            /*投保薪资                               */
                                     /*投保薪資                               */
bgdacti     varchar2(1),             /*资料有效否                             */
bgduser     varchar2(10),            /*资料所有者                             */
bgdgrup     varchar2(10),            /*资料所有群                             */
bgdmodu     varchar2(10),            /*资料更改者                             */
bgddate     date,                    /*最近更改日                             */
bgdorig     varchar2(10),            /*资料建立部门                           */
bgdoriu     varchar2(10)             /*资料建立者                             */
);

alter table bgd_file add  constraint bgd_pk primary key  (bgd01,bgd02,bgd03) enable validate;
grant select on bgd_file to tiptopgp;
grant update on bgd_file to tiptopgp;
grant delete on bgd_file to tiptopgp;
grant insert on bgd_file to tiptopgp;
grant index on bgd_file to public;
grant select on bgd_file to ods;
