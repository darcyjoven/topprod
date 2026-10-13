/*
================================================================================
檔案代號:oepa_file
檔案名稱:订单变更单多帐期明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oepa_file
(
oepa01      varchar2(20) DEFAULT ' ' NOT NULL, /*订单单号*/
oepa011     number(5) DEFAULT '0' NOT NULL, /*变更序号*/
oepa02      varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
oepa03      number(5) DEFAULT '0' NOT NULL, /*期别*/
oepa04a     varchar2(6),             /*变更后子收款条件                       */
oepa04b     varchar2(6),             /*变更前子收款条件                       */
oepa05a     date,                    /*变更后应收款日                         */
oepa05b     date,                    /*变更前应收款日                         */
oepa06a     date,                    /*变更后容许票据到期日                   */
oepa06b     date,                    /*变更前容许票据到期日                   */
oepa07a     number(20,10),           /*变更后汇率                             */
oepa07b     number(20,10),           /*变更前汇率                             */
oepa08a     number(20,6),            /*变更后应收金额                         */
oepa08b     number(20,6),            /*变更前应收金额                         */
oepalegal   varchar2(10),            /*所属法人                               */
oepaplant   varchar2(10)             /*所属营运中心                           */
);

alter table oepa_file add  constraint oepa_pk primary key  (oepa01,oepa011,oepa02,oepa03) enable validate;
grant select on oepa_file to tiptopgp;
grant update on oepa_file to tiptopgp;
grant delete on oepa_file to tiptopgp;
grant insert on oepa_file to tiptopgp;
grant index on oepa_file to public;
grant select on oepa_file to ods;
