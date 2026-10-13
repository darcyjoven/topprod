/*
================================================================================
檔案代號:aqd_file
檔案名稱:集团代收付基本设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aqd_file
(
aqd01       varchar2(10) NOT NULL,   /*帐款营运中心                           */
                                     /*For 內部帳戶                           */
aqd02       varchar2(10),            /*AR类型                                 */
                                     /*For 內部帳戶                           */
aqd03       varchar2(10),            /*AP类型                                 */
                                     /*For 內部帳戶                           */
aqd04       varchar2(6),             /*收款条件                               */
                                     /*For 內部帳戶                           */
aqd05       varchar2(6),             /*付款条件                               */
                                     /*For 內部帳戶                           */
aqd06       varchar2(20),            /*内部帐户                               */
                                     /*For 內部帳戶                           */
aqd07       varchar2(6),             /*AR税种                                 */
                                     /*For 內部帳戶                           */
aqd08       varchar2(6),             /*AP税种                                 */
                                     /*For 內部帳戶                           */
aqd09       varchar2(5),             /*AR杂项立帐单别                         */
                                     /*For 內部帳戶                           */
aqd10       varchar2(5),             /*AR杂项待抵单别                         */
                                     /*For 內部帳戶                           */
aqd11       varchar2(5),             /*AR冲帐单别                             */
                                     /*For 內部帳戶                           */
aqd12       varchar2(5),             /*AP杂项立帐单别                         */
                                     /*For 內部帳戶                           */
aqd13       varchar2(5),             /*AP杂项待抵单别                         */
                                     /*For 內部帳戶                           */
aqd14       varchar2(5),             /*AP冲帐单别                             */
                                     /*For 內部帳戶                           */
aqd15       varchar2(2),             /*银行存提异动码-存码                    */
                                     /*For 內部帳戶                           */
aqd16       varchar2(2),             /*银行存提异动码-提码                    */
                                     /*For 內部帳戶                           */
aqdacti     varchar2(1),             /*资料有效码                             */
                                     /*For 內部帳戶                           */
aqduser     varchar2(10),            /*资料所有者                             */
                                     /*For 內部帳戶                           */
aqdgrup     varchar2(10),            /*资料所有部门                           */
                                     /*For 內部帳戶                           */
aqdmodu     varchar2(10),            /*资料更改者                             */
                                     /*For 內部帳戶                           */
aqddate     date,                    /*最后更改日期                           */
                                     /*For 內部帳戶                           */
aqdorig     varchar2(10),            /*资料建立部门                           */
aqdoriu     varchar2(10)             /*资料建立者                             */
);

alter table aqd_file add  constraint aqd_pk primary key  (aqd01) enable validate;
grant select on aqd_file to tiptopgp;
grant update on aqd_file to tiptopgp;
grant delete on aqd_file to tiptopgp;
grant insert on aqd_file to tiptopgp;
grant index on aqd_file to public;
grant select on aqd_file to ods;
