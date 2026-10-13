/*
================================================================================
檔案代號:cmg_file
檔案名稱:LCM 成品原料单价明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cmg_file
(
cmg01       number(5) DEFAULT '0' NOT NULL, /*年度*/
cmg02       number(5) DEFAULT '0' NOT NULL, /*期别*/
cmg03       varchar2(40) DEFAULT ' ' NOT NULL, /*料号*/
cmg04       number(5) DEFAULT '0' NOT NULL, /*项次*/
cmg05       varchar2(1),             /*类型                                   */
cmg06       varchar2(20),            /*单据编码                               */
cmg07       number(5),               /*单据项次                               */
cmg08       number(20,6),            /*价格                                   */
cmg09       date,                    /*单据日期                               */
cmg10       number(15,3),            /*数量                                   */
cmg11       varchar2(4),             /*单位                                   */
cmg11_fac   number(20,8),            /*单位转换率（对销售单位）               */
cmg071      varchar2(1) DEFAULT '1' NOT NULL, /*成本计算类型*/
cmg081      varchar2(40) DEFAULT ' ' NOT NULL, /*类别代号(批次号/专案号/利润 */
cmglegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cmg_file add  constraint cmg_pk primary key  (cmg01,cmg02,cmg03,cmg04,cmg071,cmg081) enable validate;
grant select on cmg_file to tiptopgp;
grant update on cmg_file to tiptopgp;
grant delete on cmg_file to tiptopgp;
grant insert on cmg_file to tiptopgp;
grant index on cmg_file to public;
grant select on cmg_file to ods;
