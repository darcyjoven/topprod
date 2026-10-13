/*
================================================================================
檔案代號:lqv_file
檔案名稱:会员卡资讯重计变革单身档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lqv_file
(
lqv01       varchar2(20) DEFAULT ' ' NOT NULL, /*卡资讯变更单号*/
lqv02       number(5) DEFAULT '0' NOT NULL, /*变更序号*/
lqv03       varchar2(30),            /*会员卡号                               */
lqv04       date,                    /*变更前最后消费日                       */
lqv05       number(20,2),            /*变更前累计消费金额                     */
lqv06       number(20),              /*变更前累计消费次数                     */
lqv07       number(20),              /*变更前累计积分                         */
lqv08       number(20),              /*变更前已兑换积分                       */
lqv09       number(20),              /*变更前剩余积分                         */
lqv10       date,                    /*变更后最后消费日                       */
lqv11       number(20,2),            /*变更后累计消费金额                     */
lqv12       number(20),              /*变更后累计消费次数                     */
lqv13       number(20),              /*变更后累计积分                         */
lqv14       number(20),              /*变更后已兑换积分                       */
lqv15       number(20),              /*变更后剩余积分                         */
lqvlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
lqvplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table lqv_file add  constraint lqv_pk primary key  (lqv01,lqv02) enable validate;
grant select on lqv_file to tiptopgp;
grant update on lqv_file to tiptopgp;
grant delete on lqv_file to tiptopgp;
grant insert on lqv_file to tiptopgp;
grant index on lqv_file to public;
grant select on lqv_file to ods;
