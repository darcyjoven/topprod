/*
================================================================================
檔案代號:bna_file
檔案名稱:保税系统单据性质档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bna_file
(
bna01       varchar2(5) NOT NULL,    /*单别                                   */
bna02       varchar2(80),            /*单据名称                               */
bna03       varchar2(1),             /*是否自动编号                           */
                                     /*Y/N                                    */
bna04       varchar2(1),             /*No Use                                 */
                                     /*1.依流水號 2.依年月                    */
bna05       varchar2(2),             /*单据性质                               */
                                     /*1.放行單                               */
                                     /*A.外送單(保稅機器設備管理)             */
                                     /*B.收回單(保稅機器設備管理)             */
                                     /*C.報廢單(保稅機器設備管理)             */
                                     /*D.除帳單(保稅機器設備管理)             */
bna06       varchar2(1),             /*区分                                   */
                                     /*區分: 1.保稅物品 2.免稅物品 3.非保稅物品*/
bna07       varchar2(1) DEFAULT 'N' NOT NULL, /*原始单据撷取前是否需要审核*/
bna08       varchar2(10),            /*保税原因代码                           */
bnaud01     varchar2(255),           /*自订字段                               */
bnaud02     varchar2(40),            /*自订字段                               */
bnaud03     varchar2(40),            /*自订字段                               */
bnaud04     varchar2(40),            /*自订字段                               */
bnaud05     varchar2(40),            /*自订字段                               */
bnaud06     varchar2(255),           /*自订字段                               */
bnaud07     number(15,3),            /*自订字段                               */
bnaud08     number(15,3),            /*自订字段                               */
bnaud09     number(15,3),            /*自订字段                               */
bnaud10     number(10),              /*自订字段                               */
bnaud11     number(10),              /*自订字段                               */
bnaud12     number(10),              /*自订字段                               */
bnaud13     date,                    /*自订字段                               */
bnaud14     date,                    /*自订字段                               */
bnaud15     date                     /*自订字段                               */
);

alter table bna_file add  constraint bna_pk primary key  (bna01) enable validate;
grant select on bna_file to tiptopgp;
grant update on bna_file to tiptopgp;
grant delete on bna_file to tiptopgp;
grant insert on bna_file to tiptopgp;
grant index on bna_file to public;
grant select on bna_file to ods;
