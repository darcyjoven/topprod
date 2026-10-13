/*
================================================================================
檔案代號:fay_file
檔案名稱:资产改良单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fay_file
(
fay01       varchar2(20) NOT NULL,   /*改良单号                               */
fay02       date,                    /*改良日期                               */
fay03       varchar2(20),            /*帐款单号                               */
fay031      number(5),               /*帐款单序号                             */
fay04       varchar2(1),             /*No Use                                 */
fay05       varchar2(1),             /*No Use                                 */
fay06       varchar2(20),            /*凭证号码                               */
fay07       date,                    /*凭证日期                               */
fayconf     varchar2(1),             /*确认码                                 */
faypost     varchar2(1),             /*过帐码                                 */
faypost2    varchar2(1),             /*税签过帐                               */
fayprsw     number(5),               /*打印次数                               */
fayuser     varchar2(10),            /*资料所有者                             */
faygrup     varchar2(10),            /*资料所有群                             */
faymodu     varchar2(10),            /*资料更改者                             */
faydate     date,                    /*最近更改日                             */
fay08       varchar2(1),             /*签核状况码                             */
faymksg     varchar2(1),             /*签核否？                               */
fay09       varchar2(10),            /*申请人                                 */
fayud01     varchar2(255),           /*自订字段-Textedit                      */
fayud02     varchar2(40),            /*自订字段-文字                          */
fayud03     varchar2(40),            /*自订字段-文字                          */
fayud04     varchar2(40),            /*自订字段-文字                          */
fayud05     varchar2(40),            /*自订字段-文字                          */
fayud06     varchar2(40),            /*自订字段-文字                          */
fayud07     number(15,3),            /*自订字段-数值                          */
fayud08     number(15,3),            /*自订字段-数值                          */
fayud09     number(15,3),            /*自订字段-数值                          */
fayud10     number(10),              /*自订字段-整数                          */
fayud11     number(10),              /*自订字段-整数                          */
fayud12     number(10),              /*自订字段-整数                          */
fayud13     date,                    /*自订字段-日期                          */
fayud14     date,                    /*自订字段-日期                          */
fayud15     date,                    /*自订字段-日期                          */
faylegal    varchar2(10) NOT NULL,   /*所属法人                               */
fayoriu     varchar2(10),            /*资料建立者                             */
fayorig     varchar2(10),            /*资料建立部门                           */
faypost1    varchar2(1) DEFAULT 'N' NOT NULL, /*过帐码(财签二)*/
fay062      varchar2(20),            /*传票编号(财签二)                       */
fay072      date                     /*传票日期(财签二)                       */
);

create        index fay_02 on fay_file (fay06);
alter table fay_file add  constraint fay_pk primary key  (fay01) enable validate;
grant select on fay_file to tiptopgp;
grant update on fay_file to tiptopgp;
grant delete on fay_file to tiptopgp;
grant insert on fay_file to tiptopgp;
grant index on fay_file to public;
grant select on fay_file to ods;
