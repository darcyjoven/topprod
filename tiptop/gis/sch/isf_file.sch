/*
================================================================================
檔案代號:isf_file
檔案名稱:GIS系统参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table isf_file
(
isf00       varchar2(1) NOT NULL,    /*key value = '0'                        */
isf01       varchar2(1),             /*发票汇出时,单价是含税/税前             */
isf02       varchar2(8),             /*商品类型                               */
isf03       varchar2(1),             /*No Use                                 */
isf04       varchar2(1),             /*No Use                                 */
isf05       varchar2(1),             /*No Use                                 */
isf06       varchar2(1),             /*No Use                                 */
isf07       varchar2(10),            /*No Use                                 */
isf08       varchar2(10),            /*No Use                                 */
isf09       varchar2(10),            /*No Use                                 */
isf10       varchar2(10),            /*No Use                                 */
isf11       number(10),              /*No Use                                 */
isf12       number(10),              /*No Use                                 */
isf13       number(10),              /*No Use                                 */
isf14       number(10),              /*No Use                                 */
isf15       number(10),              /*No Use                                 */
isf16       date,                    /*No Use                                 */
isf17       date,                    /*No Use                                 */
isfud01     varchar2(255),           /*自订字段                               */
isfud02     varchar2(40),            /*自订字段                               */
isfud03     varchar2(40),            /*自订字段                               */
isfud04     varchar2(40),            /*自订字段                               */
isfud05     varchar2(40),            /*自订字段                               */
isfud06     varchar2(255),           /*自订字段                               */
isfud07     number(15,3),            /*自订字段                               */
isfud08     number(15,3),            /*自订字段                               */
isfud09     number(15,3),            /*自订字段                               */
isfud10     number(10),              /*自订字段                               */
isfud11     number(10),              /*自订字段                               */
isfud12     number(10),              /*自订字段                               */
isfud13     date,                    /*自订字段                               */
isfud14     date,                    /*自订字段                               */
isfud15     date                     /*自订字段                               */
);

alter table isf_file add  constraint isf_pk primary key  (isf00) enable validate;
grant select on isf_file to tiptopgp;
grant update on isf_file to tiptopgp;
grant delete on isf_file to tiptopgp;
grant insert on isf_file to tiptopgp;
grant index on isf_file to public;
grant select on isf_file to ods;
