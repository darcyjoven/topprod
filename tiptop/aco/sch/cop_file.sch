/*
================================================================================
檔案代號:cop_file
檔案名稱:进口异动明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cop_file
(
cop01       varchar2(20) NOT NULL,   /*单据编号                               */
cop02       number(5) NOT NULL,      /*项次                                   */
cop03       date,                    /*单据日期                               */
cop04       varchar2(40),            /*料件编号                               */
cop05       varchar2(10),            /*厂商编号                               */
cop06       varchar2(40),            /*厂商简称                               */
cop07       varchar2(30),            /*报单编号                               */
cop08       date,                    /*报单日期                               */
cop09       varchar2(20),            /*合同编号                               */
cop10       varchar2(1),             /*异动方式                               */
cop11       varchar2(40),            /*商品编号                               */
cop12       varchar2(16),            /*No Use                                 */
cop13       varchar2(20),            /*异动指令编号                           */
cop14       number(15,3),            /*异动数量                               */
cop15       varchar2(4),             /*异动单位                               */
cop16       number(15,3),            /*异动数量(合同)                         */
cop17       varchar2(4),             /*异动单位(合同)                         */
cop18       varchar2(20),            /*手册编号                               */
cop19       varchar2(10),            /*海关编号                               */
cop20       varchar2(1),             /*报关否                                 */
copconf     varchar2(1),             /*确认码                                 */
copacti     varchar2(1),             /*资料有效码                             */
copuser     varchar2(10),            /*资料所有者                             */
copgrup     varchar2(10),            /*资料所有部门                           */
copmodu     varchar2(10),            /*资料更改者                             */
copdate     date,                    /*最近更改日                             */
cop21       number(20,8),            /*转换率(料件/商品编号)                  */
cop22       varchar2(1),             /*冲帐否                                 */
copud01     varchar2(255),           /*自订字段-Textedit                      */
copud02     varchar2(40),            /*自订字段-文字                          */
copud03     varchar2(40),            /*自订字段-文字                          */
copud04     varchar2(40),            /*自订字段-文字                          */
copud05     varchar2(40),            /*自订字段-文字                          */
copud06     varchar2(40),            /*自订字段-文字                          */
copud07     number(15,3),            /*自订字段-数值                          */
copud08     number(15,3),            /*自订字段-数值                          */
copud09     number(15,3),            /*自订字段-数值                          */
copud10     number(10),              /*自订字段-整数                          */
copud11     number(10),              /*自订字段-整数                          */
copud12     number(10),              /*自订字段-整数                          */
copud13     date,                    /*自订字段-日期                          */
copud14     date,                    /*自订字段-日期                          */
copud15     date,                    /*自订字段-日期                          */
copplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
coplegal    varchar2(10) NOT NULL,   /*所属法人                               */
coporiu     varchar2(10),            /*资料建立者                             */
coporig     varchar2(10)             /*资料建立部门                           */
);

alter table cop_file add  constraint cop_pk primary key  (cop01,cop02) enable validate;
grant select on cop_file to tiptopgp;
grant update on cop_file to tiptopgp;
grant delete on cop_file to tiptopgp;
grant insert on cop_file to tiptopgp;
grant index on cop_file to public;
grant select on cop_file to ods;
