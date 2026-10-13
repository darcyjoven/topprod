/*
================================================================================
檔案代號:cnj_file
檔案名稱:模拟合同进口材料单身档 (A046)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cnj_file
(
cnj01       varchar2(20) NOT NULL,   /*模拟编号                               */
cnj02       number(5) NOT NULL,      /*序号                                   */
cnj03       varchar2(40),            /*产品编号                               */
                                     /*廠內料號                               */
cnj04       varchar2(1),             /*No Use                                 */
cnj05       number(15,3),            /*数量                                   */
cnj06       varchar2(4),             /*单位                                   */
cnj07       number(20,6),            /*单价                                   */
cnj08       number(20,6),            /*金额                                   */
cnj09       varchar2(1),             /*No Use                                 */
cnj10       varchar2(1),             /*No Use                                 */
cnj11       varchar2(10),            /*产地                                   */
cnj12       varchar2(10),            /*征免性质                               */
cnjud01     varchar2(255),           /*自订字段-Textedit                      */
cnjud02     varchar2(40),            /*自订字段-文字                          */
cnjud03     varchar2(40),            /*自订字段-文字                          */
cnjud04     varchar2(40),            /*自订字段-文字                          */
cnjud05     varchar2(40),            /*自订字段-文字                          */
cnjud06     varchar2(40),            /*自订字段-文字                          */
cnjud07     number(15,3),            /*自订字段-数值                          */
cnjud08     number(15,3),            /*自订字段-数值                          */
cnjud09     number(15,3),            /*自订字段-数值                          */
cnjud10     number(10),              /*自订字段-整数                          */
cnjud11     number(10),              /*自订字段-整数                          */
cnjud12     number(10),              /*自订字段-整数                          */
cnjud13     date,                    /*自订字段-日期                          */
cnjud14     date,                    /*自订字段-日期                          */
cnjud15     date,                    /*自订字段-日期                          */
cnjplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cnjlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index cnj_02 on cnj_file (cnj03);
alter table cnj_file add  constraint cnj_pk primary key  (cnj01,cnj02) enable validate;
grant select on cnj_file to tiptopgp;
grant update on cnj_file to tiptopgp;
grant delete on cnj_file to tiptopgp;
grant insert on cnj_file to tiptopgp;
grant index on cnj_file to public;
grant select on cnj_file to ods;
