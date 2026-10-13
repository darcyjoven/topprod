/*
================================================================================
檔案代號:omj_file
檔案名稱:NoUse
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table omj_file
(
omj001      date DEFAULT sysdate NOT NULL, /*交易日期*/
omj002      varchar2(10) DEFAULT ' ' NOT NULL, /*門店編碼*/
omj003      varchar2(10) DEFAULT ' ' NOT NULL, /*POS机号*/
omj004      varchar2(4) DEFAULT ' ', /*税种                                   */
omj005      varchar2(1) DEFAULT ' ' NOT NULL, /*发票联数*/
omj006      varchar2(1) DEFAULT ' ' NOT NULL, /*性质*/
omj007      varchar2(20) DEFAULT ' ' NOT NULL, /*发票号码起始流水号位数*/
omj008      varchar2(20) DEFAULT ' ' NOT NULL, /*发票号码截止流水号位数*/
omj009      number(20,6) DEFAULT '0',/*应税销售金额(净)                       */
omj010      number(20,6) DEFAULT '0',/*免税销售金额(净)                       */
omj011      number(20,6) DEFAULT '0',/*销售税额                               */
omj012      number(20,6) DEFAULT '0',/*礼券已开发票金额                       */
omj013      number(20,6) DEFAULT '0',/*礼券已开发票税额                       */
omj014      number(20,6) DEFAULT '0',/*发票总金额                             */
omj015      number(20,6) DEFAULT '0',/*发票应税金额                           */
omj016      number(20,6) DEFAULT '0',/*发票税前金额                           */
omj017      number(20,6) DEFAULT '0',/*发票税额                               */
omj018      number(20,6) DEFAULT '0',/*已开发票留抵税额                       */
omjdate     date,                    /*资料录入日                             */
omjgrup     varchar2(10),            /*资料所有部门                           */
omjlegal    varchar2(10),            /*所属法人                               */
omjmodd     date,                    /*最近更改日                             */
omjmodu     varchar2(10),            /*资料更改者                             */
omjorig     varchar2(10),            /*资料建立部门                           */
omjoriu     varchar2(10),            /*资料建立者                             */
omjuser     varchar2(10),            /*资料所有者                             */
omj019      varchar2(2),             /*媒体申报格式                           */
omj020      varchar2(1) DEFAULT '1' NOT NULL, /*开立方式*/
omj021      varchar2(20)             /*买受人统一编号                         */
);

create        index omj_02 on omj_file (omj001,omj002,omj003,omj005,omj007,omj008);
alter table omj_file add  constraint omj_pk primary key  (omj001,omj002,omj003,omj005,omj007,omj008) enable validate;
grant select on omj_file to tiptopgp;
grant update on omj_file to tiptopgp;
grant delete on omj_file to tiptopgp;
grant insert on omj_file to tiptopgp;
grant index on omj_file to public;
grant select on omj_file to ods;
