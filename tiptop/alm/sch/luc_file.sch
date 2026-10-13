/*
================================================================================
檔案代號:luc_file
檔案名稱:费用退款单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table luc_file
(
luc01       varchar2(20) DEFAULT ' ' NOT NULL, /*退款单号*/
luc02       varchar2(1) DEFAULT ' ' NOT NULL, /*商户来源*/
luc03       varchar2(10),            /*商户编号                               */
luc031      varchar2(20),            /*商户简称                               */
luc04       varchar2(20),            /*合约编号                               */
luc05       varchar2(20),            /*摊位编号                               */
luc06       number(20,6) DEFAULT '0',/*未税支出总金额                         */
luc06t      number(20,6) DEFAULT '0',/*含税支出总金额                         */
luc07       date,                    /*单据日期                               */
luc08       varchar2(60),            /*备注                                   */
luc09       varchar2(1) DEFAULT ' ' NOT NULL, /*系统自动生成*/
luc10       varchar2(1) DEFAULT ' ' NOT NULL, /*来源作业*/
luc11       varchar2(20),            /*单据号                                 */
luc12       varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
luc13       varchar2(1) DEFAULT ' ' NOT NULL, /*签核状态*/
luc14       varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
luc15       varchar2(10),            /*审核人                                 */
luc16       date,                    /*审核日期                               */
luc17       number(20,6) DEFAULT '0',/*未税应付金额                           */
luc17t      number(20,6) DEFAULT '0',/*含税应付金额                           */
luc18       varchar2(4),             /*税种                                   */
luc181      number(9,4),             /*税率                                   */
luc182      varchar2(1) DEFAULT ' ' NOT NULL, /*含税*/
luc19       varchar2(10),            /*no use 原门店编号                      */
lucacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
luccrat     date,                    /*资料创建日                             */
lucdate     date,                    /*最近更改日                             */
lucgrup     varchar2(10),            /*资料所有群                             */
luclegal    varchar2(10) NOT NULL,   /*所属法人                               */
lucmodu     varchar2(10),            /*资料更改者                             */
lucplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lucuser     varchar2(10),            /*资料所有者                             */
lucoriu     varchar2(10),            /*资料建立者                             */
lucorig     varchar2(10),            /*资料建立部门                           */
luc20       varchar2(1) DEFAULT ' ' NOT NULL, /*客户来源*/
luc21       date,                    /*立帐日期                               */
luc23       number(20,6),            /*退款金额                               */
luc24       number(20,6),            /*已退金额                               */
luc25       varchar2(1) DEFAULT ' ' NOT NULL, /*是否产生待抵*/
luc26       varchar2(10),            /*业务人员                               */
luc27       varchar2(10),            /*部门编号                               */
luccont     varchar2(8),             /*审核时间                               */
luc22       number(5),               /*合同版本号                             */
luc28       varchar2(20)             /*财务单号                               */
);

alter table luc_file add  constraint luc_pk primary key  (luc01) enable validate;
grant select on luc_file to tiptopgp;
grant update on luc_file to tiptopgp;
grant delete on luc_file to tiptopgp;
grant insert on luc_file to tiptopgp;
grant index on luc_file to public;
grant select on luc_file to ods;
