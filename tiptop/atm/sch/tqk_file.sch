/*
================================================================================
檔案代號:tqk_file
檔案名稱:客户债权关系档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tqk_file
(
tqk01       varchar2(10) NOT NULL,   /*客户编号                               */
tqk02       varchar2(10) NOT NULL,   /*债权分类编号                           */
tqk03       varchar2(10) NOT NULL,   /*收款客户编号                           */
tqk04       varchar2(6),             /*收款条件编号                           */
tqk05       varchar2(4),             /*币种                                   */
tqk06       number(20,6),            /*信用额度                               */
tqk07       number(20,6),            /*铺底额度                               */
tqkacti     varchar2(1),             /*有效码                                 */
tqkuser     varchar2(10),            /*资料所有者                             */
tqkgrup     varchar2(10),            /*资料所有部门                           */
tqkmodu     varchar2(10),            /*资料更改者                             */
tqkdate     date,                    /*最近更改日                             */
tqkud01     varchar2(255),           /*自订字段-Textedit                      */
tqkud02     varchar2(40),            /*自订字段-文字                          */
tqkud03     varchar2(40),            /*自订字段-文字                          */
tqkud04     varchar2(40),            /*自订字段-文字                          */
tqkud05     varchar2(40),            /*自订字段-文字                          */
tqkud06     varchar2(40),            /*自订字段-文字                          */
tqkud07     number(15,3),            /*自订字段-数值                          */
tqkud08     number(15,3),            /*自订字段-数值                          */
tqkud09     number(15,3),            /*自订字段-数值                          */
tqkud10     number(10),              /*自订字段-整数                          */
tqkud11     number(10),              /*自订字段-整数                          */
tqkud12     number(10),              /*自订字段-整数                          */
tqkud13     date,                    /*自订字段-日期                          */
tqkud14     date,                    /*自订字段-日期                          */
tqkud15     date,                    /*自订字段-日期                          */
tqkoriu     varchar2(10),            /*资料建立者                             */
tqkorig     varchar2(10)             /*资料建立部门                           */
);

alter table tqk_file add  constraint tqk_pk primary key  (tqk01,tqk02,tqk03) enable validate;
grant select on tqk_file to tiptopgp;
grant update on tqk_file to tiptopgp;
grant delete on tqk_file to tiptopgp;
grant insert on tqk_file to tiptopgp;
grant index on tqk_file to public;
grant select on tqk_file to ods;
