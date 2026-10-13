/*
================================================================================
檔案代號:jce_file
檔案名稱:不纳入计算成本库维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table jce_file
(
jce01       varchar2(10) NOT NULL,   /*成本仓库                               */
                                     /*成本庫別                               */
jce02       varchar2(10) NOT NULL,   /*仓库编号                               */
                                     /*倉庫編號                               */
jce03       varchar2(1),             /*NO USE                                 */
                                     /*計算順序                               */
jce04       varchar2(1),             /*No Use                                 */
jce05       varchar2(1),             /*No Use                                 */
jceacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
jceuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
jcegrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
jcemodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
jcedate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
jceorig     varchar2(10),            /*资料建立部门                           */
jceoriu     varchar2(10)             /*资料建立者                             */
);

alter table jce_file add  constraint jce_pk primary key  (jce01,jce02) enable validate;
grant select on jce_file to tiptopgp;
grant update on jce_file to tiptopgp;
grant delete on jce_file to tiptopgp;
grant insert on jce_file to tiptopgp;
grant index on jce_file to public;
grant select on jce_file to ods;
