/*
================================================================================
檔案代號:rxu_file
檔案名稱:Webservice日志记录档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table rxu_file
(
rxu01       varchar2(40) DEFAULT ' ' NOT NULL, /*webservice ID*/
rxu02       varchar2(40) DEFAULT ' ' NOT NULL, /*明细ID*/
rxu03       varchar2(10) DEFAULT ' ' NOT NULL, /*门店编号*/
rxu04       varchar2(20),            /*POS单据编号                            */
rxu05       varchar2(40) DEFAULT ' ' NOT NULL, /*函数编号*/
rxu06       varchar2(2) DEFAULT ' ' NOT NULL, /*请求类型(1.密码修改2.积分累  */
rxu07       varchar2(30) DEFAULT ' ',/*用户名|卡号|券号                       */
rxu08       varchar2(40),            /*更新前资料                             */
rxu09       varchar2(40),            /*更新后资料                             */
rxu10       number(20,6),            /*本次异动                               */
rxu11       date,                    /*日期                                   */
rxu12       varchar2(8),             /*时间                                   */
rxuacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
rxu13       varchar2(10),            /*收银机号                               */
rxu14       varchar2(2) DEFAULT ' ' NOT NULL, /*单据类型(0.销售单1.原价退货2.*/
rxu15       number(20,6),            /*本次消费金额                           */
rxu16       varchar2(20)             /*异动单号                               */
);

alter table rxu_file add  constraint rxu_pk primary key  (rxu01,rxu02) enable validate;
grant select on rxu_file to tiptopgp;
grant update on rxu_file to tiptopgp;
grant delete on rxu_file to tiptopgp;
grant insert on rxu_file to tiptopgp;
grant index on rxu_file to public;
grant select on rxu_file to ods;
