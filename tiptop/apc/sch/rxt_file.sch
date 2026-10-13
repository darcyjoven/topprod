/*
================================================================================
檔案代號:rxt_file
檔案名稱:Webservice差异调整单单身档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rxt_file
(
rxt01       varchar2(20) DEFAULT ' ' NOT NULL, /*单号*/
rxt02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rxt03       varchar2(10),            /*门店编号                               */
rxt04       varchar2(10),            /*POS机号                                */
rxt05       varchar2(2) DEFAULT ' ' NOT NULL, /*单据类型(0.销售单1.原价退货2.*/
rxt06       varchar2(20),            /*单据编号                               */
rxt07       varchar2(40),            /*请求ID                                 */
rxt08       varchar2(2) DEFAULT ' ' NOT NULL, /*请求类型(1.密码修改2.积分累  */
rxt09       varchar2(30),            /*用户或卡号或券号                       */
rxt10       varchar2(40),            /*更新前资料                             */
rxt11       varchar2(40),            /*更新后资料                             */
rxt12       number(20,6),            /*本次异动                               */
rxt13       number(20,6),            /*本次消费额                             */
rxt14       date,                    /*请求日期                               */
rxt15       varchar2(8),             /*请求时间                               */
rxt16       varchar2(1) DEFAULT ' ' NOT NULL, /*异常方式*/
rxt17       varchar2(1) DEFAULT ' ' NOT NULL, /*服务状态*/
rxtlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
rxtplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rxt18       varchar2(20)             /*异动单号                               */
);

alter table rxt_file add  constraint rxt_pk primary key  (rxt01,rxt02) enable validate;
grant select on rxt_file to tiptopgp;
grant update on rxt_file to tiptopgp;
grant delete on rxt_file to tiptopgp;
grant insert on rxt_file to tiptopgp;
grant index on rxt_file to public;
grant select on rxt_file to ods;
