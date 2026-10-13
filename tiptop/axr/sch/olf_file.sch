/*
================================================================================
檔案代號:olf_file
檔案名稱:信用状历史单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table olf_file
(
olf01       varchar2(20) NOT NULL,   /*收状单号                               */
                                     /*收狀單號                               */
olf011      number(5) NOT NULL,      /*更改序号                               */
                                     /*修改序號                               */
olf02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
olf03       varchar2(4),             /*单位                                   */
                                     /*單位                                   */
olf04       varchar2(20),            /*订单单号                               */
                                     /*訂單單號                               */
olf05       number(5),               /*订单项次                               */
                                     /*訂單項次                               */
olf06       number(20,6),            /*单价                                   */
                                     /*單價                                   */
olf07       number(15,3),            /*数量                                   */
                                     /*數量                                   */
olf08       number(20,6),            /*金额                                   */
                                     /*金額                                   */
olf09       varchar2(1),             /*No Use                                 */
olf10       varchar2(1),             /*No Use                                 */
olf11       varchar2(40),            /*料件编号                               */
                                     /*料件編號                               */
olf12       varchar2(1),             /*No Use                                 */
olf13       varchar2(1),             /*No Use                                 */
olf14       varchar2(1),             /*No Use                                 */
olf15       varchar2(1),             /*No Use                                 */
olf16       varchar2(1),             /*No Use                                 */
olf17       varchar2(1),             /*No Use                                 */
olf18       varchar2(1),             /*No Use                                 */
olf19       varchar2(1),             /*No Use                                 */
olf20       varchar2(1),             /*No Use                                 */
olf930      varchar2(10),            /*成本中心                               */
olfud01     varchar2(255),           /*自订字段-Textedit                      */
olfud02     varchar2(40),            /*自订字段-文字                          */
olfud03     varchar2(40),            /*自订字段-文字                          */
olfud04     varchar2(40),            /*自订字段-文字                          */
olfud05     varchar2(40),            /*自订字段-文字                          */
olfud06     varchar2(40),            /*自订字段-文字                          */
olfud07     number(15,3),            /*自订字段-数值                          */
olfud08     number(15,3),            /*自订字段-数值                          */
olfud09     number(15,3),            /*自订字段-数值                          */
olfud10     number(10),              /*自订字段-整数                          */
olfud11     number(10),              /*自订字段-整数                          */
olfud12     number(10),              /*自订字段-整数                          */
olfud13     date,                    /*自订字段-日期                          */
olfud14     date,                    /*自订字段-日期                          */
olfud15     date,                    /*自订字段-日期                          */
olflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index olf_02 on olf_file (olf04,olf05);
alter table olf_file add  constraint olf_pk primary key  (olf01,olf011,olf02) enable validate;
grant select on olf_file to tiptopgp;
grant update on olf_file to tiptopgp;
grant delete on olf_file to tiptopgp;
grant insert on olf_file to tiptopgp;
grant index on olf_file to public;
grant select on olf_file to ods;
