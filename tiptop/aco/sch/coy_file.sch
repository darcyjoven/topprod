/*
================================================================================
檔案代號:coy_file
檔案名稱:合同系统单据性质档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table coy_file
(
coyslip     varchar2(5) NOT NULL,    /*单别                                   */
coydesc     varchar2(80),            /*单据名称                               */
coyauno     varchar2(1),             /*自动编号否                             */
coymxno     varchar2(20),            /*已用单号                               */
coykind     varchar2(1),             /*No Use                                 */
coyconf     varchar2(1),             /*立即审核                               */
coyprit     varchar2(1),             /*立即打印                               */
coytype     varchar2(2),             /*单据性质                               */
coyslip2    varchar2(5),             /*对应单别                               */
coyacti     varchar2(1),             /*资料有效码                             */
coyuser     varchar2(10),            /*资料所有者                             */
coygrup     varchar2(10),            /*资料所有部门                           */
coymodu     varchar2(10),            /*资料更改者                             */
coydate     date,                    /*最近更改日                             */
coyorig     varchar2(10),            /*资料建立部门                           */
coyoriu     varchar2(10),            /*资料建立者                             */
coyud01     varchar2(255),           /*自订字段                               */
coyud02     varchar2(40),            /*自订字段                               */
coyud03     varchar2(40),            /*自订字段                               */
coyud04     varchar2(40),            /*自订字段                               */
coyud05     varchar2(40),            /*自订字段                               */
coyud06     varchar2(255),           /*自订字段                               */
coyud07     number(15,3),            /*自订字段                               */
coyud08     number(15,3),            /*自订字段                               */
coyud09     number(15,3),            /*自订字段                               */
coyud10     number(10),              /*自订字段                               */
coyud11     number(10),              /*自订字段                               */
coyud12     number(10),              /*自订字段                               */
coyud13     date,                    /*自订字段                               */
coyud14     date,                    /*自订字段                               */
coyud15     date                     /*自订字段                               */
);

alter table coy_file add  constraint coy_pk primary key  (coyslip) enable validate;
grant select on coy_file to tiptopgp;
grant update on coy_file to tiptopgp;
grant delete on coy_file to tiptopgp;
grant insert on coy_file to tiptopgp;
grant index on coy_file to public;
grant select on coy_file to ods;
