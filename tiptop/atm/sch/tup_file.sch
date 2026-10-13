/*
================================================================================
檔案代號:tup_file
檔案名稱:客户库存明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table tup_file
(
tup01       varchar2(10) NOT NULL,   /*客户编号                               */
tup02       varchar2(40) NOT NULL,   /*产品编号                               */
tup03       varchar2(24) NOT NULL,   /*批号                                   */
tup04       varchar2(4),             /*库存单位                               */
tup05       number(15,3),            /*库存数量                               */
tup06       date,                    /*有效日期                               */
tup07       date,                    /*第一次入库日                           */
tup11       varchar2(1) NOT NULL,    /*库存类型                               */
tup12       varchar2(10) NOT NULL,   /*送货客户                               */
tup08       varchar2(1),             /*No Use                                 */
tup09       varchar2(10),            /*No Use                                 */
tupplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tuplegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table tup_file add  constraint tup_pk primary key  (tup01,tup02,tup03,tup11,tup12) enable validate;
grant select on tup_file to tiptopgp;
grant update on tup_file to tiptopgp;
grant delete on tup_file to tiptopgp;
grant insert on tup_file to tiptopgp;
grant index on tup_file to public;
grant select on tup_file to ods;
