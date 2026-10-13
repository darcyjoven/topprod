/*
================================================================================
檔案代號:adq_file
檔案名稱:厂商库存异动档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table adq_file
(
adq01       varchar2(10) NOT NULL,   /*客户编号                               */
adq02       varchar2(40) NOT NULL,   /*产品编号                               */
adq03       varchar2(24) NOT NULL,   /*批号                                   */
adq04       date NOT NULL,           /*异动日期                               */
adq05       varchar2(20),            /*原始单据编号                           */
adq06       varchar2(4),             /*原始单位                               */
adq07       number(15,3),            /*原始数量                               */
adq08       number(20,8),            /*换算率                                 */
adq09       number(15,3),            /*异动数量                               */
adq10       varchar2(1)              /*异动区分                               */
);

alter table adq_file add  constraint adq_pk primary key  (adq01,adq02,adq03,adq04) enable validate;
grant select on adq_file to tiptopgp;
grant update on adq_file to tiptopgp;
grant delete on adq_file to tiptopgp;
grant insert on adq_file to tiptopgp;
grant index on adq_file to public;
grant select on adq_file to ods;
