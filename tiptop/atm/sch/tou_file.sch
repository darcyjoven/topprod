/*
================================================================================
檔案代號:tou_file
檔案名稱:广告扣款单维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tou_file
(
tou01       varchar2(20) NOT NULL,   /*单据编号                               */
tou02       date,                    /*单据日期                               */
tou03       varchar2(10),            /*合约编号                               */
tou04       number(20,6),            /*扣款金额                               */
tou05       varchar2(20),            /*应付凭单号码                           */
tou06       date,                    /*应付凭单日期                           */
tou07       varchar2(255),           /*备注                                   */
tou08       varchar2(1),             /*确认码                                 */
tou09       varchar2(1),             /*状态                                   */
touacti     varchar2(1),             /*资料有效码                             */
touuser     varchar2(10),            /*资料所有者                             */
tougrup     varchar2(10),            /*资料所有部门                           */
toumodu     varchar2(10),            /*最近更改者                             */
toudate     date,                    /*最近更改日                             */
touud01     varchar2(255),           /*自订字段-Textedit                      */
touud02     varchar2(40),            /*自订字段-文字                          */
touud03     varchar2(40),            /*自订字段-文字                          */
touud04     varchar2(40),            /*自订字段-文字                          */
touud05     varchar2(40),            /*自订字段-文字                          */
touud06     varchar2(40),            /*自订字段-文字                          */
touud07     number(15,3),            /*自订字段-数值                          */
touud08     number(15,3),            /*自订字段-数值                          */
touud09     number(15,3),            /*自订字段-数值                          */
touud10     number(10),              /*自订字段-整数                          */
touud11     number(10),              /*自订字段-整数                          */
touud12     number(10),              /*自订字段-整数                          */
touud13     date,                    /*自订字段-日期                          */
touud14     date,                    /*自订字段-日期                          */
touud15     date,                    /*自订字段-日期                          */
touoriu     varchar2(10),            /*资料建立者                             */
touorig     varchar2(10)             /*资料建立部门                           */
);

alter table tou_file add  constraint tou_pk primary key  (tou01) enable validate;
grant select on tou_file to tiptopgp;
grant update on tou_file to tiptopgp;
grant delete on tou_file to tiptopgp;
grant insert on tou_file to tiptopgp;
grant index on tou_file to public;
grant select on tou_file to ods;
