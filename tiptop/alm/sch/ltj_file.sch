/*
================================================================================
檔案代號:ltj_file
檔案名稱:积分/折扣/储值加值规则变更单身文件
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ltj_file
(
ltj00       varchar2(1) DEFAULT ' ' NOT NULL, /*规则类型*/
ltj01       varchar2(20),            /*卡种编号                               */
ltj02       varchar2(40) DEFAULT ' ' NOT NULL, /*代码*/
ltj03       number(20),              /*积分基准                               */
ltj04       number(20),              /*单位积分                               */
ltj05       number(6,2),             /*折扣率                                 */
ltj06       number(20,6) DEFAULT '0' NOT NULL, /*充值基准*/
ltj07       number(20,6) DEFAULT '0' NOT NULL, /*优惠加值*/
ltj08       number(20,6) DEFAULT '0' NOT NULL, /*优惠加值%*/
ltj09       varchar2(1) DEFAULT ' ' NOT NULL, /*整倍否*/
ltj10       date,                    /*生效日期                               */
ltj11       date,                    /*失效日期                               */
ltj12       varchar2(10) DEFAULT ' ' NOT NULL, /*制订营运中心*/
ltj13       varchar2(20) DEFAULT ' ' NOT NULL, /*规则单号*/
ltj14       number(5) DEFAULT '0' NOT NULL, /*版本号*/
ltjacti     varchar2(1) NOT NULL,    /*资料有效码                             */
ltjlegal    varchar2(10) NOT NULL,   /*所属法人                               */
ltjplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table ltj_file add  constraint ltj_pk primary key  (ltj02,ltj06,ltj12,ltj13,ltj14,ltjplant) enable validate;
grant select on ltj_file to tiptopgp;
grant update on ltj_file to tiptopgp;
grant delete on ltj_file to tiptopgp;
grant insert on ltj_file to tiptopgp;
grant index on ltj_file to public;
grant select on ltj_file to ods;
