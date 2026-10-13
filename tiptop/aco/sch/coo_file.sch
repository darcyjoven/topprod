/*
================================================================================
檔案代號:coo_file
檔案名稱:出口异动明细档
檔案目的:出口异动明细档
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table coo_file
(
coo01       varchar2(20) NOT NULL,   /*单据编号                               */
coo02       number(5) NOT NULL,      /*项次                                   */
coo03       date,                    /*单据日期                               */
coo04       varchar2(40),            /*料件编号                               */
coo05       varchar2(10),            /*客户编号                               */
coo06       varchar2(40),            /*客户简称                               */
coo07       varchar2(30),            /*报单编号                               */
coo08       date,                    /*报单日期                               */
coo09       varchar2(20),            /*合同编号                               */
coo10       varchar2(1),             /*异动方式                               */
coo11       varchar2(40),            /*商品编号                               */
coo12       varchar2(10),            /*海关编号                               */
coo13       varchar2(20),            /*异动指令编号                           */
coo14       number(15,3),            /*异动数量                               */
coo15       varchar2(4),             /*异动单位                               */
coo16       number(15,3),            /*异动数量(合同)                         */
coo17       varchar2(4),             /*异动单位(合同)                         */
coo18       varchar2(20),            /*手册编号                               */
coo19       varchar2(20),            /*BOM版本编号                            */
coo20       varchar2(1),             /*报关否                                 */
cooconf     varchar2(1),             /*确认码                                 */
cooacti     varchar2(1),             /*资料有效码                             */
coouser     varchar2(10),            /*资料所有者                             */
coogrup     varchar2(10),            /*资料所有部门                           */
coomodu     varchar2(10),            /*资料更改者                             */
coodate     date,                    /*最近更改日                             */
coo21       number(20,8),            /*转换率(料件/商品编号)                  */
coo22       varchar2(1),             /*冲帐否                                 */
cooud01     varchar2(255),           /*自订字段-Textedit                      */
cooud02     varchar2(40),            /*自订字段-文字                          */
cooud03     varchar2(40),            /*自订字段-文字                          */
cooud04     varchar2(40),            /*自订字段-文字                          */
cooud05     varchar2(40),            /*自订字段-文字                          */
cooud06     varchar2(40),            /*自订字段-文字                          */
cooud07     number(15,3),            /*自订字段-数值                          */
cooud08     number(15,3),            /*自订字段-数值                          */
cooud09     number(15,3),            /*自订字段-数值                          */
cooud10     number(10),              /*自订字段-整数                          */
cooud11     number(10),              /*自订字段-整数                          */
cooud12     number(10),              /*自订字段-整数                          */
cooud13     date,                    /*自订字段-日期                          */
cooud14     date,                    /*自订字段-日期                          */
cooud15     date,                    /*自订字段-日期                          */
cooplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
coolegal    varchar2(10) NOT NULL,   /*所属法人                               */
cooorig     varchar2(10),            /*资料建立部门                           */
coooriu     varchar2(10)             /*资料建立者                             */
);

create        index coo_03 on coo_file (coo11,coo19,coo12);
create        index coo_02 on coo_file (coo18);
alter table coo_file add  constraint coo_pk primary key  (coo01,coo02) enable validate;
grant select on coo_file to tiptopgp;
grant update on coo_file to tiptopgp;
grant delete on coo_file to tiptopgp;
grant insert on coo_file to tiptopgp;
grant index on coo_file to public;
grant select on coo_file to ods;
