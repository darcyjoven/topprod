/*
================================================================================
檔案代號:qsa_file
檔案名稱:仓库检验申请单主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qsa_file
(
qsa01       varchar2(20) NOT NULL,   /*检验申请单号                           */
qsa02       varchar2(40),            /*料件编号                               */
qsa03       varchar2(10),            /*仓库                                   */
                                     /*                                       */
                                     /*                                       */
                                     /*                                       */
qsa04       varchar2(10),            /*库位                                   */
qsa05       varchar2(24),            /*批号                                   */
qsa06       number(15,3),            /*代检量                                 */
qsa07       varchar2(255),           /*备注                                   */
qsa08       varchar2(1),             /*确认码                                 */
qsa09       date,                    /*审核日期                               */
qsa10       varchar2(1),             /*急料否                                 */
qsa11       date,                    /*开单日                                 */
qsa12       varchar2(10),            /*厂商代码                               */
qsa13       varchar2(24),            /*No Use                                 */
qsaprno     number(5),               /*打印次数                               */
qsaacti     varchar2(1),             /*资料有效码                             */
qsauser     varchar2(10),            /*资料所有者                             */
qsagrup     varchar2(10),            /*资料所有部门                           */
qsamodu     varchar2(10),            /*资料更改者                             */
qsadate     date,                    /*最近更改日                             */
qsa14       varchar2(1),             /*标识                                   */
qsa30       varchar2(4),             /*子/库存单位                            */
qsa31       number(20,8),            /*子/库存单位转换率                      */
qsa32       number(15,3),            /*子/库存数量                            */
qsa33       varchar2(4),             /*母/参考单位                            */
qsa34       number(20,8),            /*母/参考单位换算率(与库存单             */
qsa35       number(15,3),            /*母/参考数量                            */
qsaspc      varchar2(1),             /*SPC抛转码 0/1/2                        */
qsaud01     varchar2(255),           /*自订字段-Textedit                      */
qsaud02     varchar2(40),            /*自订字段-文字                          */
qsaud03     varchar2(40),            /*自订字段-文字                          */
qsaud04     varchar2(40),            /*自订字段-文字                          */
qsaud05     varchar2(40),            /*自订字段-文字                          */
qsaud06     varchar2(40),            /*自订字段-文字                          */
qsaud07     number(15,3),            /*自订字段-数值                          */
qsaud08     number(15,3),            /*自订字段-数值                          */
qsaud09     number(15,3),            /*自订字段-数值                          */
qsaud10     number(10),              /*自订字段-整数                          */
qsaud11     number(10),              /*自订字段-整数                          */
qsaud12     number(10),              /*自订字段-整数                          */
qsaud13     date,                    /*自订字段-日期                          */
qsaud14     date,                    /*自订字段-日期                          */
qsaud15     date,                    /*自订字段-日期                          */
qsaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
qsalegal    varchar2(10) NOT NULL,   /*所属法人                               */
qsaoriu     varchar2(10),            /*资料建立者                             */
qsaorig     varchar2(10)             /*资料建立部门                           */
);

alter table qsa_file add  constraint qsa_pk primary key  (qsa01) enable validate;
grant select on qsa_file to tiptopgp;
grant update on qsa_file to tiptopgp;
grant delete on qsa_file to tiptopgp;
grant insert on qsa_file to tiptopgp;
grant index on qsa_file to public;
grant select on qsa_file to ods;
