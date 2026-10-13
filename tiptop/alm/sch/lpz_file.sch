/*
================================================================================
檔案代號:lpz_file
檔案名稱:券异动单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lpz_file
(
lpz01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据类型*/
lpz02       varchar2(20) DEFAULT ' ',/*券种编号                               */
lpz03       varchar2(20),            /*no use 原门店编号                      */
lpz04       varchar2(20) DEFAULT ' ',/*券编号                                 */
lpz05       number(5) DEFAULT '0' NOT NULL, /*项次*/
lpzlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lpzplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lpz06       varchar2(1) DEFAULT ' ' NOT NULL, /*折扣金额*/
lpz07       varchar2(10),            /*券面额编号                             */
lpz08       number(20),              /*券张数                                 */
lpz09       number(20,2),            /*总金额                                 */
lpz10       number(6,2),             /*折扣率                                 */
lpz11       number(20,2),            /*折扣金额                               */
lpz12       number(20,2),            /*实际金额                               */
lpz13       date,                    /*生效日期                               */
lpz14       date,                    /*截止日期                               */
lpz15       varchar2(10),            /*发售门店编号                           */
lpz16       varchar2(20),            /*订单号                                 */
lpz17       number(5),               /*项次                                   */
lpzacti     varchar2(1) DEFAULT ' ' NOT NULL, /*no use.*/
lpzpos      varchar2(1) DEFAULT '1' NOT NULL /*已传POS否*/
);

alter table lpz_file add  constraint lpz_pk primary key  (lpz01,lpz05) enable validate;
grant select on lpz_file to tiptopgp;
grant update on lpz_file to tiptopgp;
grant delete on lpz_file to tiptopgp;
grant insert on lpz_file to tiptopgp;
grant index on lpz_file to public;
grant select on lpz_file to ods;
