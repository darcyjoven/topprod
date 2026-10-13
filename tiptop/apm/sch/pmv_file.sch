/*
================================================================================
檔案代號:pmv_file
檔案名稱:多属性料收货替代原则档
檔案目的:多属性料收货替代原则档 假双档
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pmv_file
(
pmv01       varchar2(40) DEFAULT ' ' NOT NULL, /*多属性母料号/多属性明细料号*/
pmv02       varchar2(10) DEFAULT ' ' NOT NULL, /*供应商编号*/
pmv03       varchar2(10) DEFAULT ' ' NOT NULL, /*属性代码*/
pmv04       varchar2(100) DEFAULT ' ' NOT NULL, /*属性值星号代表所有*/
pmv05       varchar2(100) DEFAULT ' ' NOT NULL, /*可替代属性值*/
pmv06       varchar2(1) DEFAULT ' ' NOT NULL, /*同属性群组都可以替代*/
pmv07       varchar2(80),            /*属性值说明                             */
pmv08       varchar2(80),            /*可替代属性值说明                       */
pmv09       date DEFAULT sysdate NOT NULL, /*生效日期*/
pmv10       date                     /*失效日期                               */
);

alter table pmv_file add  constraint pmv_pk primary key  (pmv01,pmv02,pmv03,pmv04,pmv05,pmv06) enable validate;
grant select on pmv_file to tiptopgp;
grant update on pmv_file to tiptopgp;
grant delete on pmv_file to tiptopgp;
grant insert on pmv_file to tiptopgp;
grant index on pmv_file to public;
grant select on pmv_file to ods;
