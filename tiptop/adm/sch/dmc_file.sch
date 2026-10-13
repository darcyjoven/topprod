/*
================================================================================
檔案代號:dmc_file
檔案名稱:财务指标档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table dmc_file
(
dmc01       varchar2(6) NOT NULL,    /*类型代码                               */
dmc02       varchar2(6) NOT NULL,    /*版本代码                               */
dmc03       number(9,4),             /*总资产报酬率                           */
dmc04       number(20,6),            /*普通股每股盈余                         */
dmc05       number(20,6),            /*完全希释每股盈余                       */
dmc06       number(9,4),             /*本益比                                 */
dmc07       number(9,4),             /*股利支付比率                           */
dmc08       number(9,4),             /*股利收入比率                           */
dmc09       number(9,4),             /*普通股股东权益报酬率                   */
dmc10       number(20,6),            /*每股帐面值                             */
dmc11       number(20,6),            /*运用资金                               */
dmc12       number(9,4),             /*流动比率                               */
dmc13       number(9,4),             /*酸性试验比率                           */
dmc14       number(9,4),             /*应收帐周转次数                         */
dmc15       number(9,4),             /*平均收款期间                           */
dmc16       number(9,4),             /*存贷周转率                             */
dmc17       number(9,4),             /*存货销货期间                           */
dmc18       number(9,4),             /*利息保障倍数                           */
dmc19       number(9,4),             /*负债对股东权益比                       */
dmc20       number(9,4),             /*员工平均获利率                         */
dmc21       number(9,4),             /*员工平均生产率                         */
dmc22       number(6,3),             /*No Use                                 */
dmc23       number(6,3),             /*No Use                                 */
dmc24       number(6,3),             /*No Use                                 */
dmc25       number(6,3),             /*No Use                                 */
dmc26       number(6,3),             /*No Use                                 */
dmc27       number(6,3),             /*No Use                                 */
dmc28       number(6,3),             /*No Use                                 */
dmc29       number(6,3),             /*No Use                                 */
dmc30       number(6,3),             /*No Use                                 */
dmcacti     varchar2(1),             /*资料有效码                             */
dmcuser     varchar2(10),            /*资料所有者                             */
dmcgrup     varchar2(10),            /*资料所有群                             */
dmcmodu     varchar2(10),            /*资料更改者                             */
dmcdate     date,                    /*最近更改日                             */
dmcorig     varchar2(10),            /*资料建立部门                           */
dmcoriu     varchar2(10)             /*资料建立者                             */
);

alter table dmc_file add  constraint dmc_pk primary key  (dmc01,dmc02) enable validate;
grant select on dmc_file to tiptopgp;
grant update on dmc_file to tiptopgp;
grant delete on dmc_file to tiptopgp;
grant insert on dmc_file to tiptopgp;
grant index on dmc_file to public;
grant select on dmc_file to ods;
