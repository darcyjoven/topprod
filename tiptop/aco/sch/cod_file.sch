/*
================================================================================
檔案代號:cod_file
檔案名稱:合同出口成品基本资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cod_file
(
cod01       varchar2(20) NOT NULL,   /*申请编号                               */
cod02       number(5) NOT NULL,      /*序号                                   */
cod03       varchar2(40),            /*商品编号                               */
cod04       varchar2(10),            /*海关编号                               */
cod041      varchar2(20),            /*BOM版本编号                            */
cod05       number(15,3),            /*申请数量                               */
cod051      number(15,3),            /*合同转入                               */
cod06       varchar2(4),             /*单位                                   */
cod07       number(20,6),            /*单价                                   */
cod08       number(20,6),            /*金额                                   */
cod09       number(15,3),            /*结转出口数量                           */
cod091      number(15,3),            /*结转进口数量                           */
cod10       number(15,3),            /*加签数量                               */
cod101      number(15,3),            /*转厂出口数量                           */
cod102      number(15,3),            /*转厂进口数量                           */
cod103      number(15,3),            /*退港出口数量                           */
cod104      number(15,3),            /*退港进口数量                           */
cod105      number(15,3),            /*报废数量                               */
cod106      number(15,3),            /*内销出货数量                           */
cod11       varchar2(10),            /*产络地                                 */
cod12       varchar2(10),            /*征免性质                               */
codud01     varchar2(255),           /*自订字段-Textedit                      */
codud02     varchar2(40),            /*自订字段-文字                          */
codud03     varchar2(40),            /*自订字段-文字                          */
codud04     varchar2(40),            /*自订字段-文字                          */
codud05     varchar2(40),            /*自订字段-文字                          */
codud06     varchar2(40),            /*自订字段-文字                          */
codud07     number(15,3),            /*自订字段-数值                          */
codud08     number(15,3),            /*自订字段-数值                          */
codud09     number(15,3),            /*自订字段-数值                          */
codud10     number(10),              /*自订字段-整数                          */
codud11     number(10),              /*自订字段-整数                          */
codud12     number(10),              /*自订字段-整数                          */
codud13     date,                    /*自订字段-日期                          */
codud14     date,                    /*自订字段-日期                          */
codud15     date,                    /*自订字段-日期                          */
codplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
codlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index cod_02 on cod_file (cod03,cod041,cod04);
alter table cod_file add  constraint cod_pk primary key  (cod01,cod02) enable validate;
grant select on cod_file to tiptopgp;
grant update on cod_file to tiptopgp;
grant delete on cod_file to tiptopgp;
grant insert on cod_file to tiptopgp;
grant index on cod_file to public;
grant select on cod_file to ods;
