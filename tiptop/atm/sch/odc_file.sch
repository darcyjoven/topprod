/*
================================================================================
檔案代號:odc_file
檔案名稱:集团销售预测资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table odc_file
(
odc01       varchar2(10) NOT NULL,   /*预测版本                               */
odc02       varchar2(10) NOT NULL,   /*组织编号                               */
odc03       varchar2(10),            /*No Use                                 */
odc04       varchar2(10),            /*时距类型                               */
odc05       date,                    /*预测起始日期                           */
odc06       date,                    /*预测截止日期                           */
odc07       varchar2(10),            /*业务员                                 */
odc08       varchar2(10),            /*业务部门                               */
odc09       varchar2(4),             /*币种                                   */
odc10       number(20,10),           /*汇率                                   */
odc11       number(20,6),            /*目标金额                               */
odc12       varchar2(1),             /*销售预测审核码(y/n/x)                  */
odc121      varchar2(1),             /*上层调整审核码(y/n)                    */
odc13       varchar2(1),             /*目标金额审核码(y/n)                    */
odc131      varchar2(1),             /*目标数量审核码(y/n)                    */
odc14       number(15,3),            /*No Use                                 */
odc15       number(15,3),            /*No Use                                 */
odc16       number(15,3),            /*No Use                                 */
odc161      number(15,3),            /*No Use                                 */
odc162      number(15,3),            /*No Use                                 */
odc17       number(20,6),            /*No Use                                 */
odc18       number(20,6),            /*No Use                                 */
odc19       number(20,6),            /*No Use                                 */
odc191      number(20,6),            /*No Use                                 */
odc192      number(20,6),            /*No Use                                 */
odc20       number(15,3),            /*No Use                                 */
odc21       number(20,6),            /*No Use                                 */
odc22       varchar2(1),             /*No Use                                 */
odc23       number(15,3),            /*No Use                                 */
odc24       number(20,6),            /*No Use                                 */
odc25       number(15,3),            /*No Use                                 */
odc26       number(20,6),            /*No Use                                 */
odcuser     varchar2(10),            /*资料所有者                             */
odcgrup     varchar2(10),            /*资料所有部门                           */
odcmodu     varchar2(10),            /*资料更改者                             */
odcdate     date,                    /*最近更改日                             */
odc27       varchar2(1),             /*资料来源                               */
odcud01     varchar2(255),           /*自订字段-Textedit                      */
odcud02     varchar2(40),            /*自订字段-文字                          */
odcud03     varchar2(40),            /*自订字段-文字                          */
odcud04     varchar2(40),            /*自订字段-文字                          */
odcud05     varchar2(40),            /*自订字段-文字                          */
odcud06     varchar2(40),            /*自订字段-文字                          */
odcud07     number(15,3),            /*自订字段-数值                          */
odcud08     number(15,3),            /*自订字段-数值                          */
odcud09     number(15,3),            /*自订字段-数值                          */
odcud10     number(10),              /*自订字段-整数                          */
odcud11     number(10),              /*自订字段-整数                          */
odcud12     number(10),              /*自订字段-整数                          */
odcud13     date,                    /*自订字段-日期                          */
odcud14     date,                    /*自订字段-日期                          */
odcud15     date,                    /*自订字段-日期                          */
odcorig     varchar2(10),            /*资料建立部门                           */
odcoriu     varchar2(10)             /*资料建立者                             */
);

alter table odc_file add  constraint odc_pk primary key  (odc01,odc02) enable validate;
grant select on odc_file to tiptopgp;
grant update on odc_file to tiptopgp;
grant delete on odc_file to tiptopgp;
grant insert on odc_file to tiptopgp;
grant index on odc_file to public;
grant select on odc_file to ods;
