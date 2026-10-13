/*
================================================================================
檔案代號:cmh_file
檔案名稱:LCM 逆推成品明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cmh_file
(
cmh01       number(5) DEFAULT '0' NOT NULL, /*年度*/
cmh02       number(5) DEFAULT '0' NOT NULL, /*期别*/
cmh03       varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
cmh031      number(16,8),            /*单位用量                               */
cmh04       varchar2(40) DEFAULT ' ' NOT NULL, /*逆推成品料号*/
cmh041      number(20,6),            /*逆推成品净变现单价                     */
cmh05       number(15,3),            /*逆推成品生产入库量                     */
cmh06       number(15,3),            /*逆推成品出货量                         */
cmh07       date,                    /*计算起始日                             */
cmh08       date,                    /*计算截止日                             */
cmhdate     date,                    /*最近更改日                             */
cmhgrup     varchar2(10),            /*资料所有部门                           */
cmhmodu     varchar2(10),            /*资料更改者                             */
cmhuser     varchar2(10),            /*资料所有者                             */
cmhorig     varchar2(10),            /*资料建立部门                           */
cmhoriu     varchar2(10),            /*资料建立者                             */
cmh071      varchar2(1) DEFAULT '1' NOT NULL, /*成本计算类型*/
cmh081      varchar2(40) DEFAULT ' ' NOT NULL, /*类别代号(批次号/专案号/利润 */
cmhlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cmh_file add  constraint cmh_pk primary key  (cmh01,cmh02,cmh03,cmh04,cmh071,cmh081) enable validate;
grant select on cmh_file to tiptopgp;
grant update on cmh_file to tiptopgp;
grant delete on cmh_file to tiptopgp;
grant insert on cmh_file to tiptopgp;
grant index on cmh_file to public;
grant select on cmh_file to ods;
