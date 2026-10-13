/*
================================================================================
檔案代號:rap_file
檔案名稱:会员等级资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rap_file
(
rap01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rap02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销编号*/
rap03       varchar2(1) DEFAULT ' ' NOT NULL, /*促销类型,1.一般促销，2组合促*/
rap04       number(5) DEFAULT '0' NOT NULL, /*组别/项次*/
rap05       varchar2(20) DEFAULT ' ' NOT NULL, /*会员等级*/
rap06       number(20,6) DEFAULT '0' NOT NULL, /*特卖价*/
rap07       number(5,2),             /*折扣率%                                */
rap08       number(20,6) DEFAULT '0' NOT NULL, /*折让金额*/
rapacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
raplegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
rapplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rap09       varchar2(1) DEFAULT ' ' NOT NULL /*会员促销方式*/
);

alter table rap_file add  constraint rap_pk primary key  (rap01,rap02,rap03,rap04,rap05,rap09,rapplant) enable validate;
grant select on rap_file to tiptopgp;
grant update on rap_file to tiptopgp;
grant delete on rap_file to tiptopgp;
grant insert on rap_file to tiptopgp;
grant index on rap_file to public;
grant select on rap_file to ods;
