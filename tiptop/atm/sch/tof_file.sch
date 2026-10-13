/*
================================================================================
檔案代號:tof_file
檔案名稱:媒体基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tof_file
(
tof01       varchar2(10) NOT NULL,   /*媒体编号                               */
tof02       varchar2(80),            /*媒体名称                               */
tof03       varchar2(4),             /*媒体类型                               */
tof04       varchar2(4),             /*媒体级别                               */
tof05       varchar2(10),            /*区域                                   */
tof06       varchar2(10),            /*省别                                   */
tof07       varchar2(10),            /*地级市                                 */
tof08       varchar2(10),            /*县级市                                 */
tof09       number(9),               /*收视人口                               */
tof10       varchar2(10),            /*付款方式                               */
tof11       varchar2(4),             /*惯用币种                               */
tof12       varchar2(4),             /*惯用税种                               */
tof13       varchar2(40),            /*联络人                                 */
tof14       varchar2(40),            /*电话                                   */
tof15       varchar2(40),            /*传真                                   */
tof16       varchar2(40),            /*Email                                  */
tof17       varchar2(255),           /*地址                                   */
tof18       varchar2(10),            /*邮编                                   */
tof19       varchar2(20),            /*税号                                   */
tof20       varchar2(30),            /*银行帐号                               */
tof21       varchar2(1),             /*收视范围                               */
tof22       varchar2(255),           /*备注                                   */
tofacti     varchar2(1),             /*有效否                                 */
tofuser     varchar2(10),            /*建档人员                               */
tofgrup     varchar2(10),            /*建档部门                               */
tofmodu     varchar2(10),            /*最后更改人员                           */
tofdate     date,                    /*最后更改日期                           */
tofud01     varchar2(255),           /*自订字段-Textedit                      */
tofud02     varchar2(40),            /*自订字段-文字                          */
tofud03     varchar2(40),            /*自订字段-文字                          */
tofud04     varchar2(40),            /*自订字段-文字                          */
tofud05     varchar2(40),            /*自订字段-文字                          */
tofud06     varchar2(40),            /*自订字段-文字                          */
tofud07     number(15,3),            /*自订字段-数值                          */
tofud08     number(15,3),            /*自订字段-数值                          */
tofud09     number(15,3),            /*自订字段-数值                          */
tofud10     number(10),              /*自订字段-整数                          */
tofud11     number(10),              /*自订字段-整数                          */
tofud12     number(10),              /*自订字段-整数                          */
tofud13     date,                    /*自订字段-日期                          */
tofud14     date,                    /*自订字段-日期                          */
tofud15     date,                    /*自订字段-日期                          */
toforiu     varchar2(10),            /*资料建立者                             */
toforig     varchar2(10)             /*资料建立部门                           */
);

alter table tof_file add  constraint tof_pk primary key  (tof01) enable validate;
grant select on tof_file to tiptopgp;
grant update on tof_file to tiptopgp;
grant delete on tof_file to tiptopgp;
grant insert on tof_file to tiptopgp;
grant index on tof_file to public;
grant select on tof_file to ods;
