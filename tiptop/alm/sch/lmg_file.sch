/*
================================================================================
檔案代號:lmg_file
檔案名稱:场地摊位关系单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmg_file
(
lmg01       varchar2(20) DEFAULT ' ' NOT NULL, /*场地摊位关系单号*/
lmg02       varchar2(20),            /*摊位编号                               */
lmg03       varchar2(10),            /*no use 原门店编号                      */
lmg04       varchar2(10),            /*楼栋编号                               */
lmg05       varchar2(10),            /*楼层编号                               */
lmg06       number(20,2),            /*总经营面积                             */
lmg07       number(20,2),            /*总建筑面积                             */
lmg08       varchar2(1),             /*确认码                                 */
lmg09       varchar2(10),            /*审核人                                 */
lmg10       date,                    /*审核日期                               */
lmg11       varchar2(50),            /*备注                                   */
lmg12       varchar2(10),            /*终止人                                 */
lmg13       date,                    /*终止日期                               */
lmgcrat     date,                    /*资料创建日                             */
lmgdate     date,                    /*最近更改日                             */
lmggrup     varchar2(10),            /*资料所有群                             */
lmglegal    varchar2(10) NOT NULL,   /*所属法人                               */
lmgmodu     varchar2(10),            /*资料更改者                             */
lmguser     varchar2(10),            /*资料所有者                             */
lmgoriu     varchar2(10),            /*资料建立者                             */
lmgorig     varchar2(10),            /*资料建立部门                           */
lmgstore    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table lmg_file add  constraint lmg_pk primary key  (lmg01) enable validate;
grant select on lmg_file to tiptopgp;
grant update on lmg_file to tiptopgp;
grant delete on lmg_file to tiptopgp;
grant insert on lmg_file to tiptopgp;
grant index on lmg_file to public;
grant select on lmg_file to ods;
