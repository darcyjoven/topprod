/*
================================================================================
檔案代號:fba_file
檔案名稱:资产重估单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fba_file
(
fba01       varchar2(20) NOT NULL,   /*重估单号                               */
fba02       date,                    /*重估日期                               */
fba03       varchar2(1),             /*No Use                                 */
fba04       varchar2(1),             /*No Use                                 */
fba05       varchar2(1),             /*No Use                                 */
fba06       varchar2(20),            /*凭证编号                               */
fba07       date,                    /*凭证日期                               */
fbaconf     varchar2(1),             /*确认码                                 */
fbapost     varchar2(1),             /*过帐码                                 */
fbapost2    varchar2(1),             /*过帐码                                 */
fbaprsw     number(5),               /*打印次数                               */
fbauser     varchar2(10),            /*资料所有者                             */
fbagrup     varchar2(10),            /*资料所有群                             */
fbamodu     varchar2(10),            /*资料更改者                             */
fbadate     date,                    /*最近更改日                             */
fba08       varchar2(1),             /*状况码                                 */
fbamksg     varchar2(1),             /*签核否？                               */
fba09       varchar2(10),            /*申请人                                 */
fbaud01     varchar2(255),           /*自订字段-Textedit                      */
fbaud02     varchar2(40),            /*自订字段-文字                          */
fbaud03     varchar2(40),            /*自订字段-文字                          */
fbaud04     varchar2(40),            /*自订字段-文字                          */
fbaud05     varchar2(40),            /*自订字段-文字                          */
fbaud06     varchar2(40),            /*自订字段-文字                          */
fbaud07     number(15,3),            /*自订字段-数值                          */
fbaud08     number(15,3),            /*自订字段-数值                          */
fbaud09     number(15,3),            /*自订字段-数值                          */
fbaud10     number(10),              /*自订字段-整数                          */
fbaud11     number(10),              /*自订字段-整数                          */
fbaud12     number(10),              /*自订字段-整数                          */
fbaud13     date,                    /*自订字段-日期                          */
fbaud14     date,                    /*自订字段-日期                          */
fbaud15     date,                    /*自订字段-日期                          */
fbalegal    varchar2(10) NOT NULL,   /*所属法人                               */
fbaoriu     varchar2(10),            /*资料建立者                             */
fbaorig     varchar2(10),            /*资料建立部门                           */
fbapost1    varchar2(1) DEFAULT 'N' NOT NULL, /*过帐码(财签二)*/
fba062      varchar2(20),            /*传票编号(财签二)                       */
fba072      date                     /*传票日期(财签二)                       */
);

create        index fba_02 on fba_file (fba06);
alter table fba_file add  constraint fba_pk primary key  (fba01) enable validate;
grant select on fba_file to tiptopgp;
grant update on fba_file to tiptopgp;
grant delete on fba_file to tiptopgp;
grant insert on fba_file to tiptopgp;
grant index on fba_file to public;
grant select on fba_file to ods;
