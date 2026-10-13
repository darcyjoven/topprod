/*
================================================================================
檔案代號:pmu_file
檔案名稱:一般料号收货替代原则档
檔案目的:一般料号收货替代原则档    单档多栏
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pmu_file
(
pmu01       varchar2(40) DEFAULT ' ' NOT NULL, /*料号*/
pmu02       varchar2(10) DEFAULT ' ' NOT NULL, /*供应商,*号代表不区分供应商, */
pmu03       number(5) DEFAULT '0' NOT NULL, /*起始码*/
pmu04       number(5) DEFAULT '0' NOT NULL, /*截止码*/
pmu05       varchar2(10) DEFAULT ' ' NOT NULL, /*原值*/
pmu06       varchar2(10) DEFAULT ' ' NOT NULL, /*替代值*/
pmu07       date DEFAULT sysdate NOT NULL, /*生效日期*/
pmu08       date                     /*失效日期                               */
);

alter table pmu_file add  constraint pmu_pk primary key  (pmu01,pmu02,pmu03,pmu04,pmu05,pmu06,pmu07) enable validate;
grant select on pmu_file to tiptopgp;
grant update on pmu_file to tiptopgp;
grant delete on pmu_file to tiptopgp;
grant insert on pmu_file to tiptopgp;
grant index on pmu_file to public;
grant select on pmu_file to ods;
