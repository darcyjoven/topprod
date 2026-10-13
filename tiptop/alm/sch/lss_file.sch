/*
================================================================================
檔案代號:lss_file
檔案名稱:换券设定单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lss_file
(
lss01       varchar2(20) DEFAULT ' ' NOT NULL, /*方案编号*/
lss02       number(20) DEFAULT '0' NOT NULL, /*积分达*/
lss03       number(20) DEFAULT '0' NOT NULL, /*累计消费达*/
lss04       number(20) DEFAULT '0' NOT NULL, /*兑换基数*/
lss05       number(20) DEFAULT '0' NOT NULL, /*兑换基数换券金额*/
lss06       varchar2(20),            /*No Use                                 */
lsslegal    varchar2(10) NOT NULL,   /*所属法人                               */
lssplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lss07       varchar2(10) DEFAULT ' ' NOT NULL, /*制订营运中心*/
lss00       varchar2(1) DEFAULT ' ' NOT NULL, /*兑换来源*/
                                     /*0.积分换券, 1.累计消费额换券           */
lss08       varchar2(20) DEFAULT ' ' NOT NULL /*卡种代号*/
);

alter table lss_file add  constraint lss_pk primary key  (lss00,lss01,lss02,lss03,lss07,lss08,lssplant) enable validate;
grant select on lss_file to tiptopgp;
grant update on lss_file to tiptopgp;
grant delete on lss_file to tiptopgp;
grant insert on lss_file to tiptopgp;
grant index on lss_file to public;
grant select on lss_file to ods;
