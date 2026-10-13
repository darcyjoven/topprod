/*
================================================================================
檔案代號:azw_file
檔案名稱:集团架构资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table azw_file
(
azw01       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心代码*/
azw02       varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人编号*/
azw03       varchar2(10),            /*行业别                                 */
azw04       varchar2(1),             /*业态                                   */
azw05       varchar2(20),            /*实体DB                                 */
azw06       varchar2(20),            /*登入DB                                 */
azw07       varchar2(10),            /*上级营运中心                           */
azwacti     varchar2(1),             /*资料有效码                             */
azwdate     date,                    /*最近更改日                             */
azwgrup     varchar2(10),            /*资料所有部门                           */
azwmodu     varchar2(10),            /*资料更改者                             */
azwuser     varchar2(10),            /*资料所有者                             */
azworig     varchar2(10),            /*资料建立部门                           */
azworiu     varchar2(10),            /*资料建立者                             */
azw08       varchar2(80),            /*营运中心名称                           */
azw09       varchar2(20),
azwud01     varchar2(255),           /*自订字段                               */
azwud02     varchar2(40),            /*自订字段                               */
azwud03     varchar2(40),            /*自订字段                               */
azwud04     varchar2(40),            /*自订字段                               */
azwud05     varchar2(40),            /*自订字段                               */
azwud06     varchar2(255),           /*自订字段                               */
azwud07     number(15,3),            /*自订字段                               */
azwud08     number(15,3),            /*自订字段                               */
azwud09     number(15,3),            /*自订字段                               */
azwud10     number(10),              /*自订字段                               */
azwud11     number(10),              /*自订字段                               */
azwud12     number(10),              /*自订字段                               */
azwud13     date,                    /*自订字段                               */
azwud14     date,                    /*自订字段                               */
azwud15     date                     /*自订字段                               */
);

grant select on azw_file to tiptopgp;
grant update on azw_file to tiptopgp;
grant delete on azw_file to tiptopgp;
grant insert on azw_file to tiptopgp;
grant index on azw_file to public;
grant select on azw_file to ods;
