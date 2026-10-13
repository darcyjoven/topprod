/*
================================================================================
檔案代號:lpy_file
檔案名稱:券异动单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lpy_file
(
lpy01       varchar2(1) DEFAULT ' ' NOT NULL, /*单据类型*/
lpy02       varchar2(20) DEFAULT ' ' NOT NULL, /*单据号*/
lpy03       varchar2(10),            /*no use 原门店编号                      */
lpy04       varchar2(20),            /*券种编号                               */
lpy05       varchar2(10),            /*券面额编号                             */
lpy06       number(20),              /*券张数                                 */
lpy07       number(20,2),            /*总金额                                 */
lpy08       number(6,2),             /*折扣率                                 */
lpy09       number(20,2),            /*折扣金额                               */
lpy10       number(20,2),            /*实际金额                               */
lpy11       varchar2(1),             /*是否签核                               */
lpy12       varchar2(1),             /*签核状态                               */
lpy13       varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lpy14       varchar2(10),            /*审核人                                 */
lpy15       date,                    /*审核日期                               */
lpy16       varchar2(50),            /*备注                                   */
lpy17       date,                    /*日期                                   */
lpyacti     varchar2(1),             /*资料有效码                             */
lpycrat     date,                    /*资料创建日                             */
lpydate     date,                    /*最近更改日                             */
lpygrup     varchar2(10),            /*资料所有群                             */
lpylegal    varchar2(10) NOT NULL,   /*所属法人                               */
lpymodu     varchar2(10),            /*资料更改者                             */
lpyplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lpyuser     varchar2(10),            /*资料所有者                             */
lpyoriu     varchar2(10),            /*资料建立者                             */
lpyorig     varchar2(10),            /*资料建立部门                           */
lpy18       varchar2(20),            /*来源单号                               */
lpy19       varchar2(10)             /*发放(回收)营运中心                     */
);

alter table lpy_file add  constraint lpy_pk primary key  (lpy02) enable validate;
grant select on lpy_file to tiptopgp;
grant update on lpy_file to tiptopgp;
grant delete on lpy_file to tiptopgp;
grant insert on lpy_file to tiptopgp;
grant index on lpy_file to public;
grant select on lpy_file to ods;
