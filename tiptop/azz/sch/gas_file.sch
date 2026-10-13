/*
================================================================================
檔案代號:gas_file
檔案名稱:UI系统变数设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gas_file
(
gas01       varchar2(1) NOT NULL,    /*KEY VALUE (0)                          */
                                     /* VALUE (0)                             */
gas02       varchar2(15),            /*Not Null/Required (Head)               */
                                     /* Null/Required (Head)                  */
gas03       varchar2(15),            /*Not Null/Required (Detail)             */
                                     /*Null/Required (Detail)                 */
gas04       varchar2(15),            /*Key Value (Head/Detail)                */
                                     /*Value (Head/Detail)                    */
gas05       varchar2(15),            /*No Use                                 */
gas06       varchar2(1),             /*No Use                                 */
gas07       varchar2(1),             /*No Use                                 */
gas08       varchar2(1),             /*No Use                                 */
gas09       varchar2(1),             /*No Use                                 */
gas10       varchar2(1),             /*No Use                                 */
gasud01     varchar2(255),           /*自订字段                               */
gasud02     varchar2(40),            /*自订字段                               */
gasud03     varchar2(40),            /*自订字段                               */
gasud04     varchar2(40),            /*自订字段                               */
gasud05     varchar2(40),            /*自订字段                               */
gasud06     varchar2(255),           /*自订字段                               */
gasud07     number(15,3),            /*自订字段                               */
gasud08     number(15,3),            /*自订字段                               */
gasud09     number(15,3),            /*自订字段                               */
gasud10     number(10),              /*自订字段                               */
gasud11     number(10),              /*自订字段                               */
gasud12     number(10),              /*自订字段                               */
gasud13     date,                    /*自订字段                               */
gasud14     date,                    /*自订字段                               */
gasud15     date                     /*自订字段                               */
);

alter table gas_file add  constraint gas_pk primary key  (gas01) enable validate;
grant select on gas_file to tiptopgp;
grant update on gas_file to tiptopgp;
grant delete on gas_file to tiptopgp;
grant insert on gas_file to tiptopgp;
grant index on gas_file to public;
grant select on gas_file to ods;
