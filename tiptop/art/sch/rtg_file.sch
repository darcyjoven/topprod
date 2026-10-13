/*
================================================================================
檔案代號:rtg_file
檔案名稱:价格策略资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rtg_file
(
rtg01       varchar2(10) DEFAULT ' ' NOT NULL, /*价格策略编号*/
rtg02       number(10) DEFAULT '0' NOT NULL, /*项次*/
rtg03       varchar2(40),            /*产品编号                               */
rtg04       varchar2(4),             /*计价单位                               */
rtg05       number(20,6),            /*标准售价                               */
rtg06       number(20,6),            /*标准会员价                             */
rtg07       number(20,6),            /*标准最低价                             */
rtg08       varchar2(1) NOT NULL,    /*允许自定价                             */
rtg09       varchar2(1) NOT NULL,    /*有效否                                 */
rtgpos      varchar2(1) DEFAULT '1', /*已传POS否                              */
rtg10       varchar2(1) DEFAULT 'N' NOT NULL, /*開價否*/
rtg11       number(20,6),            /*最高退价                               */
rtg12       date                     /*生效日期                               */
);

create        index rtg_02 on rtg_file (rtg01,rtg03,rtg04);
alter table rtg_file add  constraint rtg_pk primary key  (rtg01,rtg02) enable validate;
grant select on rtg_file to tiptopgp;
grant update on rtg_file to tiptopgp;
grant delete on rtg_file to tiptopgp;
grant insert on rtg_file to tiptopgp;
grant index on rtg_file to public;
grant select on rtg_file to ods;
