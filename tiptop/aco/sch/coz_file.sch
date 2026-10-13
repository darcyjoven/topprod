/*
================================================================================
檔案代號:coz_file
檔案名稱:海关合同参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table coz_file
(
coz00       varchar2(1) NOT NULL,    /*KEY VALUE = '0'                        */
coz01       varchar2(1),             /*当前海关系统可开放给用户使             */
coz02       varchar2(10),            /*缺省海关编号                           */
coz03       varchar2(1),             /*海关编号                               */
coz04       varchar2(1),             /*No Use                                 */
coz05       varchar2(1),             /*No Use                                 */
coz06       number(5),               /*No Use                                 */
coz07       number(5),               /*No Use                                 */
coz08       number(5),               /*No Use                                 */
coz09       number(5),               /*No Use                                 */
coz10       number(5),               /*No Use                                 */
cozud01     varchar2(255),           /*自订字段                               */
cozud02     varchar2(40),            /*自订字段                               */
cozud03     varchar2(40),            /*自订字段                               */
cozud04     varchar2(40),            /*自订字段                               */
cozud05     varchar2(40),            /*自订字段                               */
cozud06     varchar2(255),           /*自订字段                               */
cozud07     number(15,3),            /*自订字段                               */
cozud08     number(15,3),            /*自订字段                               */
cozud09     number(15,3),            /*自订字段                               */
cozud10     number(10),              /*自订字段                               */
cozud11     number(10),              /*自订字段                               */
cozud12     number(10),              /*自订字段                               */
cozud13     date,                    /*自订字段                               */
cozud14     date,                    /*自订字段                               */
cozud15     date                     /*自订字段                               */
);

alter table coz_file add  constraint coz_pk primary key  (coz00) enable validate;
grant select on coz_file to tiptopgp;
grant update on coz_file to tiptopgp;
grant delete on coz_file to tiptopgp;
grant insert on coz_file to tiptopgp;
grant index on coz_file to public;
grant select on coz_file to ods;
