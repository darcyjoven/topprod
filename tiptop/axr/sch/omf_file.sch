/*
================================================================================
檔案代號:omf_file
檔案名稱:开票档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table omf_file
(
omf01       varchar2(100) DEFAULT ' ', /*发票号码*/
omf02       varchar2(20) DEFAULT ' ',/*发票代码                               */
omf03       date,                    /*发票日期                               */
omf04       varchar2(20),            /*账款编号                               */
omf05       varchar2(10),            /*客户编号                               */
omf051      varchar2(40),            /*简称                                   */
omf06       varchar2(4),             /*税种                                   */
omf061      number(9,4),             /*税率                                   */
omf07       varchar2(4),             /*币种                                   */
omf08       varchar2(1) DEFAULT ' ' NOT NULL, /*状态码*/
omf09       varchar2(10) DEFAULT ' ' NOT NULL, /*来源营运中心*/
omf10       varchar2(1) DEFAULT ' ' NOT NULL, /*单据类型*/
omf11       varchar2(20) DEFAULT ' ' NOT NULL, /*出货单号（销退单号）*/
omf12       number(5) DEFAULT '0' NOT NULL, /*项次*/
omf13       varchar2(40),            /*料件编号                               */
omf14       varchar2(120),           /*品名                                   */
omf15       varchar2(120),           /*规格                                   */
omf16       number(15,3) DEFAULT '0' NOT NULL, /*数量*/
omf17       varchar2(4),             /*单位                                   */
omf18       number(20,6) DEFAULT '0' NOT NULL, /*税前单价*/
omf19       number(20,6) DEFAULT '0' NOT NULL, /*税前金额*/
omf19t      number(20,6) DEFAULT '0' NOT NULL, /*含税金额*/
omf19x      number(20,6) DEFAULT '0' NOT NULL, /*税额*/
omf20       varchar2(10),            /*仓库编号                               */
omf201      varchar2(10),            /*库位编号                               */
omflegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
omfpost     varchar2(1) DEFAULT ' ' NOT NULL, /*过帐码*/
omf21       number(5) DEFAULT '0' NOT NULL, /*项次*/
omf22       number(20,10),           /*汇率                                   */
omf28       number(20,6) DEFAULT '0' NOT NULL, /*原币税前单价*/
omf29       number(20,6) DEFAULT '0' NOT NULL, /*原币税前金额*/
omf29t      number(20,6) DEFAULT '0' NOT NULL, /*原币含税金额*/
omf29x      number(20,6) DEFAULT '0' NOT NULL, /*原币税额*/
omf00       varchar2(20) DEFAULT ' ' NOT NULL, /*开票单号*/
omf202      varchar2(24),            /*批号                                   */
omf23       varchar2(1) DEFAULT ' ' NOT NULL, /*多仓位批出货否*/
omf910      varchar2(4),             /*单位一                                 */
omf911      number(20,8),            /*单位一换算率(与销售单位)               */
omf912      number(15,3) DEFAULT '0' NOT NULL, /*单位一数量*/
omf913      varchar2(4),             /*单位二                                 */
omf914      number(20,8),            /*单位二换算率(与销售单位)               */
omf915      number(15,3) DEFAULT '0' NOT NULL, /*单位二数量*/
omf916      varchar2(4),             /*计价单位                               */
omf917      number(15,3) DEFAULT '0' NOT NULL, /*计价数量*/
omf24       date,                    /*扣帐日期                               */
omf30       varchar2(255),           /*备注                                   */
omfuser     varchar2(10),            /*资料建立者                             */
omfdate     date,                    /*资料最近更改日                         */
omfgrup     varchar2(10),            /*资料建立群                             */
omforiu     varchar2(10),            /*资料所有群                             */
omforig     varchar2(10),            /*资料所有者                             */
omfmodu     varchar2(10),            /*资料更改者                             */
omf25       varchar2(20),
omf26       number(5),
omf31       date,                    /*发票日期                               */
omf32       varchar2(10),            /*开票人                                 */
omf33       varchar2(10),            /*开票部门                               */
omf27       varchar2(10),            /*出货客户编号                           */
omf271      varchar2(80)             /*客户简称                               */
);

alter table omf_file add  constraint omf_pk primary key  (omf00,omf21) enable validate;
grant select on omf_file to tiptopgp;
grant update on omf_file to tiptopgp;
grant delete on omf_file to tiptopgp;
grant insert on omf_file to tiptopgp;
grant index on omf_file to public;
grant select on omf_file to ods;
