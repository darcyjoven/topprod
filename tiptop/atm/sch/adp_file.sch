/*
================================================================================
檔案代號:adp_file
檔案名稱:NO USE
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table adp_file
(
adp01       varchar2(10) NOT NULL,   /*客户编号                               */
adp02       varchar2(40) NOT NULL,   /*产品编号                               */
adp03       varchar2(24) NOT NULL,   /*批号                                   */
adp04       varchar2(4),             /*库存单位                               */
adp05       number(15,3),            /*库存数量                               */
adp06       date,                    /*有效日期                               */
adp07       date                     /*第一次入库日期                         */
);

alter table adp_file add  constraint adp_pk primary key  (adp01,adp02,adp03) enable validate;
grant select on adp_file to tiptopgp;
grant update on adp_file to tiptopgp;
grant delete on adp_file to tiptopgp;
grant insert on adp_file to tiptopgp;
grant index on adp_file to public;
grant select on adp_file to ods;
