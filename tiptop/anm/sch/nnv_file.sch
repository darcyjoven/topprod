/*
================================================================================
檔案代號:nnv_file
檔案名稱:资金调拨档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nnv_file
(
nnv01       varchar2(20) NOT NULL,   /*调拨单号                               */
nnv02       date,                    /*调拨日期                               */
nnv03       varchar2(10),            /*部门编号                               */
nnv04       varchar2(4),             /*现金变动码                             */
nnv05       varchar2(10),            /*拨出营运中心                           */
nnv06       varchar2(20),            /*拨出银行                               */
nnv07       varchar2(2),             /*拨出异动码                             */
nnv08       varchar2(4),             /*拨出币种                               */
nnv09       number(20,10),           /*拨出汇率                               */
nnv10       number(20,6),            /*拨出原币                               */
nnv11       number(20,6),            /*拨出本币                               */
nnv12       varchar2(24),            /*拨出科目                               */
nnv13       varchar2(20),            /*手续费银行                             */
nnv14       varchar2(2),             /*手续费异动码                           */
nnv15       varchar2(4),             /*手续费币种                             */
nnv16       number(20,10),           /*手续费汇率                             */
nnv17       number(20,6),            /*手续费原币                             */
nnv18       number(20,6),            /*手续费本币                             */
nnv19       varchar2(24),            /*手续费科目                             */
nnv20       varchar2(10),            /*拨入营运中心                           */
nnv21       varchar2(20),            /*拨入银行                               */
nnv22       varchar2(2),             /*拨入异动码                             */
nnv23       varchar2(4),             /*拨入币种                               */
nnv24       number(20,10),           /*拨入汇率                               */
nnv25       number(20,6),            /*拨入原币                               */
nnv26       number(20,6),            /*拨入本币                               */
nnv27       varchar2(24),            /*拨入科目                               */
nnv28       number(9,4),             /*还款利率(%)                            */
nnv29       number(20,6),            /*已还原币金额                           */
nnv30       number(20,6),            /*已还本币金额                           */
nnv31       number(20,6),            /*已还原币利息                           */
nnv32       number(20,6),            /*已还本币利息                           */
nnv33       date,                    /*最后还息日                             */
nnv34       varchar2(20),            /*拨出凭证号码                           */
nnv35       varchar2(20),            /*拨入凭证号码                           */
nnv36       varchar2(1),             /*No Use                                 */
nnv37       varchar2(1),             /*No Use                                 */
nnv38       varchar2(1),             /*No Use                                 */
nnv39       varchar2(1),             /*No Use                                 */
nnv40       varchar2(1),             /*No Use                                 */
nnvconf     varchar2(1),             /*确认码                                 */
nnvacti     varchar2(1),             /*资料有效码                             */
nnvuser     varchar2(10),            /*资料所有者                             */
nnvgrup     varchar2(10),            /*资料所有群                             */
nnvmodu     varchar2(10),            /*资料更改者                             */
nnvdate     date,                    /*最近更改日                             */
nnv121      varchar2(24),            /*拨出科目二                             */
nnv191      varchar2(24),            /*手续费科目二                           */
nnv271      varchar2(24),            /*拨入科目二                             */
nnv41       varchar2(20),            /*拨出方内部帐户                         */
                                     /*For 內部帳戶                           */
nnv42       varchar2(20),            /*拨入方内部帐户                         */
                                     /*For 內部帳戶                           */
nnvud01     varchar2(255),           /*自订字段-Textedit                      */
nnvud02     varchar2(40),            /*自订字段-文字                          */
nnvud03     varchar2(40),            /*自订字段-文字                          */
nnvud04     varchar2(40),            /*自订字段-文字                          */
nnvud05     varchar2(40),            /*自订字段-文字                          */
nnvud06     varchar2(40),            /*自订字段-文字                          */
nnvud07     number(15,3),            /*自订字段-数值                          */
nnvud08     number(15,3),            /*自订字段-数值                          */
nnvud09     number(15,3),            /*自订字段-数值                          */
nnvud10     number(10),              /*自订字段-整数                          */
nnvud11     number(10),              /*自订字段-整数                          */
nnvud12     number(10),              /*自订字段-整数                          */
nnvud13     date,                    /*自订字段-日期                          */
nnvud14     date,                    /*自订字段-日期                          */
nnvud15     date,                    /*自订字段-日期                          */
nnvlegal    varchar2(10) NOT NULL,   /*所属法人                               */
nnvoriu     varchar2(10),            /*资料建立者                             */
nnvorig     varchar2(10)             /*资料建立部门                           */
);

alter table nnv_file add  constraint nnv_pk primary key  (nnv01) enable validate;
grant select on nnv_file to tiptopgp;
grant update on nnv_file to tiptopgp;
grant delete on nnv_file to tiptopgp;
grant insert on nnv_file to tiptopgp;
grant index on nnv_file to public;
grant select on nnv_file to ods;
