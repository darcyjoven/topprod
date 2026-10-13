/*
================================================================================
檔案代號:rxy_file
檔案名稱:交款明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rxy_file
(
rxy00       varchar2(2) DEFAULT ' ' NOT NULL, /*单据别*/
rxy01       varchar2(20) DEFAULT ' ' NOT NULL, /*单号*/
rxy02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rxy03       varchar2(2),             /*款别                                   */
                                     /*01:订单                                */
                                     /*02:出货单                              */
                                     /*03:销退单                              */
                                     /*04:订金退回单artt700                   */
                                     /*05:押金收取单artt624                   */
                                     /*06:押金退回单artt625                   */
                                     /*07:费用单artt610                       */
                                     /*08:费用退款单artt615                   */
                                     /*09:赠品发放单artt603                   */
                                     /*10:赠品退还单artt604                   */
                                     /*11:交款单artt611                       */
                                     /*12:代收款单artt701                     */
                                     /*13:代退款单artt702                     */
                                     /*20:发卡almt610                         */
                                     /*21:储值卡充值almt620                   */
                                     /*22:储值卡退余额almt630                 */
                                     /*23:换卡almt616                         */
rxy04       varchar2(2),             /*款别类型                               */
rxy05       number(20,6),            /*交款金额                               */
rxy06       varchar2(40),            /*卡号/票号/账号/待抵单号                */
rxy07       number(5,2),             /*刷卡手续费率                           */
rxy08       number(20,6),            /*刷卡手续费额                           */
rxy09       number(20,6),            /*支票面额                               */
rxy10       date,                    /*出票日期                               */
rxy11       varchar2(40),            /*出票单位                               */
rxy12       varchar2(20),            /*卡券种类编号                           */
rxy13       varchar2(10),            /*券面额编号                             */
rxy14       varchar2(20),            /*券起始编号                             */
rxy15       varchar2(20),            /*券终止编号                             */
rxy16       number(5),               /*券数量                                 */
rxy17       number(20,6),            /*票券溢交款金额                         */
rxy18       varchar2(1),             /*退款类型                               */
rxy19       varchar2(1),             /*冲预收款类型                           */
rxy20       varchar2(1),             /*固定手续费                             */
rxy21       date,                    /*交款日期                               */
rxy22       varchar2(8),             /*交款时间                               */
rxy30       varchar2(10),            /*POS款别                                */
rxy31       varchar2(20),            /*销售单号                               */
rxylegal    varchar2(10) NOT NULL,   /*所属法人                               */
rxyplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rxy23       number(20),              /*抵现积分                               */
rxy32       number(5),               /*项次                                   */
rxy33       varchar2(1) DEFAULT ' ' NOT NULL, /*冲预收否*/
rxy34       varchar2(10)             /*代收款营运中心                         */
);

alter table rxy_file add  constraint rxy_pk primary key  (rxy00,rxy01,rxy02) enable validate;
grant select on rxy_file to tiptopgp;
grant update on rxy_file to tiptopgp;
grant delete on rxy_file to tiptopgp;
grant insert on rxy_file to tiptopgp;
grant index on rxy_file to public;
grant select on rxy_file to ods;
