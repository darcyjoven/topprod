/*
================================================================================
檔案代號:cnp_file
檔案名稱:进出口集中报关货物申报单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cnp_file
(
cnp01       varchar2(20) NOT NULL,   /*单据编号                               */
cnp012      number(5) NOT NULL,      /*项号                                   */
cnp02       number(5),               /*备案序号                               */
cnp03       varchar2(40),            /*商品编号                               */
cnp04       varchar2(1),             /*No Use                                 */
cnp05       number(15,3),            /*数量                                   */
cnp06       varchar2(4),             /*单位                                   */
cnp07       number(20,6),            /*单价                                   */
cnp08       number(20,6),            /*金额                                   */
cnp09       number(5),               /*箱数                                   */
cnp10       number(15,3),            /*净重(公斤)                             */
cnp11       varchar2(10),            /*国家                                   */
cnp12       varchar2(20),            /*单据编号                               */
cnp13       number(5),               /*项次                                   */
cnp14       number(15,3),            /*毛重(公斤)                             */
cnp15       varchar2(10),            /*海关编号                               */
cnpud01     varchar2(255),           /*自订字段-Textedit                      */
cnpud02     varchar2(40),            /*自订字段-文字                          */
cnpud03     varchar2(40),            /*自订字段-文字                          */
cnpud04     varchar2(40),            /*自订字段-文字                          */
cnpud05     varchar2(40),            /*自订字段-文字                          */
cnpud06     varchar2(40),            /*自订字段-文字                          */
cnpud07     number(15,3),            /*自订字段-数值                          */
cnpud08     number(15,3),            /*自订字段-数值                          */
cnpud09     number(15,3),            /*自订字段-数值                          */
cnpud10     number(10),              /*自订字段-整数                          */
cnpud11     number(10),              /*自订字段-整数                          */
cnpud12     number(10),              /*自订字段-整数                          */
cnpud13     date,                    /*自订字段-日期                          */
cnpud14     date,                    /*自订字段-日期                          */
cnpud15     date,                    /*自订字段-日期                          */
cnpplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cnplegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index cnp_02 on cnp_file (cnp12,cnp13);
alter table cnp_file add  constraint cnp_pk primary key  (cnp01,cnp012) enable validate;
grant select on cnp_file to tiptopgp;
grant update on cnp_file to tiptopgp;
grant delete on cnp_file to tiptopgp;
grant insert on cnp_file to tiptopgp;
grant index on cnp_file to public;
grant select on cnp_file to ods;
