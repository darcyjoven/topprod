/*
================================================================================
檔案代號:odg_file
檔案名稱:预测模拟单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table odg_file
(
odg01       varchar2(10) NOT NULL,   /*预测版本                               */
odg02       varchar2(10) NOT NULL,   /*组织编号                               */
odg03       varchar2(40) NOT NULL,   /*预测料号                               */
odg04       number(20,6),            /*单价                                   */
odg05       varchar2(1),             /*基准资料                               */
odg06       varchar2(1),             /*预测模拟方式                           */
odg061      number(9,4),             /*百分比                                 */
odg062      number(5),               /*移动平均数-移动期数                    */
odg063      number(5),               /*加权移动平均数-移动期数                */
odg0631     number(15,3),            /*各期权数1                              */
odg06310    number(15,3),            /*各期权数10                             */
odg06311    number(15,3),            /*各期权数11                             */
odg06312    number(15,3),            /*各期权数12                             */
odg0632     number(15,3),            /*各期权数2                              */
odg0633     number(15,3),            /*各期权数3                              */
odg0634     number(15,3),            /*各期权数4                              */
odg0635     number(15,3),            /*各期权数5                              */
odg0636     number(15,3),            /*各期权数6                              */
odg0637     number(15,3),            /*各期权数7                              */
odg0638     number(15,3),            /*各期权数8                              */
odg0639     number(15,3),            /*各期权数9                              */
odg064      number(15,3),            /*平滑系数                               */
odg07       varchar2(1),             /*考虑季节因素(y/n)                      */
odg08       varchar2(1),             /*考虑市场因素(y/n)                      */
odg09       varchar2(1),             /*考虑促销力度(y/n)                      */
odg10       number(15,3),            /*平均绝对差异(mad)                      */
odg11       number(15,3),            /*平均方差(mse)                          */
odg12       varchar2(1),             /*已转预测资料                           */
odgacti     varchar2(1),             /*资料有效码                             */
odgdate     date,                    /*最近更改日                             */
odgegrup    varchar2(10),            /*资料所有部门                           */
odgmodu     varchar2(10),            /*资料更改者                             */
odguser     varchar2(10),            /*资料所有者                             */
odgud01     varchar2(255),           /*自订字段-Textedit                      */
odgud02     varchar2(40),            /*自订字段-文字                          */
odgud03     varchar2(40),            /*自订字段-文字                          */
odgud04     varchar2(40),            /*自订字段-文字                          */
odgud05     varchar2(40),            /*自订字段-文字                          */
odgud06     varchar2(40),            /*自订字段-文字                          */
odgud07     number(15,3),            /*自订字段-数值                          */
odgud08     number(15,3),            /*自订字段-数值                          */
odgud09     number(15,3),            /*自订字段-数值                          */
odgud10     number(10),              /*自订字段-整数                          */
odgud11     number(10),              /*自订字段-整数                          */
odgud12     number(10),              /*自订字段-整数                          */
odgud13     date,                    /*自订字段-日期                          */
odgud14     date,                    /*自订字段-日期                          */
odgud15     date,                    /*自订字段-日期                          */
odgoriu     varchar2(10),            /*资料建立者                             */
odgorig     varchar2(10)             /*资料建立部门                           */
);

alter table odg_file add  constraint odg_pk primary key  (odg01,odg02,odg03) enable validate;
grant select on odg_file to tiptopgp;
grant update on odg_file to tiptopgp;
grant delete on odg_file to tiptopgp;
grant insert on odg_file to tiptopgp;
grant index on odg_file to public;
grant select on odg_file to ods;
