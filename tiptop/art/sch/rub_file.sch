/*
================================================================================
檔案代號:rub_file
檔案名稱:自动补货单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rub_file
(
rub01       varchar2(20) DEFAULT ' ' NOT NULL, /*补货建议单号*/
rub02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rub03       varchar2(40),            /*产品编号                               */
rub04       varchar2(4),             /*库存单位                               */
rub05       number(5),               /*周销量                                 */
rub06       number(5),               /*库存量                                 */
rub07       number(5),               /*可用库存                               */
rub08       number(5),               /*在途量                                 */
rub09       number(5),               /*建议补货量                             */
rub10       number(5),               /*请购量                                 */
rublegal    varchar2(10) NOT NULL,   /*所属法人                               */
rubplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rub11       varchar2(10)             /*供应商代号                             */
);

alter table rub_file add  constraint rub_pk primary key  (rub01,rub02) enable validate;
grant select on rub_file to tiptopgp;
grant update on rub_file to tiptopgp;
grant delete on rub_file to tiptopgp;
grant insert on rub_file to tiptopgp;
grant index on rub_file to public;
grant select on rub_file to ods;
