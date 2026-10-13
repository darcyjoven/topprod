/*
================================================================================
檔案代號:lph_file
檔案名稱:卡种基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table lph_file
(
lph01       varchar2(20) DEFAULT ' ' NOT NULL, /*卡种编号*/
lph02       varchar2(30),            /*卡种名称                               */
lph03       varchar2(1) DEFAULT ' ' NOT NULL, /*可储值*/
lph04       varchar2(1) DEFAULT ' ' NOT NULL, /*会员价及会员促销*/
lph05       varchar2(1) DEFAULT ' ' NOT NULL, /*可折扣*/
lph06       varchar2(1) DEFAULT ' ' NOT NULL, /*可积分*/
lph07       varchar2(1) DEFAULT ' ' NOT NULL, /*可重复储值*/
lph08       number(6,2),             /*预设储值折扣比例                       */
lph09       varchar2(1) DEFAULT ' ' NOT NULL, /*有效期至*/
lph10       date,                    /*指定日期                               */
lph11       number(5),               /*月内有效                               */
lph12       varchar2(1) DEFAULT ' ' NOT NULL, /*是否有效期可延长*/
lph13       varchar2(1) DEFAULT ' ', /*延长规则                               */
lph14       number(20,2),            /*有效期内积分达                         */
lph15       number(20,2),            /*有效期内消费额度达                     */
lph16       number(20),              /*有效期内消费次数达                     */
lph17       varchar2(1) DEFAULT ' ' NOT NULL, /*积分是否清零*/
lph18       number(5),               /*月后清零                               */
lph19       number(5),               /*日后清零                               */
lph20       number(5),               /*卡累计积分大于日清零                   */
lph21       varchar2(1) DEFAULT ' ' NOT NULL, /*该卡属*/
lph22       number(20,2),            /*消费金额底线                           */
lph23       number(20,2),            /*购卡金额                               */
lph24       varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lph25       varchar2(10),            /*审核人                                 */
lph26       date,                    /*审核日期                               */
lph27       varchar2(1) DEFAULT ' ' NOT NULL, /*传POS否*/
lph28       number(20),              /*兑换基数                               */
lph29       number(20),              /*单位积分                               */
lphacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lphcrat     date,                    /*资料创建日                             */
lphdate     date,                    /*最近更改日                             */
lphgrup     varchar2(10),            /*资料所有群                             */
lphmodu     varchar2(10),            /*资料更改者                             */
lphuser     varchar2(10),            /*资料所有者                             */
lphoriu     varchar2(10),            /*资料建立者                             */
lphorig     varchar2(10),            /*资料建立部门                           */
lph30       number(6,2),             /*消費默認折扣                           */
lph31       varchar2(2),             /*指定日期清零(月)                       */
lph32       number(16) DEFAULT '0' NOT NULL, /*卡编号总位数*/
lph33       number(16) DEFAULT '0' NOT NULL, /*固定编号位数*/
lph34       varchar2(20),            /*固定编号                               */
lph35       number(16) DEFAULT '0' NOT NULL, /*流水号位数*/
lph36       varchar2(1) DEFAULT ' ' NOT NULL, /*参加会员卡折扣*/
lph311      varchar2(2),             /*指定日期清零(日)                       */
lphpos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
lph37       varchar2(1) DEFAULT 'N' NOT NULL,
lph38       number(20) DEFAULT '1' NOT NULL, /*积分基准*/
lph39       number(20,6) DEFAULT '1' NOT NULL,
lph40       varchar2(1) DEFAULT 'Y' NOT NULL,
lph41       number(20,6) DEFAULT '0' NOT NULL,
lph42       number(20,6) DEFAULT '0' NOT NULL,
lph43       number(20,6) DEFAULT '0' NOT NULL, /*每次储值金额上限*/
lph44       number(20,6) DEFAULT '0' NOT NULL, /*储值卡储值总金额上限*/
lph45       number(20,2) DEFAULT '0' NOT NULL,
lph46       varchar2(1) DEFAULT ' ' NOT NULL,
lph47       varchar2(4) DEFAULT ' ' NOT NULL, /*售卡税别*/
lph48       varchar2(4)              /*储值税别                               */
);

alter table lph_file add  constraint lph_pk primary key  (lph01) enable validate;
grant select on lph_file to tiptopgp;
grant update on lph_file to tiptopgp;
grant delete on lph_file to tiptopgp;
grant insert on lph_file to tiptopgp;
grant index on lph_file to public;
grant select on lph_file to ods;
