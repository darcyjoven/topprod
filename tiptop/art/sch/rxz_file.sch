/*
================================================================================
檔案代號:rxz_file
檔案名稱:刷卡明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rxz_file
(
rxz00       varchar2(2) DEFAULT ' ' NOT NULL, /*单据别*/
rxz01       varchar2(20) DEFAULT ' ' NOT NULL, /*单号*/
rxz02       varchar2(2),             /*款别类型                               */
rxz03       number(5) DEFAULT '0' NOT NULL, /*刷卡序号*/
rxz04       varchar2(40),            /*卡号                                   */
rxz05       number(20,6),            /*刷卡金额                               */
rxz06       date,                    /*刷卡日期                               */
rxz07       varchar2(8),             /*刷卡时间                               */
rxz08       varchar2(10),            /*刷卡人员                               */
rxz09       number(20,6),            /*刷卡手续费额                           */
rxz10       number(5,2),             /*刷卡手续费率                           */
rxz11       varchar2(40),            /*银行名称                               */
rxz12       varchar2(1),             /*银行注册否                             */
rxz13       varchar2(1),             /*状态                                   */
rxz14       varchar2(40),            /*状态说明                               */
rxz15       varchar2(1),             /*固定手续费                             */
rxz20       varchar2(1),             /*卡类型                                 */
rxz21       varchar2(20),            /*销售单号                               */
rxzlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rxzplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table rxz_file add  constraint rxz_pk primary key  (rxz00,rxz01,rxz03) enable validate;
grant select on rxz_file to tiptopgp;
grant update on rxz_file to tiptopgp;
grant delete on rxz_file to tiptopgp;
grant insert on rxz_file to tiptopgp;
grant index on rxz_file to public;
grant select on rxz_file to ods;
