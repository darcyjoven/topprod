/*
================================================================================
檔案代號:cno_file
檔案名稱:进出口集中报关货物申报单头
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cno_file
(
cno01       varchar2(20) NOT NULL,   /*单据编号                               */
cno02       date,                    /*单据日期                               */
cno03       varchar2(1),             /*类型                                   */
cno031      varchar2(1),             /*交易类型                               */
cno04       varchar2(1),             /*类型                                   */
cno05       varchar2(20),            /*交易参考单号                           */
cno06       varchar2(30),            /*报关单号                               */
cno07       date,                    /*报单日期                               */
cno08       varchar2(10),            /*交易对象                               */
cno09       varchar2(80),            /*对象名称                               */
cno10       varchar2(20),            /*手册编号                               */
cno11       varchar2(20),            /*对应手册编号                           */
cno12       varchar2(6),             /*贸易性质                               */
cno13       varchar2(10),            /*贸易国家                               */
cno14       varchar2(20),            /*通知单号                               */
cno15       number(5),               /*总件数                                 */
cno16       number(15,3),            /*毛重总量(公斤)                         */
cno17       varchar2(12),            /*集装箱号码                             */
cno18       varchar2(20),            /*折合单号                               */
cno19       number(15,3),            /*净重总量(公斤)                         */
cno20       varchar2(10),            /*海关编号                               */
cnoconf     varchar2(1),             /*确认码                                 */
cnoacti     varchar2(1),             /*资料有效码                             */
cnouser     varchar2(10),            /*资料所有者                             */
cnogrup     varchar2(10),            /*资料所有部门                           */
cnomodu     varchar2(10),            /*资料更改者                             */
cnodate     date,                    /*最近更改日                             */
cno21       varchar2(1),             /*冲帐                                   */
cnoud01     varchar2(255),           /*自订字段-Textedit                      */
cnoud02     varchar2(40),            /*自订字段-文字                          */
cnoud03     varchar2(40),            /*自订字段-文字                          */
cnoud04     varchar2(40),            /*自订字段-文字                          */
cnoud05     varchar2(40),            /*自订字段-文字                          */
cnoud06     varchar2(40),            /*自订字段-文字                          */
cnoud07     number(15,3),            /*自订字段-数值                          */
cnoud08     number(15,3),            /*自订字段-数值                          */
cnoud09     number(15,3),            /*自订字段-数值                          */
cnoud10     number(10),              /*自订字段-整数                          */
cnoud11     number(10),              /*自订字段-整数                          */
cnoud12     number(10),              /*自订字段-整数                          */
cnoud13     date,                    /*自订字段-日期                          */
cnoud14     date,                    /*自订字段-日期                          */
cnoud15     date,                    /*自订字段-日期                          */
cnoplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cnolegal    varchar2(10) NOT NULL,   /*所属法人                               */
cnoorig     varchar2(10),            /*资料建立部门                           */
cnooriu     varchar2(10)             /*资料建立者                             */
);

alter table cno_file add  constraint cno_pk primary key  (cno01) enable validate;
grant select on cno_file to tiptopgp;
grant update on cno_file to tiptopgp;
grant delete on cno_file to tiptopgp;
grant insert on cno_file to tiptopgp;
grant index on cno_file to public;
grant select on cno_file to ods;
