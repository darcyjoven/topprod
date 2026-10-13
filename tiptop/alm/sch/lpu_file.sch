/*
================================================================================
檔案代號:lpu_file
檔案名稱:储值卡充值记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lpu_file
(
lpu01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
lpu02       varchar2(10),            /*no use                                 */
lpu03       varchar2(30),            /*储值卡编号                             */
lpu04       number(20,2),            /*储值卡余额                             */
lpu05       number(20,2),            /*充值金额                               */
lpu06       number(20,2),            /*实付金额                               */
lpu07       number(20,2),            /*折扣金额                               */
lpu071      number(6,2),             /*折扣比率                               */
lpu08       varchar2(1),             /*确认码                                 */
lpu09       varchar2(10),            /*审核人                                 */
lpu10       date,                    /*审核日期                               */
lpu11       varchar2(50),            /*备注                                   */
lpu12       number(20,2),            /*已付款金额                             */
lpu13       varchar2(20),            /*帐款编号                               */
lpuacti     varchar2(1),             /*资料有效码                             */
lpucrat     date,                    /*资料创建日                             */
lpudate     date,                    /*资料更改日                             */
lpugrup     varchar2(10),            /*资料所有群                             */
lpulegal    varchar2(10) NOT NULL,   /*所属法人                               */
lpumodu     varchar2(10),            /*资料更改者                             */
lpuplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lpuuser     varchar2(10),            /*资料所有者                             */
lpuoriu     varchar2(10),            /*资料建立者                             */
lpuorig     varchar2(10),            /*资料建立部门                           */
lpu14       date,                    /*金额有效期至                           */
lpu15       number(20,6) DEFAULT '0' NOT NULL, /*加值金额*/
lpu16       varchar2(20),            /*对应出货单号                           */
lpu17       varchar2(20)             /*POS单号                                */
);

alter table lpu_file add  constraint lpu_pk primary key  (lpu01) enable validate;
grant select on lpu_file to tiptopgp;
grant update on lpu_file to tiptopgp;
grant delete on lpu_file to tiptopgp;
grant insert on lpu_file to tiptopgp;
grant index on lpu_file to public;
grant select on lpu_file to ods;
