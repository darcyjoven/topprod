/*
================================================================================
檔案代號:apc_file
檔案名稱:应付系统多账期明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table apc_file
(
apc01       varchar2(20) NOT NULL,   /*应付帐款编号                           */
apc02       number(5) NOT NULL,      /*项次                                   */
apc03       varchar2(10) NOT NULL,   /*子收款条件                             */
apc04       date,                    /*应付款日                               */
apc05       date,                    /*容许票据到期日                         */
apc06       number(20,10),           /*汇率                                   */
apc07       number(20,10),           /*重估汇率                               */
apc08       number(20,6),            /*原币合计                               */
apc09       number(20,6),            /*本币合计                               */
apc10       number(20,6),            /*原币已付金额                           */
apc11       number(20,6),            /*本币已付金额                           */
apc12       varchar2(20),            /*发票号码                               */
apc13       number(20,6),            /*本币未冲金额                           */
apc14       number(20,6),            /*原币直接冲帐金额                       */
apc15       number(20,6),            /*本币直接冲帐金额                       */
apc16       number(20,6),            /*原币留置金额                           */
apclegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table apc_file add  constraint apc_pk primary key  (apc01,apc02) enable validate;
grant select on apc_file to tiptopgp;
grant update on apc_file to tiptopgp;
grant delete on apc_file to tiptopgp;
grant insert on apc_file to tiptopgp;
grant index on apc_file to public;
grant select on apc_file to ods;
