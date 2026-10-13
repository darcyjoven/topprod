/*
================================================================================
檔案代號:rtl_file
檔案名稱:机构交易价格档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rtl_file
(
rtl01       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心代码*/
rtl02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rtl03       varchar2(10),            /*交易营运中心编号                       */
rtl04       varchar2(1),             /*交易价类型                             */
                                     /*1:成本价 2:售价 3:调拨订价             */
rtl05       varchar2(10),            /*交易订价编号                           */
rtl06       number(5,2),             /*调价比例%                              */
rtl07       varchar2(10),            /*类型                                   */
rtlacti     varchar2(1),             /*资料有效码                             */
rtlcrat     date,                    /*资料创建日                             */
rtldate     date,                    /*最近更改日                             */
rtlgrup     varchar2(10),            /*资料所有部门                           */
rtlmodu     varchar2(10),            /*资料更改者                             */
rtluser     varchar2(10),            /*资料所有者                             */
rtlorig     varchar2(10),            /*资料建立部门                           */
rtloriu     varchar2(10)             /*资料建立者                             */
);

create        index rtl_02 on rtl_file (rtl01,rtl03,rtl07);
alter table rtl_file add  constraint rtl_pk primary key  (rtl01,rtl02) enable validate;
grant select on rtl_file to tiptopgp;
grant update on rtl_file to tiptopgp;
grant delete on rtl_file to tiptopgp;
grant insert on rtl_file to tiptopgp;
grant index on rtl_file to public;
grant select on rtl_file to ods;
