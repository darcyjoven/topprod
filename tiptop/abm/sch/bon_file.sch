/*
================================================================================
檔案代號:bon_file
檔案名稱:替代规则维护明细资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table bon_file
(
bon01       varchar2(40) DEFAULT ' ' NOT NULL, /*原始料件*/
bon02       varchar2(40) DEFAULT ' ' NOT NULL, /*主件编号*/
bon03       number(5) NOT NULL,      /*项次                                   */
bon04       number(15,3) DEFAULT '0' NOT NULL,
bon05       number(15,3) DEFAULT '0' NOT NULL,
bon06       varchar2(4) DEFAULT ' ' NOT NULL,
bon07       varchar2(10),            /*材料类型                               */
bon08       varchar2(10),            /*主要供应商                             */
bon09       date,                    /*生效日期                               */
bon10       date,                    /*失效日期                               */
bon11       number(15,3) DEFAULT '0' NOT NULL, /*取代替代量*/
bon12       date,                    /*实际取代日/最近替代日                  */
bon13       varchar2(1) DEFAULT ' ' NOT NULL, /*NO USER-檔案類別 (1.取代 2.替代)*/
bonacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
bondate     date,                    /*最近更改日                             */
bongrup     varchar2(10),            /*资料所有部门                           */
bonmodu     varchar2(10),            /*资料更改者                             */
bonorig     varchar2(10),            /*资料建立部门                           */
bonoriu     varchar2(10),            /*资料建立者                             */
bonuser     varchar2(10)             /*资料所有者                             */
);

alter table bon_file add  constraint bon_pk primary key  (bon01,bon02,bon03) enable validate;
grant select on bon_file to tiptopgp;
grant update on bon_file to tiptopgp;
grant delete on bon_file to tiptopgp;
grant insert on bon_file to tiptopgp;
grant index on bon_file to public;
grant select on bon_file to ods;
