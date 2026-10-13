/*
================================================================================
檔案代號:lje_file
檔案名稱:商户终止报告单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lje_file
(
lje01       varchar2(20) DEFAULT ' ' NOT NULL, /*终止单号*/
lje02       date,                    /*单据日期                               */
lje03       varchar2(1) DEFAULT ' ' NOT NULL, /*终止类型*/
lje04       varchar2(20),            /*合约编号                               */
lje05       varchar2(20),            /*摊位编号                               */
lje06       varchar2(10),            /*商户编号                               */
lje07       varchar2(10),            /*经营小类                               */
lje08       varchar2(10),            /*主品牌                                 */
lje09       number(20,6),            /*建筑面积                               */
lje10       number(20,6),            /*測量面積                               */
lje11       number(20,6),            /*经营面积                               */
lje12       date,                    /*计租期限起日                           */
lje13       date,                    /*计租期限止日                           */
lje14       date,                    /*终止结算日                             */
lje15       number(20,6),            /*合同总额                               */
lje16       number(20,6),            /*原付款总额                             */
lje17       number(20,6),            /*应扣款总额                             */
lje18       varchar2(1) DEFAULT ' ' NOT NULL, /*违约方*/
lje19       number(5,2),             /*违约金比例                             */
lje20       number(20,6),            /*违约金额                               */
lje21       varchar2(10),            /*违约费用编号                           */
lje22       number(20,6),            /*应退款金额                             */
lje23       varchar2(10),            /*申请人                                 */
lje24       varchar2(10),            /*部门                                   */
lje25       varchar2(1) DEFAULT ' ' NOT NULL, /*状况码*/
lje26       varchar2(255),           /*备注                                   */
ljeacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
ljecond     date,                    /*审核日期                               */
ljeconf     varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
ljecont     varchar2(8),             /*审核时间                               */
ljeconu     varchar2(10),            /*审核人员                               */
ljecrat     date,                    /*资料创建日                             */
ljedate     date,                    /*最近更改日                             */
ljegrup     varchar2(10),            /*资料所有群                             */
ljelegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
ljemksg     varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
ljemodu     varchar2(10),            /*资料更改者                             */
ljeorig     varchar2(10),            /*资料建立部门                           */
ljeoriu     varchar2(10),            /*资料建立者                             */
ljeplant    varchar2(10) DEFAULT ' ' NOT NULL, /*门店编号*/
ljeuser     varchar2(10)             /*资料所有者                             */
);

alter table lje_file add  constraint lje_pk primary key  (lje01) enable validate;
grant select on lje_file to tiptopgp;
grant update on lje_file to tiptopgp;
grant delete on lje_file to tiptopgp;
grant insert on lje_file to tiptopgp;
grant index on lje_file to public;
grant select on lje_file to ods;
