/*
================================================================================
檔案代號:fbs_file
檔案名稱:资产减值准备单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fbs_file
(
fbs01       varchar2(20) NOT NULL,   /*减值单号                               */
fbs02       date,                    /*减值日期                               */
fbs03       varchar2(4),             /*No Use                                 */
fbs04       varchar2(20),            /*凭证编号                               */
fbs05       date,                    /*凭证日期                               */
fbsconf     varchar2(1),             /*确认码                                 */
                                     /*確認碼(Y/N/X)                          */
fbspost     varchar2(1),             /*过帐码                                 */
                                     /*過帳碼(Y/N)                            */
fbspost2    varchar2(1),             /*过帐码                                 */
                                     /*過帳碼(Y/N)                            */
fbsprsw     number(5),               /*打印次数                               */
fbsuser     varchar2(10),            /*资料所有者                             */
fbsgrup     varchar2(10),            /*资料所有群                             */
fbsmodu     varchar2(10),            /*资料更改者                             */
fbsdate     date,                    /*最近更改日                             */
fbsud01     varchar2(255),           /*自订字段-Textedit                      */
fbsud02     varchar2(40),            /*自订字段-文字                          */
fbsud03     varchar2(40),            /*自订字段-文字                          */
fbsud04     varchar2(40),            /*自订字段-文字                          */
fbsud05     varchar2(40),            /*自订字段-文字                          */
fbsud06     varchar2(40),            /*自订字段-文字                          */
fbsud07     number(15,3),            /*自订字段-数值                          */
fbsud08     number(15,3),            /*自订字段-数值                          */
fbsud09     number(15,3),            /*自订字段-数值                          */
fbsud10     number(10),              /*自订字段-整数                          */
fbsud11     number(10),              /*自订字段-整数                          */
fbsud12     number(10),              /*自订字段-整数                          */
fbsud13     date,                    /*自订字段-日期                          */
fbsud14     date,                    /*自订字段-日期                          */
fbsud15     date,                    /*自订字段-日期                          */
fbslegal    varchar2(10) NOT NULL,   /*所属法人                               */
fbsoriu     varchar2(10),            /*资料建立者                             */
fbsorig     varchar2(10),            /*资料建立部门                           */
fbspost1    varchar2(1) DEFAULT 'N' NOT NULL, /*过帐码(财签二)*/
fbs042      varchar2(20),            /*传票编号(财签二)                       */
fbs052      date                     /*传票日期(财签二)                       */
);

create        index fbs_02 on fbs_file (fbs04);
alter table fbs_file add  constraint fbs_pk primary key  (fbs01) enable validate;
grant select on fbs_file to tiptopgp;
grant update on fbs_file to tiptopgp;
grant delete on fbs_file to tiptopgp;
grant insert on fbs_file to tiptopgp;
grant index on fbs_file to public;
grant select on fbs_file to ods;
