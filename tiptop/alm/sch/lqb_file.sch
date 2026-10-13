/*
================================================================================
檔案代號:lqb_file
檔案名稱:券核销记录单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lqb_file
(
lqb01       varchar2(20) DEFAULT ' ' NOT NULL, /*核销单号*/
lqb02       varchar2(20) DEFAULT ' ' NOT NULL, /*券编号*/
lqb03       varchar2(20),            /*券种编号                               */
lqb04       varchar2(10),            /*券面额编号                             */
lqb05       varchar2(1),             /*券原始状态                             */
lqb06       date,                    /*原始状态日期                           */
lqb07       varchar2(1),             /*核销状态                               */
lqb08       number(20),              /*核销次数                               */
lqblegal    varchar2(10) NOT NULL,   /*所属法人                               */
lqbplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table lqb_file add  constraint lqb_pk primary key  (lqb01,lqb02) enable validate;
grant select on lqb_file to tiptopgp;
grant update on lqb_file to tiptopgp;
grant delete on lqb_file to tiptopgp;
grant insert on lqb_file to tiptopgp;
grant index on lqb_file to public;
grant select on lqb_file to ods;
