/*
================================================================================
檔案代號:cnh_file
檔案名稱:模拟合同出口成品单身档 (A046)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cnh_file
(
cnh01       varchar2(20) NOT NULL,   /*模拟编号                               */
cnh02       number(5) NOT NULL,      /*序号                                   */
cnh03       varchar2(40),            /*产品编号                               */
                                     /*廠內料號                               */
cnh04       varchar2(1),             /*No Use                                 */
cnh05       number(15,3),            /*数量                                   */
cnh06       varchar2(4),             /*单位                                   */
cnh07       number(20,6),            /*单价                                   */
cnh08       number(20,6),            /*金额                                   */
cnh09       varchar2(1),             /*No Use                                 */
cnh10       varchar2(1),             /*No Use                                 */
cnh11       varchar2(10),            /*产络地                                 */
cnh12       varchar2(10),            /*征免性质                               */
cnhud01     varchar2(255),           /*自订字段-Textedit                      */
cnhud02     varchar2(40),            /*自订字段-文字                          */
cnhud03     varchar2(40),            /*自订字段-文字                          */
cnhud04     varchar2(40),            /*自订字段-文字                          */
cnhud05     varchar2(40),            /*自订字段-文字                          */
cnhud06     varchar2(40),            /*自订字段-文字                          */
cnhud07     number(15,3),            /*自订字段-数值                          */
cnhud08     number(15,3),            /*自订字段-数值                          */
cnhud09     number(15,3),            /*自订字段-数值                          */
cnhud10     number(10),              /*自订字段-整数                          */
cnhud11     number(10),              /*自订字段-整数                          */
cnhud12     number(10),              /*自订字段-整数                          */
cnhud13     date,                    /*自订字段-日期                          */
cnhud14     date,                    /*自订字段-日期                          */
cnhud15     date,                    /*自订字段-日期                          */
cnhplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cnhlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index cnh_02 on cnh_file (cnh03);
alter table cnh_file add  constraint cnh_pk primary key  (cnh01,cnh02) enable validate;
grant select on cnh_file to tiptopgp;
grant update on cnh_file to tiptopgp;
grant delete on cnh_file to tiptopgp;
grant insert on cnh_file to tiptopgp;
grant index on cnh_file to public;
grant select on cnh_file to ods;
