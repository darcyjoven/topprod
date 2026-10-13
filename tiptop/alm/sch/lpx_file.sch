/*
================================================================================
檔案代號:lpx_file
檔案名稱:券种维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table lpx_file
(
lpx01       varchar2(20) DEFAULT ' ' NOT NULL, /*券种编号*/
lpx02       varchar2(20),            /*券种名称                               */
lpx03       date,                    /*生效日期                               */
lpx04       date,                    /*截止日期                               */
lpx05       varchar2(1) DEFAULT ' ' NOT NULL, /*允许找零*/
lpx06       varchar2(1) DEFAULT ' ' NOT NULL, /*电子礼券*/
lpx07       varchar2(1) DEFAULT ' ' NOT NULL, /*可返券*/
lpx08       varchar2(1) DEFAULT ' ' NOT NULL, /*是否满额收券*/
lpx09       varchar2(1) DEFAULT ' ' NOT NULL, /*未到期可返*/
lpx10       number(20,2),            /*满额收券                               */
lpx11       varchar2(1) DEFAULT ' ' NOT NULL, /*不可与其他券一起使用*/
lpx12       varchar2(1) DEFAULT ' ' NOT NULL, /*可积分*/
lpx13       varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
lpx14       varchar2(1) DEFAULT ' ' NOT NULL, /*签核状态*/
lpx15       varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lpx16       varchar2(10),            /*审核人                                 */
lpx17       date,                    /*审核日期                               */
lpx18       varchar2(50),            /*备注                                   */
lpx19       varchar2(24),            /*会计科目一                             */
lpx20       varchar2(24),            /*会计科目二                             */
lpx21       number(16),              /*券编号总位数                           */
lpx22       number(16),              /*固定编号位数                           */
lpx23       varchar2(20),            /*固定编号                               */
lpx24       number(16),              /*流水号位数                             */
lpx25       varchar2(1) DEFAULT ' ' NOT NULL, /*no use*/
lpx26       varchar2(1) DEFAULT ' ', /*展开类型                               */
lpx27       varchar2(1) DEFAULT ' ' NOT NULL, /*等同现金*/
lpx28       varchar2(10) DEFAULT ' ',/*礼券面额码                             */
lpx29       number(13,2),            /*最大找零金额                           */
lpx30       number(2),               /*POS款别                                */
lpx31       varchar2(1) DEFAULT ' ' NOT NULL, /*可否用于促销*/
lpxacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lpxcrat     date,                    /*资料创建日                             */
lpxdate     date,                    /*最近更改日                             */
lpxgrup     varchar2(10),            /*资料所有群                             */
lpxmodu     varchar2(10),            /*资料更改者                             */
lpxuser     varchar2(10),            /*资料所有者                             */
lpxoriu     varchar2(10),            /*资料建立者                             */
lpxorig     varchar2(10),            /*资料建立部门                           */
lpx32       varchar2(40),            /*券對應产品                             */
lpxpos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
lpx33       varchar2(4),             /*税种                                   */
lpx34       varchar2(1) DEFAULT '2' NOT NULL, /*进/销项*/
lpx35       number(20,6),            /*收券金额                               */
lpx36       varchar2(1) DEFAULT 'N' NOT NULL, /*是否计算递延金额*/
lpx37       number(6,2),             /*折扣券折扣                             */
lpx38       varchar2(1) DEFAULT ' ' NOT NULL /*已开发票否*/
);

alter table lpx_file add  constraint lpx_pk primary key  (lpx01) enable validate;
grant select on lpx_file to tiptopgp;
grant update on lpx_file to tiptopgp;
grant delete on lpx_file to tiptopgp;
grant insert on lpx_file to tiptopgp;
grant index on lpx_file to public;
grant select on lpx_file to ods;
