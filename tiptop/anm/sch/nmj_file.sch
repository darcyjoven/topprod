/*
================================================================================
檔案代號:nmj_file
檔案名稱:银行预计存提资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table nmj_file
(
nmj01       varchar2(20),            /*银行编号                               */
                                     /*銀行編號                               */
nmj011      number(5),               /*项次                                   */
                                     /*項次                                   */
nmj02       date,                    /*日期                                   */
nmj03       varchar2(2),             /*核算项                                 */
                                     /*異動碼                                 */
nmj04       number(20,6),            /*金额                                   */
                                     /*金額                                   */
nmj05       varchar2(80),            /*摘要                                   */
nmj06       varchar2(1),             /*实现否                                 */
                                     /*實現否(Y/N)                            */
                                     /*若已實現則不列入資金預估狀況表         */
nmjud01     varchar2(255),           /*自订字段-Textedit                      */
nmjud02     varchar2(40),            /*自订字段-文字                          */
nmjud03     varchar2(40),            /*自订字段-文字                          */
nmjud04     varchar2(40),            /*自订字段-文字                          */
nmjud05     varchar2(40),            /*自订字段-文字                          */
nmjud06     varchar2(40),            /*自订字段-文字                          */
nmjud07     number(15,3),            /*自订字段-数值                          */
nmjud08     number(15,3),            /*自订字段-数值                          */
nmjud09     number(15,3),            /*自订字段-数值                          */
nmjud10     number(10),              /*自订字段-整数                          */
nmjud11     number(10),              /*自订字段-整数                          */
nmjud12     number(10),              /*自订字段-整数                          */
nmjud13     date,                    /*自订字段-日期                          */
nmjud14     date,                    /*自订字段-日期                          */
nmjud15     date,                    /*自订字段-日期                          */
nmjlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index nmj_01 on nmj_file (nmj01,nmj011);
grant select on nmj_file to tiptopgp;
grant update on nmj_file to tiptopgp;
grant delete on nmj_file to tiptopgp;
grant insert on nmj_file to tiptopgp;
grant index on nmj_file to public;
grant select on nmj_file to ods;
