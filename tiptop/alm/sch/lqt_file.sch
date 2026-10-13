/*
================================================================================
檔案代號:lqt_file
檔案名稱:会员等级变更单身档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lqt_file
(
lqt01       varchar2(20) DEFAULT ' ' NOT NULL, /*升等变更单号*/
lqt02       number(5) DEFAULT '0' NOT NULL, /*变更序号*/
lqt03       varchar2(20),            /*会员编号                               */
lqt04       varchar2(10),            /*变更前会员等级                         */
lqt05       number(20,2),            /*变更前累计消费金额                     */
lqt06       number(20),              /*变更时累计积分                         */
lqt07       number(20),              /*变更时累计消费次数                     */
lqt08       varchar2(10),            /*变更后会员等级                         */
lqtlegal    varchar2(10),            /*所属法人                               */
lqtplant    varchar2(10)             /*所属营运中心                           */
);

alter table lqt_file add  constraint lqt_pk primary key  (lqt01,lqt02) enable validate;
grant select on lqt_file to tiptopgp;
grant update on lqt_file to tiptopgp;
grant delete on lqt_file to tiptopgp;
grant insert on lqt_file to tiptopgp;
grant index on lqt_file to public;
grant select on lqt_file to ods;
