/*
================================================================================
檔案代號:bxj_file
檔案名稱:撷取后保税异动单据单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bxj_file
(
bxj01       varchar2(20) NOT NULL,   /*单号                                   */
bxj03       number(5) NOT NULL,      /*序号                                   */
bxj04       varchar2(40),            /*料号                                   */
bxj05       varchar2(4),             /*单位                                   */
                                     /*庫存單位                               */
bxj06       number(15,3),            /*数量                                   */
                                     /*庫存單位                               */
bxj07       varchar2(10),            /*仓库                                   */
bxj10       varchar2(255),           /*备注                                   */
bxj11       varchar2(40),            /*报单号码                               */
bxj12       varchar2(15),            /*厂内编号                               */
bxj13       varchar2(20),            /*放行单号                               */
bxj14       date,                    /*放行日期                               */
bxj15       number(20,6),            /*总金额                                 */
bxj16       number(15,3),            /*重量                                   */
bxj17       date,                    /*报单日期                               */
bxj18       varchar2(4),             /*单位                                   */
                                     /*異動單位                               */
bxj19       number(15,3),            /*数量                                   */
                                     /*異動單位                               */
bxj20       number(20,6),            /*本币单价                               */
bxj21       varchar2(10),            /*折合原因代码                           */
bxj22       varchar2(20),            /*受托加工订单单号                       */
bxj23       number(5),               /*受托加工订单项次                       */
bxjud01     varchar2(255),           /*自订字段-Textedit                      */
bxjud02     varchar2(40),            /*自订字段-文字                          */
bxjud03     varchar2(40),            /*自订字段-文字                          */
bxjud04     varchar2(40),            /*自订字段-文字                          */
bxjud05     varchar2(40),            /*自订字段-文字                          */
bxjud06     varchar2(40),            /*自订字段-文字                          */
bxjud07     number(15,3),            /*自订字段-数值                          */
bxjud08     number(15,3),            /*自订字段-数值                          */
bxjud09     number(15,3),            /*自订字段-数值                          */
bxjud10     number(10),              /*自订字段-整数                          */
bxjud11     number(10),              /*自订字段-整数                          */
bxjud12     number(10),              /*自订字段-整数                          */
bxjud13     date,                    /*自订字段-日期                          */
bxjud14     date,                    /*自订字段-日期                          */
bxjud15     date,                    /*自订字段-日期                          */
bxjplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bxjlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index bxj_03 on bxj_file (bxj11);
create        index bxj_02 on bxj_file (bxj04);
create        index bxj_04 on bxj_file (bxj13);
alter table bxj_file add  constraint bxj_pk primary key  (bxj01,bxj03) enable validate;
grant select on bxj_file to tiptopgp;
grant update on bxj_file to tiptopgp;
grant delete on bxj_file to tiptopgp;
grant insert on bxj_file to tiptopgp;
grant index on bxj_file to public;
grant select on bxj_file to ods;
