/*
================================================================================
檔案代號:fga_file
檔案名稱:量测仪器资料维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fga_file
(
fga01       varchar2(15) NOT NULL,   /*仪器编号                               */
fga02       varchar2(15),            /*仪器序号                               */
fga03       varchar2(10),            /*财产编号                               */
fga031      varchar2(4),             /*附号                                   */
fga04       varchar2(10),            /*财产序号                               */
fga06       varchar2(80),            /*中文名称-1                             */
fga061      varchar2(80),            /*中文名称-2                             */
fga07       varchar2(80),            /*英文名称-1                             */
fga071      varchar2(80),            /*英文名称-2                             */
fga08       varchar2(30),            /*规格型号                               */
fga09       varchar2(30),            /*精密度                                 */
fga10       varchar2(10),            /*厂商编号                               */
fga11       varchar2(10),            /*制造厂商                               */
fga12       varchar2(10),            /*保管人员                               */
fga13       varchar2(10),            /*保管部门                               */
fga14       varchar2(10),            /*存放位置                               */
fga15       varchar2(10),            /*存放营运中心                           */
fga16       date,                    /*取得日期                               */
fga20       number(5),               /*校正周期                               */
fga21       varchar2(1),             /*校正别                                 */
fga22       date,                    /*最近送校日                             */
fga23       date,                    /*下次校验日                             */
fga24       varchar2(1),             /*校正结果                               */
fga25       varchar2(10),            /*校正人员                               */
fga26       varchar2(1),             /*No Use                                 */
fga27       varchar2(1),             /*No Use                                 */
fga28       varchar2(1),             /*No Use                                 */
fgaacti     varchar2(1),             /*资料有效码                             */
fgauser     varchar2(10),            /*资料所有者                             */
fgagrup     varchar2(10),            /*资料所有群                             */
fgamodu     varchar2(10),            /*资料更改者                             */
fgadate     date,                    /*最近更改日                             */
fgaud01     varchar2(255),           /*自订字段-Textedit                      */
fgaud02     varchar2(40),            /*自订字段-文字                          */
fgaud03     varchar2(40),            /*自订字段-文字                          */
fgaud04     varchar2(40),            /*自订字段-文字                          */
fgaud05     varchar2(40),            /*自订字段-文字                          */
fgaud06     varchar2(40),            /*自订字段-文字                          */
fgaud07     number(15,3),            /*自订字段-数值                          */
fgaud08     number(15,3),            /*自订字段-数值                          */
fgaud09     number(15,3),            /*自订字段-数值                          */
fgaud10     number(10),              /*自订字段-整数                          */
fgaud11     number(10),              /*自订字段-整数                          */
fgaud12     number(10),              /*自订字段-整数                          */
fgaud13     date,                    /*自订字段-日期                          */
fgaud14     date,                    /*自订字段-日期                          */
fgaud15     date,                    /*自订字段-日期                          */
fgaoriu     varchar2(10),            /*资料建立者                             */
fgaorig     varchar2(10)             /*资料建立部门                           */
);

alter table fga_file add  constraint fga_pk primary key  (fga01) enable validate;
grant select on fga_file to tiptopgp;
grant update on fga_file to tiptopgp;
grant delete on fga_file to tiptopgp;
grant insert on fga_file to tiptopgp;
grant index on fga_file to public;
grant select on fga_file to ods;
