/*
================================================================================
檔案代號:ode_file
檔案名稱:集团销售预测资料明细单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ode_file
(
ode01       varchar2(10) NOT NULL,   /*预测版本                               */
ode02       varchar2(10) NOT NULL,   /*组织编号                               */
ode03       number(5) NOT NULL,      /*序号                                   */
ode031      varchar2(40),            /*预测料号                               */
ode032      varchar2(8),             /*No Use                                 */
ode033      varchar2(6),             /*No Use                                 */
ode04       date NOT NULL,           /*时距日期                               */
ode05       number(15,3),            /*历史量                                 */
ode06       number(15,3),            /*预测量                                 */
ode07       number(15,3),            /*上层调整量                             */
ode071      number(15,3),            /*下层总量                               */
ode08       number(15,3),            /*目标调整数量                           */
ode09       number(15,3),            /*预测总数量  ode06+ode07+ode071+ode0    */
ode10       number(20,6),            /*单价                                   */
ode11       number(20,6),            /*预测金额                               */
ode12       number(20,6),            /*上层调整金额                           */
ode121      number(20,6),            /*下层总金额                             */
ode13       number(20,6),            /*目标调整金额                           */
ode14       number(20,6),            /*预测总金额  ode11+ode12+ode121+ode1    */
ode15       number(20,6),            /*历史金额                               */
odeud01     varchar2(255),           /*自订字段-Textedit                      */
odeud02     varchar2(40),            /*自订字段-文字                          */
odeud03     varchar2(40),            /*自订字段-文字                          */
odeud04     varchar2(40),            /*自订字段-文字                          */
odeud05     varchar2(40),            /*自订字段-文字                          */
odeud06     varchar2(40),            /*自订字段-文字                          */
odeud07     number(15,3),            /*自订字段-数值                          */
odeud08     number(15,3),            /*自订字段-数值                          */
odeud09     number(15,3),            /*自订字段-数值                          */
odeud10     number(10),              /*自订字段-整数                          */
odeud11     number(10),              /*自订字段-整数                          */
odeud12     number(10),              /*自订字段-整数                          */
odeud13     date,                    /*自订字段-日期                          */
odeud14     date,                    /*自订字段-日期                          */
odeud15     date                     /*自订字段-日期                          */
);

alter table ode_file add  constraint ode_pk primary key  (ode01,ode02,ode03,ode04) enable validate;
grant select on ode_file to tiptopgp;
grant update on ode_file to tiptopgp;
grant delete on ode_file to tiptopgp;
grant insert on ode_file to tiptopgp;
grant index on ode_file to public;
grant select on ode_file to ods;
