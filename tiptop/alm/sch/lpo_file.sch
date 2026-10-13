/*
================================================================================
檔案代號:lpo_file
檔案名稱:会员补积分档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lpo_file
(
lpo00       varchar2(40),            /*no use                                 */
lpo01       varchar2(20) DEFAULT ' ' NOT NULL, /*补积分单编号*/
lpo02       varchar2(30),            /*会员卡号                               */
lpo03       varchar2(20),            /*会员编号                               */
lpo04       number(20),              /*原积分                                 */
lpo05       number(20,2),            /*NoUse                                  */
lpo06       number(20),              /*此次补扣积分                           */
lpo07       varchar2(1),             /*审核                                   */
lpo08       varchar2(10),            /*审核人                                 */
lpo09       date,                    /*审核日期                               */
lpoacti     varchar2(1),             /*资料有效码                             */
lpocrat     date,                    /*资料创建日                             */
lpodate     date,                    /*资料更改日期                           */
lpogrup     varchar2(10),            /*资料所有群                             */
lpolegal    varchar2(10) NOT NULL,   /*所属法人                               */
lpomodu     varchar2(10),            /*资料更改者                             */
lpoplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lpouser     varchar2(10),            /*资料所有者                             */
lpooriu     varchar2(10),            /*资料建立者                             */
lpoorig     varchar2(10),            /*资料建立部门                           */
lpo10       date,                    /*积分有效期至                           */
lpo11       varchar2(20)             /*发票号码                               */
);

alter table lpo_file add  constraint lpo_pk primary key  (lpo01) enable validate;
grant select on lpo_file to tiptopgp;
grant update on lpo_file to tiptopgp;
grant delete on lpo_file to tiptopgp;
grant insert on lpo_file to tiptopgp;
grant index on lpo_file to public;
grant select on lpo_file to ods;
