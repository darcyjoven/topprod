/*
================================================================================
檔案代號:omc_file
檔案名稱:应收系统多账期明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table omc_file
(
omc01       varchar2(20) NOT NULL,   /*应收帐款编号                           */
omc02       number(5) NOT NULL,      /*项次                                   */
omc03       varchar2(6),             /*子收款条件                             */
omc04       date,                    /*应收款日                               */
omc05       date,                    /*容许票据到期日                         */
omc06       number(20,10),           /*汇率                                   */
omc07       number(20,10),           /*重估汇率                               */
omc08       number(20,6),            /*原币应收含税金额                       */
omc09       number(20,6),            /*本币应收含税金额                       */
omc10       number(20,6),            /*原币已冲金额                           */
omc11       number(20,6),            /*本币已冲金额                           */
omc12       varchar2(20),            /*发票号码                               */
omc13       number(20,6),            /*本币未冲金额                           */
omc14       number(20,6),            /*原币直接冲帐金额                       */
omc15       number(20,6),            /*本币直接冲帐金额                       */
omclegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table omc_file add  constraint omc_pk primary key  (omc01,omc02) enable validate;
grant select on omc_file to tiptopgp;
grant update on omc_file to tiptopgp;
grant delete on omc_file to tiptopgp;
grant insert on omc_file to tiptopgp;
grant index on omc_file to public;
grant select on omc_file to ods;
