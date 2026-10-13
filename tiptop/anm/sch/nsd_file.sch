/*
================================================================================
檔案代號:nsd_file
檔案名稱:销账明细资料资料定义单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nsd_file
(
nsd01       varchar2(20) DEFAULT ' ' NOT NULL, /*银行编号*/
nsd02       varchar2(255),           /*备注                                   */
nsd03       varchar2(1),             /*年别                                   */
nsd04       number(5),               /*账号起始位置                           */
nsd05       number(5),               /*账号截止位置                           */
nsd06       number(5),               /*交易日期起始位置                       */
nsd07       number(5),               /*交易日期截止位置                       */
nsd08       number(5),
nsd09       number(5),               /*交易序号截止位置                       */
nsd10       number(5),               /*交易币种起始位置                       */
nsd11       number(5),               /*交易币种截止位置                       */
nsd12       number(5),               /*借方金额起始位置                       */
nsd13       number(5),               /*借方金额截止位置                       */
nsd14       number(5),               /*借方金额正负位置                       */
nsd15       number(5),               /*贷方金额起始位置                       */
nsd16       number(5),               /*贷方金额截止位置                       */
nsd17       number(5),               /*骀荡金额正负位置                       */
nsd18       number(5),               /*余额起始位置                           */
nsd19       number(5),               /*月截止位置                             */
nsd20       number(5),               /*余额正负位置                           */
nsd21       number(5),               /*金额含小数位数                         */
nsd22       varchar2(1),             /*金额含小数点                           */
nsd23       number(5),               /*支票号码起始位置                       */
nsd24       number(5),               /*支票号码截止位置                       */
nsd25       number(5),               /*交易代码起始位置                       */
nsd26       number(5),               /*交易代码截止位置                       */
nsd27       varchar2(20),            /*媒体档名                               */
nsd28       varchar2(1),             /*金额定义                               */
nsd29       number(5),               /*借贷别起始位置                         */
nsd30       number(5),               /*借贷别截止位置                         */
nsd31       number(5),               /*借贷金额起始位置                       */
nsd32       number(5),               /*借贷金额截止位置                       */
nsd33       number(5),               /*借贷金额正负位置                       */
nsd34       number(5),               /*备注起始位置                           */
nsd35       number(5)                /*备注截止位置                           */
);

alter table nsd_file add  constraint nsd_pk primary key  (nsd01) enable validate;
grant select on nsd_file to tiptopgp;
grant update on nsd_file to tiptopgp;
grant delete on nsd_file to tiptopgp;
grant insert on nsd_file to tiptopgp;
grant index on nsd_file to public;
grant select on nsd_file to ods;
