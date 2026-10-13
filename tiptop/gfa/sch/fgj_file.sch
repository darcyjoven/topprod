/*
================================================================================
檔案代號:fgj_file
檔案名稱:每月工作资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fgj_file
(
fgj01       number(5) NOT NULL,      /*工作年度                               */
fgj02       number(5) NOT NULL,      /*工作期别                               */
fgj03       varchar2(10) NOT NULL,   /*财产编号                               */
fgj04       varchar2(4) NOT NULL,    /*附号                                   */
fgj05       number(15,2),            /*本月工作量                             */
fgj06       varchar2(255),           /*备注                                   */
fgjuser     varchar2(10),            /*资料所有者                             */
fgjgrup     varchar2(10),            /*资料所有群                             */
fgjmodu     varchar2(10),            /*资料更改者                             */
fgjdate     date,                    /*最近更改日                             */
fgjconf     varchar2(1),             /*确认码                                 */
                                     /*確認碼(Y/N)                            */
fgjacti     varchar2(1),             /*资料有效码                             */
                                     /*Data Valid Code(Y/N)                   */
fgjud01     varchar2(255),           /*自订字段-Textedit                      */
fgjud02     varchar2(40),            /*自订字段-文字                          */
fgjud03     varchar2(40),            /*自订字段-文字                          */
fgjud04     varchar2(40),            /*自订字段-文字                          */
fgjud05     varchar2(40),            /*自订字段-文字                          */
fgjud06     varchar2(40),            /*自订字段-文字                          */
fgjud07     number(15,3),            /*自订字段-数值                          */
fgjud08     number(15,3),            /*自订字段-数值                          */
fgjud09     number(15,3),            /*自订字段-数值                          */
fgjud10     number(10),              /*自订字段-整数                          */
fgjud11     number(10),              /*自订字段-整数                          */
fgjud12     number(10),              /*自订字段-整数                          */
fgjud13     date,                    /*自订字段-日期                          */
fgjud14     date,                    /*自订字段-日期                          */
fgjud15     date,                    /*自订字段-日期                          */
fgjlegal    varchar2(10) NOT NULL,   /*所属法人                               */
fgjoriu     varchar2(10),            /*资料建立者                             */
fgjorig     varchar2(10)             /*资料建立部门                           */
);

alter table fgj_file add  constraint fgj_pk primary key  (fgj01,fgj02,fgj03,fgj04) enable validate;
grant select on fgj_file to tiptopgp;
grant update on fgj_file to tiptopgp;
grant delete on fgj_file to tiptopgp;
grant insert on fgj_file to tiptopgp;
grant index on fgj_file to public;
grant select on fgj_file to ods;
