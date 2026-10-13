/*
================================================================================
檔案代號:lps_file
檔案名稱:发卡单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lps_file
(
lps01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
lps02       varchar2(10),            /*no use                                 */
lps03       date,                    /*单据日期                               */
lps04       number(20,2) DEFAULT '0' NOT NULL, /*消费金额底线合计*/
lps05       number(20,2) DEFAULT '0' NOT NULL, /*卡内金额合计*/
lps06       number(20,2),            /*折扣金额                               */
lps061      number(6,2),             /*折扣比率                               */
lps07       number(20,2) DEFAULT '0' NOT NULL, /*付款金额合计*/
lps08       varchar2(10),            /*发卡原因编号                           */
lps09       varchar2(1),             /*确认码                                 */
lps10       varchar2(10),            /*审核人                                 */
lps11       date,                    /*审核日期                               */
lps12       varchar2(50),            /*备注                                   */
lps13       number(20,2),            /*已付款金额                             */
lpsacti     varchar2(1),             /*资料有效码                             */
lpscrat     date,                    /*资料创建日                             */
lpsdate     date,                    /*资料更改日                             */
lpsgrup     varchar2(10),            /*资料所有群                             */
lpslegal    varchar2(10) NOT NULL,   /*所属法人                               */
lpsmodu     varchar2(10),            /*资料更改者                             */
lpsplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lpsuser     varchar2(10),            /*资料所有者                             */
lps14       varchar2(20),            /*帐款编号                               */
lps15       number(20,2),            /*单张购卡金额                           */
lps16       number(20,2),            /*购卡金额合计                           */
lpsoriu     varchar2(10),            /*资料建立者                             */
lpsorig     varchar2(10),            /*资料建立部门                           */
lps17       varchar2(20),            /*对应出货单号                           */
lps18       varchar2(20)             /*POS单号                                */
);

alter table lps_file add  constraint lps_pk primary key  (lps01) enable validate;
grant select on lps_file to tiptopgp;
grant update on lps_file to tiptopgp;
grant delete on lps_file to tiptopgp;
grant insert on lps_file to tiptopgp;
grant index on lps_file to public;
grant select on lps_file to ods;
