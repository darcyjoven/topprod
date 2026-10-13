/*
================================================================================
檔案代號:lsd_file
檔案名稱:广告位合同变更资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lsd_file
(
lsd01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同号*/
lsd02       varchar2(20) DEFAULT ' ' NOT NULL, /*版本号*/
lsd03       varchar2(10),            /*商户号                                 */
lsd04       varchar2(20),            /*广告位编号                             */
lsd05       date,                    /*租赁期起始                             */
lsd06       date,                    /*租赁期截止                             */
lsd07       date,                    /*签订日期                               */
lsd08       number(20,2),            /*定金                                   */
lsd09       number(20,2),            /*合同金额                               */
lsd10       varchar2(10),            /*终止人                                 */
lsd11       date,                    /*终止日期                               */
lsd12       varchar2(1),             /*是否签核                               */
lsd13       varchar2(1),             /*签核状态                               */
lsd14       varchar2(1),             /*审核码                                 */
lsd15       varchar2(10),            /*审核人                                 */
lsd16       date,                    /*审核日期                               */
lsd17       varchar2(10),            /*no use 原门店编号                      */
lsd18       varchar2(1),             /*是否发出变更                           */
lsd19       varchar2(4),             /*税种                                   */
lsd20       number(9,4),             /*税率                                   */
lsd21       varchar2(1),             /*含税否                                 */
lsdcrat     date,                    /*资料创建日                             */
lsddate     date,                    /*最近更改日                             */
lsdgrup     varchar2(10),            /*资料所有群                             */
lsdlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lsdmodu     varchar2(10),            /*资料更改者                             */
lsdplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lsduser     varchar2(10),            /*资料所有者                             */
lsdoriu     varchar2(10),            /*资料建立者                             */
lsdorig     varchar2(10)             /*资料建立部门                           */
);

alter table lsd_file add  constraint lsd_pk primary key  (lsd01,lsd02) enable validate;
grant select on lsd_file to tiptopgp;
grant update on lsd_file to tiptopgp;
grant delete on lsd_file to tiptopgp;
grant insert on lsd_file to tiptopgp;
grant index on lsd_file to public;
grant select on lsd_file to ods;
