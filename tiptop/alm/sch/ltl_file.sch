/*
================================================================================
檔案代號:ltl_file
檔案名稱:积分/折扣规则排除明细变更文件
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ltl_file
(
ltl00       varchar2(1) DEFAULT ' ' NOT NULL, /*规则类型*/
ltl01       varchar2(20),            /*卡种编号                               */
ltl02       varchar2(40) DEFAULT ' ' NOT NULL, /*代码*/
ltl03       date,                    /*生效日期                               */
ltl04       date,                    /*失效日期                               */
ltl05       varchar2(10) DEFAULT ' ' NOT NULL, /*制订营运中心*/
ltl06       varchar2(20) DEFAULT ' ' NOT NULL, /*规则单号*/
ltl07       number(5) DEFAULT '0' NOT NULL, /*版本号*/
ltlacti     varchar2(1) NOT NULL,    /*资料有效码                             */
ltllegal    varchar2(10) NOT NULL,   /*所属法人                               */
ltlplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table ltl_file add  constraint ltl_pk primary key  (ltl05,ltl06,ltl07,ltl02,ltlplant) enable validate;
grant select on ltl_file to tiptopgp;
grant update on ltl_file to tiptopgp;
grant delete on ltl_file to tiptopgp;
grant insert on ltl_file to tiptopgp;
grant index on ltl_file to public;
grant select on ltl_file to ods;
