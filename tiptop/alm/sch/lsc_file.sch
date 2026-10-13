/*
================================================================================
檔案代號:lsc_file
檔案名稱:广告位合同资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lsc_file
(
lsc01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同号*/
lsc02       varchar2(20),            /*版本号                                 */
lsc03       varchar2(10),            /*商户号                                 */
lsc04       varchar2(20),            /*广告位编号                             */
lsc05       date,                    /*租赁期起始                             */
lsc06       date,                    /*租赁期截止                             */
lsc07       date,                    /*签订日期                               */
lsc08       number(20,2),            /*定金                                   */
lsc09       number(20,2),            /*合同金额                               */
lsc10       varchar2(10),            /*终止人                                 */
lsc11       date,                    /*终止日期                               */
lsc12       varchar2(1),             /*是否签核                               */
lsc13       varchar2(1),             /*签核状态                               */
lsc14       varchar2(1),             /*审核码                                 */
lsc15       varchar2(10),            /*审核人                                 */
lsc16       date,                    /*审核日期                               */
lsc17       varchar2(10),            /*no use 原门店编号                      */
lsc18       varchar2(4),             /*税种                                   */
lsc19       number(9,4),             /*税率                                   */
lsc20       varchar2(1),             /*含税否                                 */
lsccrat     date,                    /*资料创建日                             */
lscdate     date,                    /*最近更改日                             */
lscgrup     varchar2(10),            /*资料所有群                             */
lsclegal    varchar2(10) NOT NULL,   /*所属法人                               */
lscmodu     varchar2(10),            /*资料更改者                             */
lscuser     varchar2(10),            /*资料所有者                             */
lscoriu     varchar2(10),            /*资料建立者                             */
lscorig     varchar2(10),            /*资料建立部门                           */
lscstore    varchar2(10) DEFAULT ' ' NOT NULL, /*门店编号*/
lsc21       varchar2(10),            /*订金费用编号                           */
lsc22       varchar2(10),            /*合同费用编号                           */
lsc23       varchar2(20)             /*费用单号                               */
);

alter table lsc_file add  constraint lsc_pk primary key  (lsc01) enable validate;
grant select on lsc_file to tiptopgp;
grant update on lsc_file to tiptopgp;
grant delete on lsc_file to tiptopgp;
grant insert on lsc_file to tiptopgp;
grant index on lsc_file to public;
grant select on lsc_file to ods;
