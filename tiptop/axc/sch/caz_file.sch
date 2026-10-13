/*
================================================================================
檔案代號:caz_file
檔案名稱:成本分摊权数及金额档-成本中心
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table caz_file
(
caz00       varchar2(1) NOT NULL,    /*分摊类别 (1:人工 2:制费一 3:制         */
caz01       number(5) NOT NULL,      /*年度                                   */
caz02       number(5) NOT NULL,      /*月份                                   */
caz03       varchar2(10) NOT NULL,   /*直接部门                               */
caz04       varchar2(24) NOT NULL,   /*会计科目                               */
caz05       number(20,6),            /*当期余额 (含分摊金额)                  */
caz06       varchar2(10) NOT NULL,   /*成本中心                               */
caz07       number(15,3),            /*分摊权数                               */
caz08       number(15,3),            /*约当产量                               */
caz09       number(15,3),            /*分摊权量                               */
caz10       number(20,6),            /*分摊金额                               */
cazlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table caz_file add  constraint caz_pk primary key  (caz00,caz01,caz02,caz03,caz04,caz06) enable validate;
grant select on caz_file to tiptopgp;
grant update on caz_file to tiptopgp;
grant delete on caz_file to tiptopgp;
grant insert on caz_file to tiptopgp;
grant index on caz_file to public;
grant select on caz_file to ods;
